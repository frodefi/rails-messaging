Rails Messaging
===============
Simple User Messaging System UI using the Mailboxer plugin (https://github.com/ging/mailboxer).

Overview of features:

- To send messages internally between users only, in email style

- Folders: Inbox, Sent, Drafts, Trash. List showing vital info and each is sortable. Checkbox to do delete multiple emails.

- General email search

- Compose new message with: multiple receivers. If this is a reply, quote the replied message.

- Message view, options to download attachment and delete the message.


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
$ bundle install
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

These steps will work for standard Rails applications.

Make the rails-messaging work for RefineryCMS 2.0
===============

If you are using refinerycms edge (http://refinerycms.com/edge-guides/) and you want integrate the this gem to your system. Please do the following step:

Remove this line from /config/routes.rb

````ruby
devise_for :messaging_users
````

Replace content of /app/models/messaging_user.rb as below

````ruby
class MessagingUser < Refinery::User

end
````

Create /app/decorators/models/messaging/message_decorator.rb and insert the below content

````ruby
Messaging::Message.class_eval do

  def recipients=(string='')
    @recipient_list = []
    string.split(',').each do |s|
      unless s.blank?
        recipient = Refinery::User.find_by_email(s.strip)
        @recipient_list << recipient if recipient
      end
    end
  end

end
````

Create /app/decorators/models/refinery/user_decorator.rb and insert the below content

````ruby
Refinery::User.class_eval do
  include Mailboxer::Models::Messageable
  acts_as_messageable

  def name
    self.to_s
  end

  def mailboxer_email(message)
    email
  end

  def to_s
    email
  end
end
````

Create /app/decorators/controllers/messaging/application_controller_decorator.rb and insert the below content

````ruby
Messaging::ApplicationController.class_eval do
  skip_filter :authenticate_messaging_user!
  before_filter :login_required
  helper_method :current_messaging_user

  protected
  def login_required
    redirect_to main_app.new_refinery_user_session_path unless current_refinery_user
  end

  def current_messaging_user
    current_refinery_user
  end
end
````

If you want to use refinery's layout, you can add the following lines to app/decorators/controllers/messaging/application_controller_decorator.rb

````ruby
  layout "application"
  include Refinery::AuthenticatedSystem
  include Refinery::ApplicationController::InstanceMethods
  include Refinery::Pages::InstanceMethods
  helper_method :home_page?,
                :local_request?,
                :just_installed?,
                :from_dialog?,
                :admin?,
                :login?
  before_filter  :find_pages_for_menu, :show_welcome_page?
````

And then create app/helpers/messaging/application_helper.rb, with the below content:

````ruby
module Messaging
  module ApplicationHelper
    include Refinery::SiteBarHelper
    include Refinery::MenuHelper
    include Refinery::MetaHelper
  end
end
````

And then create app/views/layout/messaging/application.html.haml file with the below content

````ruby
!!!
= render :partial => '/refinery/html_tag'
- site_bar = render(:partial => '/refinery/site_bar', :locals => {:head => true})
= render :partial => '/refinery/head'
:javascript
      // Edit to suit your needs.
    var ADAPT_CONFIG = {
      path: ' request.protocol  request.host : request.port ',
      dynamic: true,
      range: [
        '0px    to 760px  =  asset_path('messaging/mobile.css') ',
        '760px  to 980px  =  asset_path('messaging/720.css') ',
        '980px  to 1280px =  asset_path('messaging/960.css') ',
        '1280px to 1600px =  asset_path('messaging/1200.css') ',
        '1600px =  asset_path('messaging/1560.css') ',
      ]
    };
  = javascript_include_tag "messaging/adapt"
= javascript_include_tag "messaging/application"
%body
    = render :partial => '/refinery/ie6check' if request.env['HTTP_USER_AGENT'] =~ /MSIE/
    #page_container.container.row
      %header#header
        = render :partial => '/refinery/header'
      %section#page
        %section#body_content
          %h1#body_content_title Messages
          %section#body_content_left
            .inner
              = link_to "Compose", new_message_path, :class => 'compose'
              - if @box == 'inbox'
                = link_to "Inbox", messages_path(:box => 'inbox'), :class => 'selected'
              - else
                = link_to "Inbox", messages_path(:box => 'inbox')
              - if @box == 'sent'
                = link_to "Sent", messages_path(:box => 'sent'), :class => 'selected'
              - else
                = link_to "Sent", messages_path(:box => 'sent')
              - if @box == 'trash'
                = link_to "Trash", messages_path(:box => 'trash'), :class => 'selected'
              - else
                = link_to "Trash", messages_path(:box => 'trash')
              = form_tag search_path do
                %input{:name => "Search", :placehoder => "Search", :type => "search"}/
          %section#body_content_right
            .inner
              = yield
      %footer
        = render :partial => '/refinery/footer'
    = render :partial => '/refinery/javascripts'
````

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

Reference
===============

https://github.com/ging/mailboxer

https://github.com/dickeytk/mailboxer.git


Contributors
===============

Sponsored by Frode Fikke

Developed by Jeff Dickey

Document is updated by Yen Ha-Thi-Bach

Copyright
===============

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.