require 'spec_helper'

describe Person do
  it { should have_one(:user) }
  it { should have_many(:people_book_numbers) }
  it { should have_many(:book_numbers).through(:people_book_numbers) }

  describe 'import' do
    let(:csv_text) { File.read(File.join(Rails.root, '/spec/fixtures/files/people_good.csv')) }
    let(:csv) { CSV.parse(csv_text, :headers => true) }

    it "should make people" do
      people = Person::import(csv)
      Person.all.count.should == 4281
    end
  end
end
