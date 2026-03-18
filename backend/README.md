# README

* First run *bundle install*

* Change .env with your BACKEND_DATABASE_PASSWORD

* On config/environment/development.rb change to your smtp settings

  config.action_mailer.smtp_settings = {
    user_name: ***,
    password: **,
    address: **,
    host: **,
    port: '2525',
    authentication: :login
  }

* on config/database.yml
    The database is configured to development/my_database_dev and test/my_database_test feel free to change if you want

* Run *rails s* and server is listening on port 3000

* Run *rails db:migrate* to create de database tables
* Run *rails db:seed* to populate the database
* Run *rails test* to run some tests


