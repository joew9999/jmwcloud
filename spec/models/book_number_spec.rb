require 'spec_helper'

describe BookNumber do
  it { should have_many(:people).through(:people_book_numbers) }
  it { should have_many(:people_book_numbers) }

  it { should validate_presence_of(:kbn) }
  it { should validate_uniqueness_of(:kbn) }
end

