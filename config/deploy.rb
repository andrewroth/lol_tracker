set :application, "lol"
set :repository,  "git://github.com/andrewroth/lol_tracker.git"
set :scm, "git"
set :use_sudo, true
set :user, "deploy"
set :group, "www-data"
#set :port, 40022

set :deploy_to, "/var/www/lol.ministryhacks.com"

role :app, "173.203.111.74"
role :web, "173.203.111.74"
role :db, "173.203.111.74", :primary => true

set :branch, "master"
set :deploy_via, :remote_cache
set :git_enable_submodules, 1

desc "Restart the web server"
deploy.task :restart, :roles => :app do
    run "touch #{deploy_to}/current/tmp/restart.txt"
end 

after 'deploy:update_code', 'local_symlinks'
desc "Add linked files after deploy and set permissions"
task :local_symlinks, :roles => :app do
  run "ln -s #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  run "ln -s #{shared_path}/tmp/sessions #{release_path}/tmp/sessions"
  sudo "chgrp -R #{fetch(:group)} #{release_path}"
  sudo "chmod -R g+w #{release_path}"
end

desc "Automatically run cleanup"
after 'deploy', 'deploy:cleanup'

task :long_deploy do
  transaction do
    deploy.update_code
    # deploy.disable_web
    deploy.symlink
    deploy.migrate
  end

  deploy.restart
  deploy.cleanup
  # deploy.enable_web
end

