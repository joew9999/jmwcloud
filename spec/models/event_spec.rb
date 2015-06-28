require 'spec_helper'

describe Event do
  it { should have_many(:event_people) }
  it { should have_many(:people).through(:event_people) }
  it { should have_many(:relationship_events) }
  it { should have_many(:relationships).through(:relationship_events) }

  describe 'relationship order' do
    let!(:relationship) { Fabricate(:relationship) }
    let!(:first) { Fabricate(:event) }
    let!(:second) { Fabricate(:event) }

    context "in order" do
      it "should return a list in order" do
        Fabricate(:relationship_event, event_id: first.id, relationship_id: relationship.id, order: 1)
        Fabricate(:relationship_event, event_id: second.id, relationship_id: relationship.id, order: 2)

        relationship.events.should == [first, second]
      end
    end

    context "mixed up" do
      it "should return a list in order" do
        Fabricate(:relationship_event, event_id: first.id, relationship_id: relationship.id, order: 2)
        Fabricate(:relationship_event, event_id: second.id, relationship_id: relationship.id, order: 1)

        relationship.events.should == [second, first]
      end
    end
  end
end
