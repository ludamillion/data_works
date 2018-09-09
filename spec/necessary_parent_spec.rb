require_relative "helper/data_works_spec_helper"

describe "#initialize" do
  describe "when the given entry is a symbol" do
   let(:necessary_parent) { DataWorks::NecessaryParent.new(:iron) }
  
    it "sets @association_name to the given symbol" do
      expect(necessary_parent.association_name).to eq :iron
    end
  
    it "sets @model_name to the given symbol" do
      expect(necessary_parent.model_name).to eq :iron
    end
  end
  describe "when the given entry is a hash" do
   let(:necessary_parent) { DataWorks::NecessaryParent.new({ wearable: :cotton }) }
  
    it "sets @association_name to the given symbol" do
      expect(necessary_parent.association_name).to eq :wearable
    end
  
    it "sets @model_name to the given symbol" do
      expect(necessary_parent.model_name).to eq :cotton
    end
  end
end