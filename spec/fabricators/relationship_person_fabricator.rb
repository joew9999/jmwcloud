Fabricator(:relationship_person) do
  relationship_id { Fabricate(:relationship).id }
  person_id { Fabricate(:person).id }
  order 1
end
