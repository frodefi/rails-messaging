class Messaging::InstallGenerator < Rails::Generators::Base #:nodoc:

  hook_for :users, :default => "devise", :desc => "User generator to run. Skip with --skip-users"

  def create_migration_file
    generate 'mailboxer:install'
  end

  def add_messaging_routes
    route 'mount Messaging::Engine => "/messaging"'
  end
end
