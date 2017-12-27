require_relative "helper/data_works_spec_helper"

describe 'DataWorks#set_restriction' do
  let!(:data) { TheDataWorks.new }

  describe 'setting a restriction using the metheod/registry option'do
    let!(:darth_cuddles) { data.add_pet }
    let!(:kittylo_ren) { data.add_pet }

    it 'restricts the parent record for new children to the given object' do
      death_star = data.add_toy
      data.set_restriction(for_model: :pet, to: kittylo_ren)
      star_killer = data.add_toy
      expect(death_star.pet).to eq darth_cuddles
      expect(star_killer.pet).to eq kittylo_ren
    end
  end

  describe 'setting a restriction using the block option'do
    let!(:darth_cuddles) { data.add_pet }
    let!(:kittylo_ren) { data.add_pet }

    it 'restricts the parent record for new children to the given object' do
      death_star = data.add_toy
      star_killer = data.set_restriction(for_model: :pet, to: kittylo_ren) do
        data.add_toy
      end
      wookie_doll = data.add_toy
      expect(death_star.pet).to eq darth_cuddles
      expect(wookie_doll.pet).to eq darth_cuddles
      expect(star_killer.pet).to eq kittylo_ren
    end
  end
end

