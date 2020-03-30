class AddActionToWebhook < ActiveRecord::Migration[6.0]
  def change
    add_column :webhooks, :action, :string
  end
end
