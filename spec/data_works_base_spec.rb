require_relative 'helper/data_works_spec_helper'

describe 'DataWorks::Base' do
  it 'raises a custom error for missing methods' do
    message =  'bogus method not found in data works'
    expect { DataWorks::Base.new.bogus }.to raise_error(NoMethodError, message)
  end
end

describe 'DataWorks::Works' do
  let(:data_works) { DataWorks::Works.new }

  describe 'managing current defaults' do
    before { data_works.set_current_default(for_model: :chicken, to: :egg) }

    describe '#set_current_default' do
      it 'correctly sets the default' do
        expect(data_works.current_default[:chicken]).to eq :egg
      end
    end

    describe '#clear_current_default_for' do
      before { data_works.clear_current_default_for(:chicken) }

      it 'correctly sets the default' do
        expect(data_works.current_default[:chicken]).to be_nil
      end
    end
  end
end
