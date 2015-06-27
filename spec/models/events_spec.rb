require 'spec_helper'

describe Event do
  it { should belong_to(:person) }
end
