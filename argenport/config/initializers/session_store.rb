# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_argenport_session',
  :secret      => 'cbde47b04a476b18f0ccea3a4bff178beb60312f2641735a2df816c347659c9d2fff812964d052ee4d66359abbb4ccedcf50dc1124bb304a65cc2bcc33fb6732'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
