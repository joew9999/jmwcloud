Fabricator(:event) do
  time '2015-01-01'
  location { sequence(:location) { |i| SecureRandom.hex(12) + i.to_s } }
end
