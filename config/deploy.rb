# Execute "bundle install" after deploy, but only when really needed
require "bundler/capistrano"
  
# Name of the application in scm (GIT)
set :application, "devops-test-app"
set :repository, "https://github.com/geoffroymontel/devops-test-app.git"
set :scm, :git
 
set :deploy_to, "/var/www/#{application}"
 
# server there the web server is running (nginx)
role :web, "33.33.13.2"
 
# server there the db is running
# This is where Rails migrations will run
role :db, "33.33.13.3", :primary => true

# servers there the app servers are running (unicorn)
role :app, "33.33.13.4", "33.33.13.5"

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
 
  # Precompile assets
  # I have to precompile the assets on the app servers too, and I don't really know why...
  namespace :assets do
    task :precompile, :roles => [:web, :app], :except => { :no_release => true } do
      run %Q{cd #{latest_release} && #{rake} RAILS_ENV=#{rails_env} #{asset_env} assets:precompile}
    end
  end
end

before "deploy:assets:precompile", "deploy:copy_in_database_yml"