Fabricator(:person) do
  kbn { sequence(:kbn) { |i| SecureRandom.hex(12) + i.to_s } }
  first_name { sequence(:first_name) { |i| SecureRandom.hex(12) + i.to_s } }
  last_name { sequence(:last_name) { |i| SecureRandom.hex(12) + i.to_s } }
end
