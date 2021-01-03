class DbSyncRecord < ActiveRecord::Base
  self.abstract_class = true
  establish_connection DB_SYNC_DB
  # DB_SYNC_DB is defined in `config/initializers/db_sync_database.rb`
end
