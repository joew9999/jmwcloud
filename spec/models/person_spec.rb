require 'spec_helper'

describe Person do
  it { should have_one(:user) }

  describe 'import' do
    let(:csv_text) { File.read(File.join(Rails.root, '/spec/fixtures/files/people_good.csv')) }
    let(:csv) { CSV.parse(csv_text, :headers => true) }

    it 'should make people' do
      Person.import(csv)
      Person.all.count.should == 4311
    end

    it 'should have gender data' do
      Person.import(csv)
      Person.male.count.should == 2238
      Person.female.count.should == 2062
      Person.no_gender.count.should == 11
    end
  end
end
