class AddColumnsToWebhooks < ActiveRecord::Migration[6.0]
  def change
    add_column :webhooks, :data, :string
    add_column :webhooks, :integration_name, :string
  end
end
