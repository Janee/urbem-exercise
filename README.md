# README

This application gets an URBEM Event and updates a citizen case according to
specifications.


How to run the in your local:

```
bundle install
rake db:setup && rake db:migrate
rails s
```

['Ultrahook'](http://www.ultrahook.com/) is a good gem to test webhooks locally.


Tools used in this app:
* Postgresql
* Rspec (with Capybara & Faraday)
* Postman (to simulate the post event)
