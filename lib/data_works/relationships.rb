# frozen_string_literal: true

module DataWorks
  class Relationships
    class << self
      attr_reader :necessary_parents
      attr_writer :autocreated_children
    end

    def self.autocreated_children_of(model_name)
      @autocreated_children[model_name] || []
    end

    def self.necessary_parents
      @necessary_parents
    end

    def self.necessary_parents=(hash)
      @necessary_parents = hash
      StaleRelationshipChecker.check!
    end

    def self.necessary_parents_for(model_name)
      result = @necessary_parents[model_name]
      if result.nil?
        message = "The model '#{model_name}' is not registered. \
        It should be registered in the DataWorks.configure section \
        of your spec_helper.rb file."
        raise DataWorksError, message
      end
      result.map { |x| NecessaryParent.new(x) }
    end
  end
end
