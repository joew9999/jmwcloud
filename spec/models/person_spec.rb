require 'spec_helper'

describe Person do
  it { should have_one(:user) }
end
