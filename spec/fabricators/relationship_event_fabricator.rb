Fabricator(:relationship_event) do
  relationship_id { Fabricate(:relationship).id }
  event_id { Fabricate(:event).id }
  order 1
end
