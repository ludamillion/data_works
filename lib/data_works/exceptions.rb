# frozen_string_literal: true

module DataWorks
  class DataWorksError < StandardError; end
  class ModelRelationshipsOutOfDateError < DataWorksError; end
end
