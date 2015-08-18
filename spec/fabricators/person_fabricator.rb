Fabricator(:person) do
  primary_kbn { sequence(:primary_kbn) { |i| SecureRandom.hex(12) + i.to_s } }
  first_name { sequence(:first_name) { |i| SecureRandom.hex(12) + i.to_s } }
  last_names { sequence(:last_names) { |i| [SecureRandom.hex(12) + i.to_s] } }
end
