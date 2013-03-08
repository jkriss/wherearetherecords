# require "bundler/capistrano" # makes dreamhost unhappy

set :application, "wherearetherecords.com"
set :repository,  "git@github.com:jkriss/wherearetherecords.git"

# set :scm, :git # You can set :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

set :user, "jkriss"
set :group, user
set :runner, user

set :host, "#{user}@jklabs.net" # We need to be able to SSH to that box as this user.
role :web, host
role :app, host
set :rails_env, :production

set :deploy_to, "/home/jkriss/#{application}"

set :use_sudo, false
set(:run_method) { use_sudo ? :sudo : :run }
ssh_options[:forward_agent] = true
default_run_options[:pty] = true

# role :db,  "your primary db-server here", :primary => true # This is where Rails migrations will run
# role :db,  "your slave db-server here"

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end

