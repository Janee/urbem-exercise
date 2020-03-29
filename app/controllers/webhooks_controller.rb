class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token

  def receive
    begin
      data = JSON.parse(request.body.read)

      hook = Webhook.new(data: data, integration_name: 'urbem')
      if hook.save
        puts 'Event ' + hook.id.to_s + ' successfully saved.'
        puts data[:custom_data][:"Clave catastral"]
      end
    rescue Exception => ex
      render json: { status: 400, error: "It wasn't u, it's me." } and return
    end

    render json: { status: 201 }
  end

  private
    def webhooks_params
      params.require(:webhook).permit(:data, :integration_name)
    end
end
