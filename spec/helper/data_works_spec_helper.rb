require 'spec_helper'

# data_works needs its own set of tables and ActiveRecord models to test with.
require_relative 'test_tables'
DataWorks::TestTables.create!
require_relative 'test_models'

module DataWorks
  class StaleRelationshipChecker
    def self.check!
      true # For self testing purposes we can just state that the data model has not changed
    end
  end
end

DataWorks.configure do |config|

config.necessary_parents = {
    pet:                   [],
    toy:                   [:pet],
    tag:                   [:pet],
    pet_food:              [],
    agency:                [],
    pet_sitter:            [:agency],
    pet_sitting_patronage: [:pet_sitter, :pet],
    pet_profile:           [:pet],
    address:               [:pet_profile],
  }

  config.autocreated_children = {
  }
end

class TheDataWorks < DataWorks::Base

end

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
end
