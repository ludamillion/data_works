# frozen_string_literal: true

# The purpose of this class is to encapsulate the idea that when configuring
# DataWorks, necessary_parents can include symbols or hashes, like so:
#
#   config.necessary_parents = {
#     district:                      [ ],
#     event:                         [:schedule, :school],
#     scheduled_service:             [{:schedulable => :event}, :student],
#     school:                        [:district]
#     student:                       [:school]
#   }
#
module DataWorks
  class NecessaryParent
    attr_reader :association_name, :model_name

    def initialize(entry)
      if entry.is_a? Hash
        @association_name = entry.keys.first
        @model_name = entry.values.first
      else
        @association_name = @model_name = entry
      end
    end
  end
end
