Fabricator(:event_person) do
  person_id { Fabricate(:person).id }
  event_id { Fabricate(:event).id }
end