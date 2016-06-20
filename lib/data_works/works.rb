module DataWorks
  class Works

    include Visualization

    def initialize
      # we keep a registry of all models that we create
      @data = {}
      # keep a registry of the 'current default' model of a given type
      @current_default = {}
      # keep a registry of the 'limiting scope' for parentage
      @bounding_models = {}
    end

    def method_missing(method_name, *args, &block)
      method_name = method_name.to_s
      if method_name.starts_with? 'add_'
        add_model(method_name, *args)
      else
        get_model(method_name, *args)
      end
    end

    def find_or_add(model_name)
      record = find(model_name, 1)
      record ? record : send("add_#{model_name}")
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
    end

    def clear_restriction_for(model)
      @bounding_models.delete(model)
    end

  private

    def add_model(method_name, *args)
      if method_name =~ /\Aadd_(\w+)s\Z/
        model_name = $1
        many = true
      elsif method_name =~ /\Aadd_(\w+)\Z/
        model_name = $1
        many = false
      end
      if model_name
        grafter = Grafter.new(self, model_name)
        if many
          grafter.add_many(*args)
        else
          grafter.add_one(*args)
        end
      end
    end

    def get_model(method_name, *args)
      if method_name =~ /\A(\w+?)(\d+)\Z/
        model_name = $1
        index = $2
      elsif method_name =~ /\Athe_(\w+)\Z/
        model_name = $1
        index = 1
      end
      find(model_name, index)
    end

    def find(model_name, index)
      model_name = model_name.to_sym
      if index == 1 && get_default_for(model_name)
        get_default_for(model_name)
      elsif index == 1
        @data[model_name] ||= []
        @data[model_name].reject{|e| has_invalid_parent?(e)}.first
      else
        @data[model_name] ||= []
        @data[model_name][index.to_i-1]
      end
    end

    def get_default_for(model)
      @bounding_models[model] || @current_default[model] || nil
    end

    def has_invalid_parent?(model)
      @bounding_models.each do |k,v|
        return true if (model.respond_to?(k) && model.send(k) != v)
      end
      false
    end
  end
end
