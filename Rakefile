# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative 'config/application'

Rails.application.load_tasks

require 'net/http'
require 'net/https'


task :get_epoch_pool_sizes => :environment do
	ARGV.each { |a| task a.to_sym do ; end }
	args = ARGV.slice(1,ARGV.length)
	args = [Block.current_epoch] if args.empty?
	args.each do |arg|
		puts "epoch: #{arg}"
		get_epoch_pool_sizes(arg)
	end
end

task :re_ticker_epoch_pool_sizes_sizes => :environment do
	#thi is only in case #get_epoch_pool_sizes is run before some pool tickers have been collected and you want to fix that 
	ARGV.each { |a| task a.to_sym do ; end }
	args = ARGV.slice(1,ARGV.length)
	args = [Block.current_epoch] if args.empty?
	args.each do |arg|
		puts "epoch: #{arg}"
		re_ticker_epoch_pool_sizes(arg)
	end
end

task :get_tickers => :environment do
	get_tickers
end

def get_epoch_pool_sizes(epochNo)
	rejects = {rejects: []}
	PoolHash.all.map do |pool_hash|
		size = pool_hash.size(epochNo)
		print pool_hash.id
		print "\r"
		if pool_hash.pool
			pool_hash.pool.epoch_pool_sizes.build(size: size, epochno: epochNo, ticker: pool_hash.pool.ticker)
			pool_hash.pool.save
		else
			rejects[:rejects] << pool_hash.view
			print "       !!!!!! NO POOL for #{pool_hash.view}"
			print "\r"
		end
	end
	rejects
end

def re_ticker_epoch_pool_sizes(epochNo)
	epss = EpochPoolSize.epoch(epochNo)
	epss.each do |eps|
		eps.ticker = eps.pool.ticker if eps.pool.ticker
		print eps.ticker
		print "\r"
		eps.save
	end
end

def get_tickers
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
		hash_hex: PoolHash.bin_to_hex(pool_hash[:pool_hash],
		pool_addr: pool_hash[:pool_addr]))
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



def read_ticker_from_adapoolsDOTorg(hashid)
	#\x158\x06\xDB\xCD\x13M\xDE\xE6\x9A\x8CR\x04\xE3\x8A\xC8\x04H\xF6#B\xF8\xC2<\xFEK~\xDF
	#153806dbcd134ddee69a8c5204e38ac80448f62342f8c23cfe4b7edf
	puts '>>>>>>>>>>>>>>>>> INSIDE read_ticker_from_adapoolsDOTorg'
	begin
		resp = Net::HTTP.get_response(URI.parse("https://adapools.org/pool/#{hashid}"))
		puts "visiting https://adapools.org/pool/#{hashid}"
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
	print '>>>>>>>>>>>>>>>>> INSIDE read_pool_url_json :: '
	begin
		puts url
		uri = URI.parse(url)
		Net::HTTP.new(uri.hostname, uri.port) do |http|
		  http.open_timeout = 3000
		  resp = http.request_get(uri.request_uri)
		end
		# resp = Net::HTTP.get_response(URI.parse(url))
		data = resp.body
		json = JSON.parse(data)
		return json['ticker']
	rescue
		puts '>>>>>>>>>>>>>>>>> failed! ...'
		read_ticker_from_adapoolsDOTorg(hashid)
	end
end