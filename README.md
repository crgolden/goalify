##Goalify
[![Build Status](https://travis-ci.org/deeprog/goalify.svg?branch=master)](https://travis-ci.org/deeprog/goalify)
[![Code Climate](https://codeclimate.com/github/deeprog/goalify/badges/gpa.svg)](https://codeclimate.com/github/deeprog/goalify)
[![Test Coverage](https://codeclimate.com/github/deeprog/goalify/badges/coverage.svg)](https://codeclimate.com/github/deeprog/goalify/coverage)
###A site to create and complete goals

I built this app to get experience with [Ruby on Rails](http://rubyonrails.org/) and now I use it to practice new tools and technologies.

####Features

1. Visitors can view all Goals, Comments , Subscriptions, Scores , and Users
2. Visitors can search Goals (results ranked by title, score, then text)
3. Visitors and Users can sign-up / sign-in with email / Facebook / Google
4. Users can create new Goals and Comments
5. Users can subscribe to (50 points) and complete (100 points) Goals
6. Developers can access the API with their authentication token
7. Developers can contribute to the open source repository

####Tools and Technologies

1. [Action caching](https://github.com/rails/actionpack-action_caching), [page caching](https://github.com/rails/actionpack-page_caching), [pagination](https://github.com/amatsuda/kaminari), and [static routing](https://github.com/thoughtbot/high_voltage) (Performance)
2. [Bootstrap](http://getbootstrap.com/), [Font Awesome](http://fortawesome.github.io/Font-Awesome/), and [Sass](http://sass-lang.com/) (CSS styling)
3. [CanCanCan](https://github.com/CanCanCommunity/cancancan) (Resource authorization)
4. [Code Climate](https://codeclimate.com/), [Travis CI](https://travis-ci.org/) (Reporting)
5. [Cucumber](https://cucumber.io/), [JSON Schema](http://json-schema.org/), [RSpec](http://rspec.info/) (Testing)
6. [Devise](https://github.com/plataformatec/devise) (User authentication)
7. [Heroku](https://www.heroku.com/) (Deployment)
8. [OAuth](http://oauth.net/) (User authentication with Facebook/Google)
9. [PostgreSQL](http://www.postgresql.org/) with [full-text search](https://github.com/Casecommons/pg_search) (Database)
10. [Puma](http://puma.io/) (Web Server)
