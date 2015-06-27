require 'spec_helper'

describe Person do
  it { should have_one(:user) }
  it { should have_many(:people_book_numbers) }
  it { should have_many(:book_numbers).through(:people_book_numbers) }
  it { should have_many(:events) }

  describe 'birth' do
    let!(:person) { Fabricate(:person) }

    context "has birth event" do
      let!(:birth) { Fabricate(:event, type: 'Birth', person_id: person.id) }

      it "should return that birth event" do
        person.birth.should == birth
      end
    end

    context "no birth event" do
      it "should return a new birth event" do
        person.birth.person_id.should == person.id
        person.birth.type.should == 'Birth'
        person.birth.location.should be_nil
        person.birth.time.should be_nil
      end
    end
  end

  describe 'death' do
    let!(:person) { Fabricate(:person) }

    context "has death event" do
      let!(:death) { Fabricate(:event, type: 'Death', person_id: person.id) }

      it "should return that death event" do
        person.death.should == death
      end
    end

    context "no death event" do
      it "should return a new death event" do
        person.death.person_id.should == person.id
        person.death.type.should == 'Death'
        person.death.location.should be_nil
        person.death.time.should be_nil
      end
    end
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
