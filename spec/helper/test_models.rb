#*******************************************************************************
#  For testing basic associations.
#*******************************************************************************

class Pet < ActiveRecord::Base
  has_many :toys
  has_one :pet_tag
  has_one :pet_profile
  has_one :address, through: :pet_profile
  # We explicitly name the join table so that this code works with both Rails 3 and Rails 4.
  has_and_belongs_to_many :pet_foods, join_table: 'pet_foods_pets'
  has_many :pet_sitting_patronages
  has_many :pet_sitters, through: :pet_sitting_patronages
end

class Toy < ActiveRecord::Base
  validates  :name, length: { minimum: 3 }
  belongs_to :pet
end

class PetTag < ActiveRecord::Base
  belongs_to :pet
end

class PetFood < ActiveRecord::Base
  # Rails 3 expects the join table to be called pet_foods_pets
  # Rails 4 expects the join table to be called pet_foods_pets
  # We explicitly name the join table so that this code works with both Rails 3 and Rails 4.
  has_and_belongs_to_many :pets, join_table: 'pet_foods_pets'
end

class Agency < ActiveRecord::Base
  has_many :pet_sitters
end

class PetSitter < ActiveRecord::Base
  belongs_to :agency
  has_many :pet_sitting_patronages
  has_many :pets, through: :pet_sitting_patronages
end

class PetSittingPatronage < ActiveRecord::Base
  belongs_to :pet
  belongs_to :pet_sitter
end

class PetProfile < ActiveRecord::Base
  belongs_to :pet
  has_one :address
end

class Address < ActiveRecord::Base
  belongs_to :pet_profile
end



#*******************************************************************************
#  For testing polymorphic associations and custom-named foreign keys.
#

# class Picture < ActiveRecord::Base
#   belongs_to :imageable, polymorphic: true
#   belongs_to :album, foreign_key: 'picture_album_id'
# end

# class Product < ActiveRecord::Base
#   has_many :pictures, as: :imageable
# end

# class Album < ActiveRecord::Base
#   has_many :pictures, foreign_key: 'picture_album_id'
# end



# #*******************************************************************************
# #  For testing denormalized data structures.
# #

# class Owner < ActiveRecord::Base
#   has_many :vehicles
#   has_many :amenities  # this is not normalized, you wouldn't normally do this
# end

# class Vehicle < ActiveRecord::Base
#   has_many :amenities
#   belongs_to  :owner
# end

# class Amenity < ActiveRecord::Base
#   belongs_to :vehicle
#   belongs_to :owner  # this is not normalized, you wouldn't normally do this
#   has_one :warranty
# end

# class Warranty < ActiveRecord::Base
#   belongs_to :amenity
# end
