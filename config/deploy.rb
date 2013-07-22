# Assets pipeline
# Assets need to be precompiled both on web and app servers
set :assets_role, [:web, :app]
load 'deploy/assets'

# Execute "bundle install" after deploy, but only when really needed
require "bundler/capistrano"

# chruby support
default_run_options[:shell] = '/bin/bash'
set :ruby_version, "ruby-2.0"
set :chruby_config, "/etc/profile.d/chruby.sh"
set :set_ruby_cmd, "source #{chruby_config} && chruby #{ruby_version}"
set(:bundle_cmd) {
  "#{set_ruby_cmd} && exec bundle"
}
  
# Name of the application in scm (GIT)
set :application, "devops-test-app"
set :repository, "https://github.com/geoffroymontel/devops-test-app.git"
set :scm, :git
 
set :deploy_to, "/var/www/#{application}"
 
# server there the web server is running (nginx)
role :web, "172.16.0.2"
 
# server there the db is running
# This is where Rails migrations will run
role :db, "172.16.0.3", :primary => true

# servers there the app servers are running (unicorn)
role :app, "172.16.0.4", "172.16.0.5"

set :rails_env, :production
 
# user on the server
set :user, "deployer"
set :use_sudo, false
 
namespace :deploy do 
  task :start, :roles => :app, :except => { :no_release => true } do
    run "service unicorn_#{application} start"
  end
 
  task :stop, :roles => :app, :except => { :no_release => true } do
    run "service unicorn_#{application} stop"
  end
 
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "service unicorn_#{application} restart"
  end

  task :copy_in_database_yml do
    run "cp #{shared_path}/config/database.yml #{latest_release}/config/"
  end
end

before "deploy:assets:precompile", "deploy:copy_in_database_yml"