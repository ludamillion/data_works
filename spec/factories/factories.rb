require_relative '../lib/data_faker'

FactoryBot.define do
  factory :pet do
    transient do
      animal_types { %w(Cat Dog Ferret Moose Octopus) }
    end
  
    name { fake_string }
    kind { %w(Cat Dog Ferret Moose Octopus).sample }
    birth_year { (1914..2014).to_a.sample }

    trait :bird do
      kind { 'Bird' }
    end

    factory :pet_bird, traits: [:bird]
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
    name { "#{%w(Cat Dog Ferret Moose Octopus).sample} #{%w(Kibble Chow Food Munchies).sample}" }
  end

  factory :pet_profile do
    description { "#{fake_string} #{fake_string} #{fake_string}" }
  end

  factory :pet_sitter do
    name { fake_string }
    kind { Kind.all.sample }
  end

  factory :pet_sitting_patronage do
  end

  factory :tag do
    registered_name { fake_string }
  end

  factory :toy do
    name { "#{%w(Fluffy Rubber Squeeky).sample} #{%w(Ball Stick Shoe Book).sample}" }

    trait :hooman do
      kind { 'Robot Vacuum' } # you know the one
    end

    trait :bell do
      kind { 'Bell' }
    end

    factory :hooman_toy, traits: [:hooman]
    factory :bell_toy, traits: [:bell]
  end

  factory :kind do
    name { fake_word }
  end

  factory :picture do
  end

  factory :album do
    name { fake_word }
  end

  factory :product do
  end
end
