class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:receive]

  def receive
    begin
      if request.headers['Content-Type'] == 'application/json'
        data = JSON.parse(request.body.read)
      else
        data = params.as_json
      end

      Webhook.save(data: data, integration_name: 'urbem')
      puts 'Event successfully saved.'
    rescue Exception => ex
      render :json => {status: 400, error: "It wasn't u, it's me."} and return
    end

    render :json => { status: 201}
  end
end
