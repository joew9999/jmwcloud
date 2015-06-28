require 'spec_helper'

describe RelationshipPerson do
  it { should belong_to(:person) }
  it { should belong_to(:relationship) }
end
