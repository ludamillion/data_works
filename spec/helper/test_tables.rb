module DataWorks
  class TestTables

    def self.create!
      return if @already_created_tables
      ActiveRecord::Migration.class_eval do
        suppress_messages do

          create_table :agencies, force: true do |t|
            t.string :name, null: false
            t.timestamps
          end

          create_table :addresses, force: true do |t|
            t.string   :street,          null: false
            t.string   :city,            null: false
            t.string   :state,           null: false
            t.integer  :pet_profile_id,  null: false
            t.timestamps
          end

          create_table :pet_foods, force: true do |t|
            t.string :name, null: false
            t.timestamps
          end

          create_table :pet_foods_pets, force: true, id: false do |t|
            t.integer :pet_id,      null: false
            t.integer :pet_food_id, null: false
          end

          create_table :pet_profiles, force: true do |t|
            t.string   :description,     null: false
            t.string   :nickname
            t.integer  :pet_id, null: false
            t.timestamps
          end

          create_table :pet_sitters, force: true do |t|
            t.string  :name, null: false
            t.integer :agency_id, null: false
            t.timestamps
          end

          create_table :pet_sitting_patronages, force: true do |t|
            t.integer  :pet_id,        null: false
            t.integer  :pet_sitter_id, null: false
            t.timestamps
          end

          create_table :pet_tags, force: true do |t|
            t.string   :registered_name, null: false
            t.integer  :pet_id, null: false
            t.timestamps
          end

          create_table :pets, force: true do |t|
            t.string  :name,        null: false
            t.string  :kind,        null: false
            t.integer :birth_year
            t.timestamps
          end

          create_table :toys, force: true do |t|
            t.string   :name
            t.string   :kind
            t.integer  :pet_id
            t.timestamps
          end

          # create_table :albums, force: true do |t|
          #   t.string :name, null: false
          #   t.timestamps
          # end

          # create_table :pictures, force: true do |t|
          #   t.string  :name
          #   t.integer :imageable_id
          #   t.string  :imageable_type
          #   t.integer :picture_album_id
          #   t.timestamps
          # end

          # create_table :products, force: true do |t|
          #   t.string  :name
          #   t.timestamps
          # end

          # create_table :amenities, force: true do |t|
          #   t.string   :name
          #   t.integer  :vehicle_id
          #   t.integer  :owner_id
          #   t.timestamps
          # end

          # create_table :owners, force: true do |t|
          #   t.string :name, null: false
          #   t.timestamps
          # end

          # create_table :vehicles, force: true do |t|
          #   t.string  :name
          #   t.integer :owner_id
          #   t.timestamps
          # end

          # create_table :warranties, force: true do |t|
          #   t.string   :name
          #   t.integer  :amenity_id
          #   t.timestamps
          # end

        end
      end
      @already_created_tables = true
    end

  end
end
