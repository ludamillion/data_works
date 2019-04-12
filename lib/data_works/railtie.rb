# frozen_string_literal: true

require 'data_works'
require 'rails'

module DataWorks
  class Railtie < Rails::Railtie
    railtie_name :data_works

    rake_tasks do
      namespace :data_works do
        desc 'tell data_works that the model relationships are accurate'
        task bless: :environment do
          DataWorks::StaleRelationshipChecker.create_snapshot!
        end
      end
    end
  end
end
