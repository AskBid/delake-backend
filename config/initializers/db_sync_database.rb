file = File.read(Rails.root.join("config", "db_sync_database.yml"))
yaml = ERB.new(file).result

DB_SYNC_DB = YAML.load(yaml)[Rails.env.to_s]

# DB_SYNC_DB = YAML.load_file(File.join(Rails.root, "config", "db_sync_database.yml"))[Rails.env.to_s]
# DB_SYNC_DB["username"] = ENV['HOST_PG_DATABASE_USERNAME']
# DB_SYNC_DB["password"] = ENV['HOST_PG_DATABASE_PASSWORD']
# DB_SYNC_DB["host"] = ENV['HOST_PG_DATABASE_IP']