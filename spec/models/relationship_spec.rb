require 'spec_helper'

describe Relationship do
  it { should have_many(:relationship_people) }
  it { should have_many(:people).through(:relationship_people) }
  it { should have_many(:relationship_events) }
  it { should have_many(:events).through(:relationship_events) }

  describe 'import' do
    let(:people_csv_text) { File.read(File.join(Rails.root, '/spec/fixtures/files/people_good.csv')) }
    let(:people_csv) { CSV.parse(people_csv_text, :headers => true) }
    let(:csv_text) { File.read(File.join(Rails.root, '/spec/fixtures/files/relationships_good.csv')) }
    let(:csv) { CSV.parse(csv_text, :headers => true) }

    before(:each) do
      Person::import(people_csv)
      Relationship::import(csv)
    end

    it "should make relationships" do
      Relationship.all.count.should == 80
    end

    it "should connect people to relationship" do
      RelationshipPartner.all.count.should == 160
    end

    it "should make marriages" do
      Marriage.all.count.should == 74
    end
  end
end
