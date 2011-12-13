module Messaging
  module Generators
    class DeviseGenerator < Rails::Generators::NamedBase
      desc "Uses Devise for authentication"

      argument :name, :type => :string, :default => "MessagingUser"


      def self.source_root
        @_messaging_source_root ||= File.expand_path("../templates", __FILE__)
      end

      def install_devise
        require 'devise'
        if File.exists?(File.join(destination_root, "config", "initializers", "devise.rb"))
          log :generate, "No need to install devise, already done."
        else
          log :generate, "devise:install"
          invoke "devise:install"
        end
      end

      def create_user
        invoke "devise", [name]
      end

      def copy_model
        template 'messaging_user.rb.erb', 'app/models/messaging_user.rb'
      end

    end
  end
end

