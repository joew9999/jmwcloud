require 'spec_helper'

describe Event do
  it { should have_many(:event_people) }
  it { should have_many(:people).through(:event_people) }
end
