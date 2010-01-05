# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_vi3_session',
  :secret      => '8edcb8d338c5eae7f28e17241e0b6ff69c0ce7e3345db3722ea43b3c81d8234e12c92fb82c2ca6a0a9829d366a41900a737e4d5d22f0115ef3a018b0d816ede6'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
