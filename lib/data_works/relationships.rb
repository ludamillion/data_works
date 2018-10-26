module DataWorks
  class Relationships
    cattr_reader :necessary_parents
    cattr_writer :autocreated_children

    def self.autocreated_children_of(model_name)
      @@autocreated_children[model_name] || []
    end

    def self.necessary_parents=(hash)
      @@necessary_parents = hash
      StaleRelationshipChecker.check!
    end

    def self.necessary_parents_for(model_name)
      result = @@necessary_parents[model_name]
      if result.nil?
        message = "The model '#{model_name}' is not registered. "
        message << 'It should be registered in the DataWorks.configure section '
        message << 'of your spec_helper.rb file.'
        raise DataWorksError.new(message)
      end
      result.map { |x| NecessaryParent.new(x) }
    end
  end
end
