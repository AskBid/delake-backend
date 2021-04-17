file = File.read(Rails.root.join("config", "db_sync_database.yml"))
yaml = ERB.new(file).result

DB_SYNC_DB = YAML.load(yaml)[Rails.env.to_s]