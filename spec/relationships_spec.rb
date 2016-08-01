require_relative "helper/data_works_spec_helper"

describe DataWorks::Relationships do
  describe "#necessary_parents_for" do
    describe "pet" do
      it "returns an empty collection" do
        expect(DataWorks::Relationships.necessary_parents_for(:pet)).to be_empty
      end
    end

    describe "pet_food" do
      it "returns an empty collection" do
        expect(DataWorks::Relationships.necessary_parents_for(:pet_food)).to be_empty
      end
    end

    describe "agency" do
      it "returns an empty collection" do
        expect(DataWorks::Relationships.necessary_parents_for(:agency)).to be_empty
      end
    end

    describe "toy" do
      it "returns a collection with a single parent object " do
        expect(DataWorks::Relationships.necessary_parents_for(:toy).count).to eq 1
      end
      it "returns a parent object with #association_name => pet" do
        parents = DataWorks::Relationships.necessary_parents_for(:toy)
        expect(parents.first.association_name).to eq(:pet)
      end
      it "returns a parent object with #model_name => pet" do
        parents = DataWorks::Relationships.necessary_parents_for(:toy)
        expect(parents.first.model_name).to eq(:pet)
      end
    end

    describe "tag" do
      it "returns a collection with a single parent object " do
        expect(DataWorks::Relationships.necessary_parents_for(:tag).count).to eq 1
      end
      it "returns a parent object with #association_name => pet" do
        parents = DataWorks::Relationships.necessary_parents_for(:tag)
        expect(parents.first.association_name).to eq(:pet)
      end
      it "returns a parent object with #model_name => pet" do
        parents = DataWorks::Relationships.necessary_parents_for(:tag)
        expect(parents.first.model_name).to eq(:pet)
      end
    end

    describe "pet_profile" do
      it "returns a collection with a single parent object " do
        expect(DataWorks::Relationships.necessary_parents_for(:pet_profile).count).to eq 1
      end
      it "returns a parent object with #association_name => pet" do
        parents = DataWorks::Relationships.necessary_parents_for(:pet_profile)
        expect(parents.first.association_name).to eq(:pet)
      end
      it "returns a parent object with #model_name => pet" do
        parents = DataWorks::Relationships.necessary_parents_for(:pet_profile)
        expect(parents.first.model_name).to eq(:pet)
      end
    end

    describe "pet_sitter" do
      it "returns a collection with a single parent object " do
        expect(DataWorks::Relationships.necessary_parents_for(:pet_sitter).count).to eq 1
      end
      it "returns a parent object with #association_name => agency" do
        parents = DataWorks::Relationships.necessary_parents_for(:pet_sitter)
        expect(parents.first.association_name).to eq(:agency)
      end
      it "returns a parent object with #model_name => agency" do
        parents = DataWorks::Relationships.necessary_parents_for(:pet_sitter)
        expect(parents.first.model_name).to eq(:agency)
      end
    end

    describe "address" do
      it "returns a collection with a single parent object " do
        expect(DataWorks::Relationships.necessary_parents_for(:address).count).to eq 1
      end
      it "returns a parent object with #association_name => pet_profile" do
        parents = DataWorks::Relationships.necessary_parents_for(:address)
        expect(parents.first.association_name).to eq(:pet_profile)
      end
      it "returns a parent object with #model_name => pet_profile" do
        parents = DataWorks::Relationships.necessary_parents_for(:address)
        expect(parents.first.model_name).to eq(:pet_profile)
      end
    end

    describe "pet_sitting_patronage" do
      it "returns a collection with two parent objects" do
        expect(DataWorks::Relationships.necessary_parents_for(:pet_sitting_patronage).count).to eq 2
      end
      it "returns an array of parent objects with #association_names => pet_sitter, pet" do
        parents = DataWorks::Relationships.necessary_parents_for(:pet_sitting_patronage)
        expect(parents.map(&:association_name)).to contain_exactly(:pet_sitter, :pet)
      end
      it "returns an array of parent objects with #model_names => pet_sitter, pet" do
        parents = DataWorks::Relationships.necessary_parents_for(:pet_sitting_patronage)
        expect(parents.map(&:model_name)).to contain_exactly(:pet_sitter, :pet)
      end
    end
  end
end

