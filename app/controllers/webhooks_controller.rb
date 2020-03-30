class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token

  def receive
    begin
      data = JSON.parse(request.body.read)
      update_citizen_case(data)
      hook = Webhook.new(data: data, integration_name: 'urbem', action: 'update')
      hook.save
      #puts 'Event ' + hook.id.to_s + ' successfully saved.'
    rescue Exception => ex
      render json: { status: 400, error: "It wasn't u, it's me." } and return
    end

    render json: { status: 201 }
  end

  def update_citizen_case(data)
    param = data['custom_data']['Clave catastral']
    url = 'https://sistema-externo.herokuapp.com/api/v1/catastro?clave=' + param.to_s

    response = Faraday.get url
    if response.status == 200
      url = 'https://api.urbem.digital/v1/citizen_cases/2?auth_token=' +
            Rails.application.credentials.urbem_api_key
      response = Faraday.put(url, response.body, 'Content-Type' => 'application/json')
      #puts response.status
    end
  end

  private
    def webhooks_params
      params.require(:webhook).permit(:data, :integration_name, :action)
    end
end
