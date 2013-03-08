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

namespace :deploy do
  desc "Tell Passenger to restart the app."
  task :restart do
    run "touch #{current_path}/tmp/restart.txt"
  end
end