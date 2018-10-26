module DataWorks
  class Base
    include Visualization

    attr_reader :current_default

    def initialize
      # we keep a registry of all models that we create
      @data = {}
      # keep a registry of the 'current default' model of a given type
      @current_default = {}
      # keep a registry of the 'limiting scope' for parentage
      @bounding_models = {}

      Relationships.necessary_parents.each_key do |parent|
        define_model_finder_methods parent
        define_model_adder_methods parent
      end
    end

    def find_or_add(model_name)
      find(model_name, 1) || send("add_#{model_name}")
    end

    def was_added(model_name, model)
      model_name = model_name.to_sym
      @data[model_name] ||= []
      @data[model_name] << model
    end

    def set_current_default(for_model:, to:)
      @current_default[for_model] = to
    end

    def clear_current_default_for(model)
      @current_default.delete(model)
    end

    def set_restriction(for_model:, to:)
      @bounding_models[for_model] = to

      return unless block_given?

      block_return = yield
      clear_restriction_for(for_model)
      block_return
    end

    def clear_restriction_for(model)
      @bounding_models.delete(model)
    end

    private

    def add_model(model_name, *args)
      many = args[0].is_a? Integer
      grafter = Grafter.new(self, (many ? model_name.to_s.singularize : model_name))
      if many
        grafter.add_many(*args)
      else
        grafter.add_one(*args)
      end
    end

    def find(model_name, index)
      model_name = model_name.to_sym
      if index == 1 && get_default_for(model_name)
        get_default_for(model_name)
      elsif index == 1
        @data[model_name] ||= []
        @data[model_name].reject { |e| invalid_parent?(e) }.first
      else
        @data[model_name] ||= []
        @data[model_name][index.to_i - 1]
      end
    end

    def get_default_for(model)
      @bounding_models[model] || @current_default[model] || nil
    end

    def invalid_parent?(model)
      @bounding_models.each do |k, v|
        return true if model.respond_to?(k) && model.send(k) != v
      end
      false
    end

    def define_model_finder_methods(parent)
      self.class.send(:define_method, "the_#{parent}") do
        find(parent, 1)
      end
      self.class.send(:define_method, parent.to_s) do |n|
        find(parent, n)
      end
    end

    def define_model_adder_methods(parent)
      self.class.send(:define_method, "add_#{parent}") do |options = {}|
        add_model(parent, options)
      end
      self.class.send(:define_method, "add_#{parent.to_s.pluralize}") do |options = {}|
        add_model(parent, options)
      end
    end
  end
end
