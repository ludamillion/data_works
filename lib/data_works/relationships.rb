module DataWorks
  class Relationships

    def self.autocreated_children=(hash)
      @autocreated_children = hash
    end

    def self.autocreated_children_of(model_name)
      @autocreated_children[model_name] || []
    end

    def self.necessary_parents=(hash)
      @necessary_parents = hash
      StaleRelationshipChecker.check!
    end

    def self.necessary_parents_for(model_name)
      result = @necessary_parents[model_name]
      if result.nil?
        if model_name.to_s.ends_with?('s')
          message = "DataWorks does not yet work with models whose singular "
          message << "name ends in s, which seems to be a problem with "
          message << "the model '#{model_name}'.  You'll have to add support "
          message << "for models ending in 's' to DataWorks."
        else
          message = "The model '#{model_name}' is not registered. "
          message << "It should be registered in the DataWorks.configure section "
          message << "of your spec_helper.rb file."
        end
        raise DataWorksError.new(message)
      end
      result.map{|x| NecessaryParent.new(x)}
    end

  end
end
