require "rails_helper"

feature "User creates citizen case", :js do
  scenario "receive hook successfully" do
    fake_urbem_webhook("test_connection").send
  end

  describe "POST /urbem event", type: :request do
    it "works correctly" do
      post '/urbem', params: File.read(fixture_path)
      expect(response.status).to eq(200)
    end

    it "do not send body" do
      post '/urbem', params: nil
      expect(response.status).not_to eq(200)
    end
  end

  def fake_urbem_webhook(fixture)
    FakeUrbemWebhook.new(
      fixture: "#{fixture}.json",
      host: Capybara.current_session.server.host,
      path: "/urbem",
      port: Capybara.current_session.server.port,
    )
  end

  private
  def fixture_path
    "#{Rails.root}/spec/fixtures/webhooks/urbem/citizen_case_created.json"
  end
end
