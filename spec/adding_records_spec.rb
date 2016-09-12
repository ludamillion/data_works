require_relative "helper/data_works_spec_helper"

describe TheDataWorks do
  let!(:data) { TheDataWorks.new }

  describe 'adding a record with no necessary parents' do
    describe "add_pet" do
      it 'creates a new Pet record' do
        expect { data.add_pet }.to change(Pet, :count).by(1)
      end
    end
  end

  describe 'adding a record with one necessary parent' do
    describe 'add_pet_sitter' do
      it 'creates a new PetSitter record' do
        expect { data.add_pet_sitter }.to change(PetSitter, :count).by(1)
      end
      it 'creates a new Agency record' do
        expect { data.add_pet_sitter }.to change(Agency, :count).by(1)
      end
    end
  end

  describe 'adding a record with multiple necessary parents' do
    describe 'add_pet_sitting_patronage' do
      it 'creates a PetSittingPatronage record' do
        expect { data.add_pet_sitting_patronage }.to change(PetSittingPatronage, :count).by(1)
      end
      it 'creates a new Pet record' do
        expect { data.add_pet_sitting_patronage }.to change(Pet, :count).by(1)
      end
      it 'creates a new PetSitter record' do
        expect { data.add_pet_sitting_patronage }.to change(PetSitter, :count).by(1)
      end
      it 'creates a new Agency record' do # necessary for PetSitter
        expect { data.add_pet_sitting_patronage }.to change(Agency, :count).by(1)
      end
    end
  end

  describe 'adding multiple records at once' do
    describe 'add_pets(2)' do
      it 'creates two new Pet records' do
        expect { data.add_pets(2) }.to change(Pet, :count).by(2)
      end
    end
    describe 'add_pet_sitter(s)' do
      it 'creates a new PetSitter record' do
        expect { data.add_pet_sitters(2) }.to change(PetSitter, :count).by(2)
      end
      it 'creates a new Agency record' do
        expect { data.add_pet_sitters(2) }.to change(Agency, :count).by(1)
      end
    end
  end
end
