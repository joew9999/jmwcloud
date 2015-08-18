require 'spec_helper'

describe Person do
  it { should have_one(:user) }

  describe 'find_by_kbn' do
    context 'is primary kbn' do
      let!(:person) { Fabricate(:person, primary_kbn: 'foobuzz') }

      it 'should return person' do
        Person.find_by_kbn('foobuzz').should == person
      end
    end

    context 'kbn in list' do
      let!(:person) { Fabricate(:person, kbns: ['buzz', 'fizz', 'foobuzz', 'moo']) }

      it 'should return person' do
        Person.find_by_kbn('foobuzz').should == person
      end
    end

    context 'kbn only one in list' do
      let!(:person) { Fabricate(:person, kbns: ['foobuzz']) }

      it 'should return person' do
        Person.find_by_kbn('foobuzz').should == person
      end
    end

    context 'kbn not in list' do
      let!(:person) { Fabricate(:person) }

      it 'should return person' do
        Person.find_by_kbn('foobuzz').should_not == person
      end
    end
  end

  describe 'import' do
    let(:csv_text) { File.read(File.join(Rails.root, '/spec/fixtures/files/people_good.csv')) }
    let(:csv) { CSV.parse(csv_text, :headers => true) }

    it 'should make people' do
      Person.import(csv)
      Person.all.count.should == 100
    end

    it 'should have gender data' do
      Person.import(csv)
      Person.male.count.should == 56
      Person.female.count.should == 43
      Person.no_gender.count.should == 1
    end
  end
end
