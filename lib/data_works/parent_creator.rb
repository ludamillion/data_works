module DataWorks
  class ParentCreator

    def initialize(works, model_name, model_attrs)
      @works = works
      @model_name = model_name.to_sym
      @parents = {}
    end

    # This returns a hash of the parent models created, so that they can be
    # easily merged into a model attribute hash.  For example, if a school
    # parent model was created for a student model, then it would be returned
    # like so:
    #    { :school => the_school_model }
    def create_necessary_parents(parents_we_already_have)
      for missing_necessary_parent in missing_necessary_parents(parents_we_already_have)
        find_or_add(missing_necessary_parent)
      end
      @parents
    end

    private

    def missing_necessary_parents(parents_we_already_have)
      Relationships.necessary_parents_for(@model_name).reject do |necessary_parent|
        parents_we_already_have.include?(necessary_parent.association_name)
      end
    end

    def find_or_add(necessary_parent)
      parent_model = @works.find_or_add(necessary_parent.model_name)
      destroy_zombies(parent_model, necessary_parent.association_name)
      @parents[necessary_parent.association_name] = parent_model
    end

    # Consider the case where a model has a has_one relationship with its
    # child.  The model autocreates the child model using a callback like
    # before_validation or after_initialize.
    #
    # This can confuse DataWorks because DataWorks creates models by starting
    # at the child and creating all of the necessary ancestors.  It's a
    # "child creates parent" strategy.  When a model class autocreates a
    # child, it happens outside of DataWorks so DataWorks does not know about
    # it and it goes against the flow since it has a "parent creates child"
    # strategy.
    #
    # The upshot is that a bunch of unmanaged zombie objects will be lying
    # around that could disrupt tests.  So we specifically have to delete
    # any model objects that a parent may have created outside of DataWorks
    # before they cause trouble.
    def destroy_zombies(parent_model, parent_association_name)
      if zombies_possible?(parent_association_name)
        destroy_zombie_child_of(parent_model)
      end
    end

    def zombies_possible?(parent_association_name)
      Relationships.autocreated_children_of(parent_association_name).include?(@model_name)
    end

    def destroy_zombie_child_of(parent_model)
      child = parent_model.send(@model_name)
      child.destroy if child.persisted? && !child.destroyed?
    end

  end
end
