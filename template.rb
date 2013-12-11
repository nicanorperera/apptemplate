ROOT = File.expand_path(File.join(File.dirname(__FILE__)))

base   = File.join( ROOT, :recipes, 'base.rb' )
heroku = File.join( ROOT, :recipes, 'heroku.rb' )

contact? = yes? "Add Contact Form? (y/n)"
files?   = yes? "Add File Support? (y/n)"

@now ||= Time.now

def now
  @now += 1
  @now.utc.strftime("%Y%m%d%H%M%S")
end

remove_file "public/index.html"
remove_file "public/favicon.ico"

apply base

run 'bundle install'

rake 'db:create'

generate "sorcery:install remember_me"
gsub_file "config/initializers/sorcery.rb", "# user.username_attribute_names =", "user.username_attribute_names = [:username, :email]"

generate "kaminari:config"

rake 'db:migrate'
rake 'load:all'

apply heroku if yes? 'Desea subir aplicacion a Heroku? (y/n)'