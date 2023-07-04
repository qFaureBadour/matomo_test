# ne pas modifier (transfert les clés ssh temporairement pendant le déploiement utile pour RhinosTools)
set :ssh_options, { :forward_agent => true }
set :repo_url, "git@github.com:rhinos-solutions/" + "<VHOST>" + ".git"
set :server, <SERVER>
set :application, "<VHOST>"
puts "Application en cours de déploiement: #{ fetch(:application) }"
puts "Fichier de \"stage\" utilisé : #{ fetch(:stage) }"

# TODO liste des fichiers à partager entre releases
# Default value for :linked_files is []
append :linked_files<LINKED_FILES>

# TODO liste des dossiers à partager entre releases
# Default value for linked_dirs is []
append :linked_dirs<LINKED_DIRS>

# TODO liste des fichiers et dossiers a supprimer apres le déploiement
append :rmfiles<FILES_TO_REMOVE>

# Liste des fichiers a copier 
append :copyfiles<FILES_TO_COPY>

# Default value for keep_releases is 5
set :keep_releases<KEEP_RELEASES>

# ne pas modifier config spécial pour DataCampus
SSHKit.config.command_map[:composer] = "<PHP_BIN> /var/nfs/www/#{ fetch(:application) }/htdocs/shared/composer.phar"
SSHKit.config.command_map[:php] = "<PHP_BIN>"

# Test if file exists
def remote_file_not_exist(path)
    capture("if ! [ -e '#{path}' ]; then echo -n 'true'; else echo -n 'false'; fi")
end

namespace :system do

desc "Clean directory before publishing"
    task :cleanup do
        on roles(:app) do
            within release_path  do
                    if any? :rmfiles
                        fetch(:rmfiles).each do |item|
                        execute :rm, "-rf #{item}"
                    end
                end
            end
        end
    end

desc "Copy all the assets to our web servers"
    task :copy do
        on roles(:app) do
            upload! ".output/public", "#{release_path}/", recursive: true
        end
    end

end

after "git:create_release", "system:copy"
after "system:copy", "system:cleanup"
