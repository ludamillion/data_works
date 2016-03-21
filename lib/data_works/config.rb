module DataWorks

  def self.configure
    yield(Config)
  end

  class Config

    def self.necessary_parents=(hash)
      Relationships.necessary_parents = hash
    end

    def self.autocreated_children=(hash)
      Relationships.autocreated_children = hash
    end

  end

end
