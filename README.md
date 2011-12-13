Simple User Messaging System UI using the Mailboxer plugin (https://github.com/ging/mailboxer).

Overview of features:
- To send messages internally between users only, in email style
- Folders: Inbox, Sent, Drafts, Trash. List showing vital info and each is sortable. Checkbox to do delete multiple emails.
- General email search
- Compose new message with: multiple receivers, multiple attachments. If this is a reply, quote the replied message.
- Message view (1 message only, no threading gmail style), options to download attachment and delete the message.

This Messaging System also exists as a Refinery CMS engine, see https://github.com/frodefi/refinerycms-messaging.

Installing the gem
==================

Include gems and run the bundle command

````ruby
# Gemfile
gem 'messaging', git: 'git://github.com/frodefi/rails-messaging.git'
gem 'mailboxer', git: 'git://github.com/dickeytk/mailboxer.git'
````

Install messaging

````
$ rails generate messaging:install
````

*Overwrite model file when asked*

Run migrations

````
$ rake db:migrate
````

Set the default host and set a root route (required for Devise)

````ruby
# config/environments/development.rb
config.action_mailer.default_url_options = { :host => 'localhost:3000' }
````

These steps will work for RefineryCMS 2.0 or for standard Rails applications.

Enabling Search
===============

To enable search, install the config file

````
$ rails g sunspot_rails:install
````

Install the development solr server

````ruby
# Gemfile
gem 'sunspot_solr'
````

Start the development solr server

````
$ rake sunspot:solr:run
````

Enable search in mailboxer

````ruby
# config/initializers/mailboxer.rb
config.search_enabled = true
````
