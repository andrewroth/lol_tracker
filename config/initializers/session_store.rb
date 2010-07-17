# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_lol_session',
  :secret      => 'fa78ba50bf65b95da7205b2afc0db74dd5664c5fe264d0ac38ae90c0025292a3d0ef65947af45f360ed8eb381911fecc9f0b42d39b1fcd58934c35d5e1e65674'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
