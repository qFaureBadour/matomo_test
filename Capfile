# default deploy_config_path is 'config/deploy.rb'
set :deploy_config_path, File.expand_path('.circleci/scripts/capistrano/deploy.rb')

# default stage_config_path is 'config/deploy'
set :stage_config_path, '.circleci/scripts/capistrano/stages'

# Load DSL and set up stages
require "capistrano/setup"

# Include default deployment tasks
require "capistrano/deploy"
#require 'capistrano/composer'

# Load the SCM plugin:
require "capistrano/scm/git"
install_plugin Capistrano::SCM::Git

# Load custom tasks from `lib/capistrano/tasks` if you have any defined
Dir.glob("lib/capistrano/tasks/*.rake").each { |r| import r }
