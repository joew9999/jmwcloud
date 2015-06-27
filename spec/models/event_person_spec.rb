require 'spec_helper'

describe EventPerson do
  it { should belong_to(:person) }
  it { should belong_to(:event) }

  it { should validate_presence_of(:person_id) }
  it { should validate_presence_of(:event_id) }
end
