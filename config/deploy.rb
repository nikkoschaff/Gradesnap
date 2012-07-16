require "bundler/capistrano"

server "216.70.108.89", :web, :app, :db, primary: true

set :user,  "nikko"
set :scm_passphrase, "sunlightcity"
set :application, "Gradesnap"
set :deploy_to, "/home/#{user}/apps/#{application}"
#set :deploy_via, :copy
set :deploy_via, :remote_cache
set :use_sudo, false

set :scm, "git"
set :repository,  "git@github.com:nikkoschaff/gsweb.git"
set :branch, "master"

default_run_options[:pty] = true
#ssh_options[:forward_agent] = true
ssh_options[:keys] = "/home/#{user}/.ssh/*"

after "deploy:restart", "deploy:cleanup"
  
require "rvm/capistrano"

set :rvm_ruby_string, :local
set :rvm_type, :system 

# If you are using Passenger mod_rails uncomment this:
 namespace :deploy do
   task :start do ; end
   task :stop do ; end
   task :restart, :roles => :app, :except => { :no_release => true } do
     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
   end
 end
