set :deploy_to, "/var/nfs/www/#{ fetch(:application) }/htdocs/"
set :tmp_dir, "/var/nfs/www/#{ fetch(:application) }/htdocs/tmp/"

# nom de la branche à déployer
set :branch, ENV["CIRCLE_BRANCH"]

# serveur cible
server "#{ fetch(:server) }",

user: "#{ fetch(:application) }",

# ne pas changer
roles: %w{web app}