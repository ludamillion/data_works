namespace :data_works do
  desc "tell data_works that the model relationships are accurate"
  task :bless => :environment do
    DataWorks::StaleRelationshipChecker.create_snapshot!
  end
end
