##Goalify
[![Build Status](https://travis-ci.org/deeprog/goalify.svg?branch=master)](https://travis-ci.org/deeprog/goalify)
[![Code Climate](https://codeclimate.com/github/deeprog/goalify/badges/gpa.svg)](https://codeclimate.com/github/deeprog/goalify)
[![Test Coverage](https://codeclimate.com/github/deeprog/goalify/badges/coverage.svg)](https://codeclimate.com/github/deeprog/goalify/coverage)
###A site to create and complete goals

####Purpose
I built this app to get experience with [Ruby on Rails](http://rubyonrails.org/) and now I use it to practice new tools and technologies.

####Features
This app has the following features:

1. Visitors can view all goals and users
2. Users can create new goals, comments, and subscriptions
3. Subscriptions add scores to their goals and creators at:
  * Creation: 50 points
  * Completion: 100 points
4. API:
  * Users can access the full API with their authentication token

####Tools and Technologies
This app uses the following tools and technologies:
1. [Action Pack page caching](https://github.com/rails/actionpack-page_caching) and [Action Pack action caching](https://github.com/rails/actionpack-action_caching) (Performance)
2. [Bootstrap](http://getbootstrap.com/), [Font Awesome](http://fortawesome.github.io/Font-Awesome/), and [Sass](http://sass-lang.com/) (CSS styling)
3. [CanCanCan](https://github.com/CanCanCommunity/cancancan) (Resource authorization)
4. [Code Climate](https://codeclimate.com/), [SimpleCov](https://github.com/colszowka/simplecov), [Travis CI](https://travis-ci.org/) (Reporting)
5. [Cucumber](https://cucumber.io/), [Factory Girl](https://github.com/thoughtbot/factory_girl), [Faker](https://github.com/stympy/faker), [JSON Schema](http://json-schema.org/), [RSpec](http://rspec.info/) (Testing)
6. [Devise](https://github.com/plataformatec/devise) (User authentication with [Warden](https://github.com/hassox/warden))
7. [Heroku](https://www.heroku.com/) (Deployment)
8. [Jbuilder](https://github.com/rails/jbuilder) (Resource rendering for API)
9. [Kaminari](https://github.com/amatsuda/kaminari) (Resource pagination)
10. [OAuth](http://oauth.net/) (User authentication with Facebook and Google)
11. [PostgreSQL](http://www.postgresql.org/) (Database)
12. [Puma](http://puma.io/) (Web Server)
13. [Simple Token Authentication](https://github.com/gonzalo-bulnes/simple_token_authentication) (User authentication with tokens for API)
