require_relative '../lib/data_faker'

FactoryGirl.define do
  factory :pet do
    name { fake_string }
    kind { animal_types.sample }
    birth_year { (1914..2014).to_a.sample }
  end

  factory :agency do
    name { fake_string }
  end

  factory :address do
    street { fake_string + %w(Street Avenue Lane Road).sample }
    city   { fake_word.capitalize }
    state  { fake_word.capitalize }
  end

  factory :pet_food do
    name { "#{animal_types.sample} #{%w(Kibble Chow Food Munchies).sample}" }
  end

  factory :pet_profile do
    description { "#{fake_string} #{fake_string} #{fake_string}" }
  end

  factory :pet_sitter do
    name { fake_string }
  end

  factory :tag do
    registered_name { fake_string }
  end

  factory :toy do
    name { "#{%w(Fluffy Rubber Squeeky).sample} #{%w(Ball Stick Shoe Book).sample}" }
  end

end

def animal_types
  %w(Cat Dog Ferret Moose)
end
