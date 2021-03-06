namespace :app do
  desc "Start the app in development"
  task start: :environment do
    sh "rails s -b 0.0.0.0 -p 8000"
  end
  task setup: :environment do
    sh "rake environment db:drop db:create db:migrate"
  end
end
namespace :heroku do
  desc "Staging Console"
  task staging_console: :environment do
    sh "heroku run console -a rmct-server-staging"
  end
end
