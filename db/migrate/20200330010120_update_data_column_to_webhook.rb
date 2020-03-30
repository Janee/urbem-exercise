class UpdateDataColumnToWebhook < ActiveRecord::Migration[6.0]
  def change
    remove_column :webhooks, :data
    remove_column :webhooks, :action

    add_column :webhooks, :data, :jsonb
    add_column :webhooks, :event_id, :integer
  end
end
