require 'spec_helper'

describe Relationship do
  it { should have_many(:relationship_people) }
  it { should have_many(:people).through(:relationship_people) }
  it { should have_many(:relationship_events) }
  it { should have_many(:events).through(:relationship_events) }
end
