Simple User Messaging System UI using the Mailboxer plugin (https://github.com/ging/mailboxer).

Overview of features:
- To send messages internally between users only, in email style
- Folders: Inbox, Sent, Drafts, Trash. List showing vital info and each is sortable. Checkbox to do delete multiple emails.
- General email search
- Compose new message with: multiple receivers, multiple attachments. If this is a reply, quote the replied message.
- Message view (1 message only, no threading gmail style), options to download attachment and delete the message.

This Messaging System also exists as a Refinery CMS engine, see https://github.com/frodefi/refinerycms-messaging.

Running the demo app
====================

To run the demo app, first clone the repo

````
$ git clone git@github.com:frodefi/rails-messaging.git
````

Install gems from project root

````
bundle
````

From the dummy app (./test/dummy), create the database

````
$ rake db:migrate
````

Start the server!

````
$ rails server
````

Enabling Search
===============

To enable search, install the config file

````
$ rails g sunspot_rails:install
````

Run the development solr server

````
$ rake sunspot:solr:start
````
