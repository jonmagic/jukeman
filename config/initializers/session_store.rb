# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_jukeman_test_session',
  :secret      => '526e2f8f773365d0bbf350b33b964abe717d0471390e4e1b561bd88f0ee1fe4ce16d793b9d8c42e53935d3ec01d82789244221982eb7f1019c9906c93845e8ec'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
