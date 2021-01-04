# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative 'config/application'

Rails.application.load_tasks


task :get_tickers => :environment do
	# SELECT pool_hash.*, pool_meta_data.url FROM pool_hash JOIN pool_update ON pool_update.hash_id = pool_hash.id JOIN pool_meta_data ON pool_update.meta_id = pool_meta_data.id;
	pool_hashes = PoolUpdate.select("pool_hash.id pool_hash_id, pool_hash.view pool_addr, pool_hash.hash_raw, pool_meta_data.url, pool_update.active_epoch_no")
		.joins(:pool_hash)
		.joins(:pool_meta_data)
		.map { |pool_update| {pool_hash_id: pool_update.pool_hash_id, pool_addr: pool_update.pool_addr, pool_hash: pool_update.hash_raw, url: pool_update.url, active_epoch_no: pool_update.active_epoch_no} }

	pool_hashes_distinct = {}
	pool_hashes.each do |data|
		if !pool_hashes_distinct["#{data[:pool_hash_id]}"]
			pool_hashes_distinct["#{data[:pool_hash_id]}"] = data
		elsif pool_hashes_distinct["#{data[:pool_hash_id]}"][:active_epoch_no] < data[:active_epoch_no]
			pool_hashes_distinct["#{data[:pool_hash_id]}"] = data
		end
	end

	pool_hashes_distinct.each do |k, pool_hash|
		pool = Pool.find_by_id(pool_hash[:pool_hash_id])
		if pool
			scrape_ticker(pool)
		else
			pool = build_pool(pool_hash)
			scrape_ticker(pool) if pool
			puts "!!!! #{pool_hash[:pool_addr]} was not built!" if !pool
		end
	end
end



def build_pool(pool_hash)
	pool = Pool.new(
		pool_hash_id: pool_hash[:pool_hash_id],
		url: pool_hash[:url], 
		hash_hex: PoolHash.bin_to_hex(pool_hash[:pool_hash]))
	pool if pool.save
end



def scrape_ticker(pool)
	if !pool.ticker || pool.ticker.length > 5
		puts ''
		begin
			puts " ----------------- Ticker read in local DB was: #{pool.ticker}"

			if pool.url
				ticker = read_pool_url_json(pool.url, pool.hash_hex)
				 
				if ticker && (ticker.length < 7)
					pool.ticker = ticker
					pool.save
					puts pool.ticker
				else
					puts "no valid ticker found: #{ticker}"
					puts pool.hash_hex
				end
			else
				if !pool.ticker
					if pool.hash_hex
						pool.ticker = pool.hash_hex.slice(0,6)
						pool.save
					end
				else
					print "``#{pool.ticker}"
				end
			end
		rescue
			puts "!!!!! no valid ticker found: #{ticker}"
			puts "!!!!! pool.poolid: #{pool.hash_hex}"
		end
		puts '----------------------------- Ticker Search END'
		puts ''
	else
		print "``#{pool.ticker}" #ticker already existed and is fine
	end
end



def read_ticker_from_adapoolsDOTorg(hashid)
	#\x158\x06\xDB\xCD\x13M\xDE\xE6\x9A\x8CR\x04\xE3\x8A\xC8\x04H\xF6#B\xF8\xC2<\xFEK~\xDF
	#153806dbcd134ddee69a8c5204e38ac80448f62342f8c23cfe4b7edf
	puts ' >>>>>>>>>>>>>>>>> INSIDE read_ticker_from_adapoolsDOTorg'
	begin
		resp = Net::HTTP.get_response(URI.parse("https://adapools.org/pool/#{hashid}"))
		puts "visiting https://adapools.org/pool/#{}"
		data = resp.body
		res = data.split("data-id=\"#{hashid}\"")[1].split(']')[0].split('[')[1]
		if res.length > 2 && res.length < 6
			return res
		else 
			if hashid
				return hashid.slice(0,6)
			else
				return nil
			end
		end
	rescue
		if hashid
				return hashid.slice(0,6)
		else
			return nil
		end
	end
end



def read_pool_url_json(url, hashid)
	attempt = 0
	print ' >>>>>>>>>>>>>>>>> INSIDE read_pool_url_json :: '
	begin
		puts url
		byebug
		resp = Net::HTTP.get_response(URI.parse(url))
		data = resp.body
		json = JSON.parse(data)
		return json['ticker']
	rescue
		puts ' >>>>>>>>>>>>>>>>> failed! ...'
		# read_ticker_from_adapoolsDOTorg(hashid)
	end
end