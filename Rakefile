# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative 'config/application'

Rails.application.load_tasks

require 'net/http'
require 'net/https'


task :func => :environment do
	ARGV.each { |a| task a.to_sym do ; end }
	func = ARGV[1]
	args = ARGV.slice(2,ARGV.length)
	args = [Block.current_epoch] if args.empty?
	args.each do |arg|
		puts "##{func} running for epoch: #{arg}"
		send(func, arg)
	end
end

task :get_tickers => :environment do
	get_tickers
end

task :write_JSON_EDF => :environment do
	ARGV.each { |a| task a.to_sym do ; end }
	epochs = ARGV.slice(1,ARGV.length)
	epochs.each do |epoch|
		edf = EpochDelegationsFlow.find_by(epochno: epoch)
		edf_json = JSON.parse(edf.json)
		File.write("/Users/sergio/Documents/github/assets/edf#{edf.epochno}.json", JSON.dump(edf_json))
	end
end


def record_supply(epochNo)
	er = EpochRecord.find_by(epoch_no: epochNo)
	prev_supply = er ? er.supply : 0
	current_supply = DbSyncRecord.supply(epochNo, true)
	puts "previous supply: #{prev_supply} ADA"
	puts er[:updated_at] if er
	puts "current supply:  #{current_supply} ADA"
	puts Time.now
	puts "difference:     +#{current_supply - prev_supply} ADA"
end


def epoch_flow(epochNo)
	tempHash = Delegation.epoch_flow(epochNo)
	edf = EpochDelegationsFlow.find_or_create_by(epochno: epochNo)
	edf.json = tempHash.to_json
	edf.save
	puts "Epoch Delegation Flow hash built"
	# File.open("storage/#{epochNo}.json","w") do |f|
	#   f.write(tempHash.to_json)
	# end
end



def get_tickers
	# SELECT pool_hash.*, pool_meta_data.url FROM pool_hash JOIN pool_update ON pool_update.hash_id = pool_hash.id JOIN pool_meta_data ON pool_update.meta_id = pool_meta_data.id;
	# pool_hashes = PoolUpdate.select("pool_hash.id pool_hash_id, pool_hash.view pool_addr, pool_hash.hash_raw, pool_meta_data.url, pool_update.active_epoch_no")
	# 	.joins(:pool_hash)
	# 	.joins(:pool_meta_data)
	# 	.map { |pool_update| {pool_hash_id: pool_update.pool_hash_id, pool_addr: pool_update.pool_addr, pool_hash: pool_update.hash_raw, url: pool_update.url, active_epoch_no: pool_update.active_epoch_no} }
	pool_ids = PoolHash.all.pluck(:view)
	pool_ids.each do |pool_id|
		metadata = blockfrost_pool_metadata(pool_id)
		binding.pry
	end
end


def build_pool(pool_hash)
	pool = Pool.new(
		pool_hash_id: pool_hash[:pool_hash_id],
		url: pool_hash[:url],
		hash_hex: PoolHash.bin_to_hex(pool_hash[:pool_hash]),
		pool_addr: pool_hash[:pool_addr])
	pool if pool.save
end



def scrape_ticker(pool)
	if !pool.ticker || pool.ticker.length > 5
		puts ''
		begin
			puts ''
			puts "----------------- Ticker read in local DB was: #{pool.ticker}"

			if pool.url
				ticker = read_pool_url_json(pool.url, pool.hash_hex)
				 
				if ticker && (ticker.length < 7)
					pool.ticker = ticker
					pool.save
					puts pool.ticker
				else
					puts "no valid ticker found: #{ticker}"
					puts "!!!!! pool.hex: #{pool.hash_hex}"
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
			puts "!!!!! pool.hex: #{pool.hash_hex}"
		end
		puts '----------------------------- Ticker Search END'
		puts ''
	else
		print "``#{pool.ticker}" #ticker already existed and is fine
	end
end



def blockfrost_pool_metadata(pool_id)
	con = Faraday.new 

	res = con.get do |req| 
			req.url "https://cardano-mainnet.blockfrost.io/api/v0/pools/#{pool_id}/metadata" 
			req.headers['project_id'] = 'A51ctLxii09vrz3loaadQm7hhgqDJLUx'
			req.headers['Content-Type'] = 'application/json'
	end
	
	JSON.parse(res.body)
end