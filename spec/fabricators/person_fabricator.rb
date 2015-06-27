Fabricator(:person) do
  first_name { sequence(:first_name) { |i| SecureRandom.hex(12) + i.to_s } }
  last_name { sequence(:last_name) { |i| SecureRandom.hex(12) + i.to_s } }
end
