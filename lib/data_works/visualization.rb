require 'graphviz'
require 'launchy'

module DataWorks
  module Visualization

    def visualize
      @g = Graphviz::Graph.new
      build_nodes
      connect_nodes
      filename = "factoried-data-diagram-#{Time.new.strftime("%Y%m%d%H%M%S")}#{rand(1000)}.png"
      path = File.join(Rails.root, "tmp", filename)
      Graphviz::output(@g, path: path)
      Launchy.open(path)
    end

  private

    def build_nodes
      @nodes = {}
      @data.keys.each do |model_name|
        @nodes[model_name] = @data[model_name].each_with_index.map do |model, i|
          @g.add_node("#{model_name}#{i+1}")
        end
      end
    end

    def connect_nodes
      model_names = @data.keys
      for model_name1 in model_names
        for model_name2 in model_names
          connect_model_kinds(model_name1, model_name2)
        end
      end
    end

    # accepts symbols like :district, :district_schedule_context
    def connect_model_kinds(model_type1, model_type2)
      return if model_type1 == model_type2
      models = @data[model_type1]
      models.each do |parent|
        find_and_connect_children_to_parent(parent, model_type2)
      end
    end

    def find_and_connect_children_to_parent(parent, child_type)
      assoc = child_association(parent, child_type)
      return if assoc.nil?
      parent.reload
      children = [parent.send(assoc)].flatten
      for child in children
        connect(parent, child)
      end
    end

    def child_association(parent, child_type)
      assoc = child_associations_for(parent).detect do |name, obj|
        name == child_type || name == child_type.to_s.pluralize.to_sym
      end
      assoc.try(:first)
    end

    def child_associations_for(parent)
      parent.class.reflections.to_a.select do |name, obj|
        (obj.macro == :has_many || obj.macro == :has_one) &&
          !obj.options[:through]
      end
    end

    def connect(parent, child)
      child_model_name = model_name_of(child)
      parent_model_name = model_name_of(parent)
      if @data[parent_model_name]
        i = @data[parent_model_name].find_index { |model| model.id == parent.id }
        parent_node = @nodes[parent_model_name][i]
        if parent_node
          if @data[child_model_name]
            i = @data[child_model_name].find_index { |model| model.id == child.id }
            if i.nil? # this factory was not created via the DataWorks
              child_node = @g.add_node("#{child_model_name} (unmanaged)")
            else
              child_node = @nodes[child_model_name][i]
            end
            if child_node
              parent_node.connect(child_node)
            end
          end
        end
      end
    end

    def model_name_of(model)
      model.class.name.underscore.to_sym
    end

  end
end
