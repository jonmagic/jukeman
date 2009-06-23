# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_vanilla_session',
  :secret      => '0f7791d29f56f0ce5642efbb1d0be4391e648164a92dd838368d62825f5dfa6d59c847b14067c4044cd25699ddaa1535c7f61e73a6074ed2f618b6a152fd5100'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
