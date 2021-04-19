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
	# updates pool that have no ticker
	get_tickers
end

task :populate_tickers => :environment do
	# fetches all pools even if already have a ticker
	get_tickers(false)
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



def get_tickers(only_if_not_exist = true)
	# saving the commented code below because coudl be useful in the future I think it finds pool_hahses excluding retired
	# SELECT pool_hash.*, pool_meta_data.url FROM pool_hash JOIN pool_update ON pool_update.hash_id = pool_hash.id JOIN pool_meta_data ON pool_update.meta_id = pool_meta_data.id;
	# pool_hashes = PoolUpdate.select("pool_hash.id pool_hash_id, pool_hash.view pool_addr, pool_hash.hash_raw, pool_meta_data.url, pool_update.active_epoch_no")
	# 	.joins(:pool_hash)
	# 	.joins(:pool_meta_data)
	# 	.map { |pool_update| {pool_hash_id: pool_update.pool_hash_id, pool_addr: pool_update.pool_addr, pool_hash: pool_update.hash_raw, url: pool_update.url, active_epoch_no: pool_update.active_epoch_no} }
	PoolHash.all.pluck(:view, :id).each do |pool_id|
		if only_if_not_exist
			pool = Pool.find_by(pool_hash_id: pool_id.last)
			existing_ticker = Pool.find_by(pool_hash_id: pool_id.last).ticker if pool
		end
		if !existing_ticker
			metadata = blockfrost_pool_metadata(pool_id.first)
			build_pool(metadata, pool_id.first, pool_id.last)
			print metadata['ticker']
			print  ' :: '
		end
	end
end

def build_pool(metadata, pool_id, pool_hash_id)
	# => {"url"=>"https://stakenuts.com/mainnet.json",
	# "hash"=>"47c0c68cb57f4a5b4a87bad896fc274678e7aea98e200fa14a1cb40c0cab1d8c",
	# "ticker"=>"NUTS",
	# "name"=>"StakeNuts",
	# "description"=>"StakeNuts.com",
	# "homepage"=>"https://stakenuts.com/"}
	pool = Pool.find_or_create_by(pool_hash_id: pool_hash_id)
	pool.update(
		ticker: metadata['ticker'],
    url: metadata['url'],
    hash_hex: metadata['hash'],
    pool_addr: pool_id,
		name: metadata['name'],
		homepage:  metadata['homepage'],
		description:  metadata['description']
	)
	pool.save
end

def blockfrost_pool_metadata(pool_id)
	con = Faraday.new 

	res = con.get do |req| 
			req.url "https://cardano-mainnet.blockfrost.io/api/v0/pools/#{pool_id}/metadata" 
			req.headers['project_id'] = ENV['BLOCKFROST_PROJECT_ID']
			req.headers['Content-Type'] = 'application/json'
	end
	
	JSON.parse(res.body)
end