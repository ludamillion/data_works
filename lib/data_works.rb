require 'active_record'
require 'active_support/core_ext/string/inflections'

require_relative 'data_works/version'
require_relative 'data_works/exceptions'
require_relative 'data_works/stale_relationship_checker'
require_relative 'data_works/relationships'
require_relative 'data_works/visualization'
require_relative 'data_works/necessary_parent'
require_relative 'data_works/parent_creator'
require_relative 'data_works/grafter'
require_relative 'data_works/works'
require_relative 'data_works/config'
require_relative "data_works/railtie" if defined?(Rails)
