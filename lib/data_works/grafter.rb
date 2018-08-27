module DataWorks
  class Grafter

    class ModelCreator
      def initialize(works, model_name, model_attrs)
        @works = works
        @model_name = model_name.to_sym
        @model_attrs = model_attrs
        @parent_creator = ParentCreator.new(@works, @model_name, @model_attrs)
      end

      def create_model_and_its_necessary_parents
        created_parents = @parent_creator.create_necessary_parents(parents_we_already_have)
        FactoryBot.create(@model_name, @model_attrs.merge(created_parents))
      end

      private

      # If we use DataWorks like this:
      #     data.add_student(:school => some_school)
      # then we are passing in a necessary parent model (the school), so
      # DataWorks does not have to autogenerate it, since we already have it.
      def parents_we_already_have
        provided_attribute_names = @model_attrs.keys
        necessary_parent_names = Relationships.necessary_parents_for(@model_name).map(&:association_name)
        provided_attribute_names & necessary_parent_names
      end
    end

    def initialize(works, model_name)
      @works = works
      @model_name = model_name.to_sym
    end

    def add_many(number, model_attrs={})
      new_models = []
      number.times do
        new_models << add_one(model_attrs)
      end
      new_models
    end

    def add_one(model_attrs={})
      model_creator = ModelCreator.new(@works, @model_name, model_attrs)
      new_model = model_creator.create_model_and_its_necessary_parents
      @works.was_added(@model_name, new_model)
      new_model
    end

  end
end
