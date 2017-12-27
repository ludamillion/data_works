require_relative "helper/data_works_spec_helper"

describe TheDataWorks do
  let!(:data) { TheDataWorks.new }

  describe 'adding a record with a singluar name ending with the letter es' do
    describe 'adding a singluar address record' do
      it 'creates a new Address record' do
        expect { data.add_address }.to change(Address, :count).by(1)
      end
      it 'creates a new PetProfile record' do # require parent for Address
        expect { data.add_address }.to change(PetProfile, :count).by(1)
      end
      it 'creates a new Pet record' do # required parent for PetProfile
        expect { data.add_address }.to change(Pet, :count).by(1)
      end
    end

    describe 'adding multiple address records' do
      it 'creates three new Address records' do
        expect { data.add_addresses(3) }.to change(Address, :count).by(3)
      end
      it 'creates a new PetProfile record' do # require parent for Address
        expect { data.add_addresses(3) }.to change(PetProfile, :count).by(1)
      end
      it 'creates a new Pet record' do# required parent for PetProfile
        expect { data.add_addresses(3) }.to change(Pet, :count).by(1)
      end
    end
  end
end
