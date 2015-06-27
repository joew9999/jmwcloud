require 'spec_helper'

describe PeopleBookNumber do
  it { should belong_to(:person) }
  it { should belong_to(:book_number) }

  it { should validate_presence_of(:person_id) }
  it { should validate_presence_of(:book_number_id) }
end
