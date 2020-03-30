class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :parse_request

  def receive
    if @data.any?
      hook = Webhook.new(data: @data, event_id: @data["id"], integration_name: 'urbem')
      if hook.save
        update_catastro(@data)
        puts 'Event ' + hook.id.to_s + ' successfully saved.'
        render json: { status: 201 }
      else
        render json: { status: 400, error: "It wasn't u, it's me." } and return
      end
    end
  end

  def update_catastro(data)
    begin
      param = data['custom_data']['Clave catastral']
      conn = Faraday.new('https://sistema-externo.herokuapp.com/')
      url = '/api/v1/catastro?clave=' + param.to_s
      response = conn.get(url) do |req|
        conn.options.timeout = 0.4
        conn.request :retry, max: 1, interval: 0.05
      end
      if response.status == 200
        url = 'https://api.urbem.digital/v1/citizen_cases/2?auth_token=' +
              Rails.application.credentials.urbem_api_key
        conn.put(url, response.body, 'Content-Type' => 'application/json') do |req|
          conn.options.timeout = 0.4
          conn.request :retry, max: 1, interval: 0.05
        end
      end
    rescue Exception => ex
      puts ex
    end
  end

  private
    def parse_request
      begin
        @data = JSON.parse(request.body.read)
      rescue JSON::ParserError => e
        render json: {error: "Invalid JSON format"}, status: :unprocessable_entity
      end
    end
    def webhooks_params
      params.require(:webhook).permit(:data, :integration_name, :action)
    end
end
