require 'spec_helper'

describe Person do
  it { should have_one(:user) }
  it { should have_many(:people_book_numbers) }
  it { should have_many(:book_numbers).through(:people_book_numbers) }
  it { should have_many(:relationship_people) }
  it { should have_many(:relationships).through(:relationship_people) }
  it { should belong_to(:parent_relationship) }
  it { should have_many(:parents).through(:parent_relationship) }

  describe 'relationship order' do
    let!(:person) { Fabricate(:person) }
    let!(:first) { Fabricate(:relationship) }
    let!(:second) { Fabricate(:relationship) }

    context "in order" do
      it "should return a list in order" do
        Fabricate(:relationship_person, person_id: person.id, relationship_id: first.id, order: 1)
        Fabricate(:relationship_person, person_id: person.id, relationship_id: second.id, order: 2)

        person.relationships.should == [first, second]
      end
    end

    context "mixed up" do
      it "should return a list in order" do
        Fabricate(:relationship_person, person_id: person.id, relationship_id: first.id, order: 2)
        Fabricate(:relationship_person, person_id: person.id, relationship_id: second.id, order: 1)

        person.relationships.should == [second, first]
      end
    end
  end

  describe 'parents' do
  end

  describe 'partners' do
  end

  describe 'children' do
  end

  describe 'import' do
    let(:csv_text) { File.read(File.join(Rails.root, '/spec/fixtures/files/people_good.csv')) }
    let(:csv) { CSV.parse(csv_text, :headers => true) }

    it "should make people" do
      Person::import(csv)
      Person.all.count.should == 100
    end

    it "should only create one kbn number per person" do
      Person::import(csv)
      BookNumber.all.count.should == 100
      Person.all.first.book_numbers.count.should == 1
    end

    it "should have gender data" do
      Person::import(csv)
      Person.male.count.should == 56
      Person.female.count.should == 43
      Person.no_gender.count.should == 1
    end
  end
end
