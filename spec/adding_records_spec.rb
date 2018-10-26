require_relative "helper/data_works_spec_helper"

describe TheDataWorks do
  let!(:data) { TheDataWorks.new }

  describe 'adding a record with no necessary parents' do
    describe 'add_pet' do
      it 'creates a Pet record' do
        expect { data.add_pet }.to change(Pet, :count).by(1)
      end
    end

    describe 'with factory traits' do
      let(:put_a_bird_on_it) { data.add_pet_bird }

      describe 'add_pet_bird' do
        it 'creates a Pet record' do
          expect { put_a_bird_on_it }.to change(Pet, :count).by(1)
        end
        it 'creates a record with the required trait' do
          the_bird = put_a_bird_on_it
          expect(the_bird.kind).to eq 'Bird'
        end
      end
    end
  end

  describe 'adding a record with one necessary parent' do
    describe 'add_pet_sitter' do
      it 'creates a PetSitter record' do
        expect { data.add_pet_sitter }.to change(PetSitter, :count).by(1)
      end
      it 'creates an Agency record' do
        expect { data.add_pet_sitter }.to change(Agency, :count).by(1)
      end
    end

    describe 'with factory traits' do
      describe 'on the child model' do
        let(:da_hoomans_toy) { data.add_hooman_toy }

        describe 'add_hooman_toy' do
          it 'creates a Pet record' do
            expect { da_hoomans_toy }.to change(Pet, :count).by(1)
          end
          it 'creates a record with the required trait' do
            robo_vac = da_hoomans_toy
            expect(robo_vac.kind).to eq 'Robot Vacuum'
          end
        end
      end

      describe 'on the child and parent models' do
        let(:a_tiny_bell) { data.add_bell_toy }

        describe 'add_bell_toy' do
          it 'creates a Pet record' do
            expect { a_tiny_bell }.to change(Pet, :count).by(1)
          end
          it 'creates a record with the required trait on both models' do
            the_bell = a_tiny_bell
            the_bird = data.the_pet_bird
            expect(the_bell.kind).to eq 'Bell'
            expect(the_bird.kind).to eq 'Bird'
          end
        end
      end
    end
  end

  describe 'adding a record with multiple necessary parents' do
    describe 'add_pet_sitting_patronage' do
      it 'creates a PetSittingPatronage record' do
        expect { data.add_pet_sitting_patronage }.to change(PetSittingPatronage, :count).by(1)
      end
      it 'creates a Pet record' do
        expect { data.add_pet_sitting_patronage }.to change(Pet, :count).by(1)
      end
      it 'creates a PetSitter record' do
        expect { data.add_pet_sitting_patronage }.to change(PetSitter, :count).by(1)
      end
      it 'creates an Agency record' do # necessary for PetSitter
        expect { data.add_pet_sitting_patronage }.to change(Agency, :count).by(1)
      end
    end
  end

  describe 'adding multiple records at once' do
    describe 'add_pets(2)' do
      it 'creates two Pet records' do
        expect { data.add_pets(2) }.to change(Pet, :count).by(2)
      end
    end
    describe 'add_pet_sitter(s)' do
      it 'creates a PetSitter record' do
        expect { data.add_pet_sitters(2) }.to change(PetSitter, :count).by(2)
      end
      it 'creates an Agency record' do
        expect { data.add_pet_sitters(2) }.to change(Agency, :count).by(1)
      end
    end
  end

  describe 'adding a record with custom associations' do
    describe 'add_picture' do
      it 'creates a Picture record' do
        expect { data.add_picture }.to change(Picture, :count).by(1)
      end
      it 'creates a Product record (polymorhpic)' do
        expect { data.add_picture }.to change(Product, :count).by(1)
      end
      it 'creates an Album record (custom foreign key)' do
        expect { data.add_picture }.to change(Album, :count).by(1)
      end
    end
  end
end
