# Execute "bundle install" after deploy, but only when really needed
require "bundler/capistrano"
  
# Name of the application in scm (GIT)
set :application, "devops-test-app"
set :repository, "https://github.com/geoffroymontel/devops-test-app.git"
 
# Source Control Management
set :scm, :git
 
set :deploy_to, "/var/www/#{application}"
 
# server there the web server is running (nginx)
role :web, "33.33.13.2"
 
# server there the app server is running (unicorn)
role :app, "33.33.13.3"
 
# server there the db is running
# This is where Rails migrations will run
role :db, "33.33.13.4", :primary => true
 
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
 
  # Precompile assets
  namespace :assets do
    task :precompile, :roles => :web, :except => { :no_release => true } do
      run %Q{cd #{latest_release} && #{rake} RAILS_ENV=#{rails_env} #{asset_env} assets:precompile}
    end
  end
end