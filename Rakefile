# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative 'config/application'

Rails.application.load_tasks


task :get_tickers => :environment do
	PoolHash.all.each do |pool_hash|
		pool = pool_hash.pool
		if pool
			scrape_ticker(pool)
		else
			byebug
			scrape_ticker(Pool.find_or_create_by(pool_hash_id: pool_hash.id))
		end
	end
end



def scrape_ticker(pool)
	if !pool.ticker || pool.ticker.length > 5
		puts ''
		begin
			puts " ----------------- Ticker read in local DB was: #{pool.ticker}"
			if pool.url
				ticker = read_pool_url_json(pool.url, pool.hashid)
				 
				if ticker && (ticker.length < 7)
					pool.ticker = ticker
					pool.save
					puts pool.ticker
				else
					puts "no valid ticker found: #{ticker}"
					puts pool.poolid
				end
			else
				if !pool.ticker
					if hashid
						pool.ticker = pool.hashid.slice(0,6)
						pool.save
					end
				else
					print "``#{pool.ticker}"
				end
			end
		rescue
			"!!!!! no valid ticker found: #{ticker}"
			"!!!!! ool.poolid: #{pool.poolid}"
		end
		puts '---------------------------------------------'
		puts ''
	else
		print "``#{pool.ticker}"
	end
end


def read_ticker_from_adapoolsDOTorg(hashid)
	#\x158\x06\xDB\xCD\x13M\xDE\xE6\x9A\x8CR\x04\xE3\x8A\xC8\x04H\xF6#B\xF8\xC2<\xFEK~\xDF
	#153806dbcd134ddee69a8c5204e38ac80448f62342f8c23cfe4b7edf
	puts ' >>>>>>>>>>>>>>>>> INSIDE read_ticker_from_adapoolsDOTorg'
	begin
		resp = Net::HTTP.get_response(URI.parse("https://adapools.org/pool/#{hashid}"))
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
		resp = Net::HTTP.get_response(URI.parse(url))
		data = resp.body
		json = JSON.parse(data)
		return json['ticker']
	rescue
		puts ' >>>>>>>>>>>>>>>>> failed! ...'
		# read_ticker_from_adapoolsDOTorg(hashid)
	end
end