set :application, "rio"
set :deploy_to, "/var/www/rio"
set :repository,  "git@github.com:schrifty/rio"
set :scm, "git"
set :user, "ubuntu"
set :branch, "master"
set :use_sudo, false
#set :deploy_via, :remote_cache

ssh_options[:forward_agent] = true
ssh_options[:keys] = "~/.ssh/myhosts.pem"
default_run_options[:pty] = true

set :scm, :git # You can set :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names

role :web, "ec2-54-213-176-56.us-west-2.compute.amazonaws.com"
role :app, "ec2-54-213-176-56.us-west-2.compute.amazonaws.com"
role :db,  "ec2-54-213-176-56.us-west-2.compute.amazonaws.com", :primary => true

# if you want to clean up old releases on each deploy uncomment this:
after "deploy:restart", "deploy:cleanup"

# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end