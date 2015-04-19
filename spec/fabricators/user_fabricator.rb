Fabricator(:user) do
  email { sequence(:email) { |i| SecureRandom.hex(12) + "#{i}@thomasarts.com" } }
  password 'password'
  password_confirmation 'password'
end
