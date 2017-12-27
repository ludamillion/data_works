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
    address:               [:pet_profile],
    agency:                [],
    bell_toy:              [{ :pet => :pet_bird }],
    hooman_toy:            [:pet],
    kind:                  [],
    pet:                   [],
    pet_bird:              [],
    pet_food:              [],
    pet_profile:           [:pet],
    pet_sitter:            [:agency, :kind],
    pet_sitting_patronage: [:pet_sitter, :pet],
    tag:                   [:pet],
    toy:                   [:pet],
    album:                 [],
    product:               [],
    picture:               [{ :imageable => :product }, :album],
  }

  config.autocreated_children = {
  }
end

class TheDataWorks < DataWorks::Base
end

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
end
