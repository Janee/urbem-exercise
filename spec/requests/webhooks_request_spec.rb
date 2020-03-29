require "rails_helper"

feature "User creates citizen case", :js do
  scenario "successfully" do
    fake_urbem_webhook("citizen_case_created").send
  end

  def fake_urbem_webhook(fixture)
    FakeUrbemWebhook.new(
      fixture: "#{fixture}.json",
      host: Capybara.current_session.server.host,
      path: "/urbem",
      port: Capybara.current_session.server.port,
    )
  end
end
