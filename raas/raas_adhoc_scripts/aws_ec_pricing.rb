#!/usr/bin/env ruby

require 'json'
require 'set'
require 'open-uri'

NODES = ARGV[0] ? ARGV[0].to_i : 1
SHORT_REGION = {
  'EU (Ireland)' => 'eu-west-1',
  'US West (N. California)' => 'us-west-1',
  'US West (Oregon)' => 'us-west-2',
}
PRICE_REGION = 'US West (Oregon)'
GRPN_REGIONS = ['EU (Ireland)','US West (N. California)','US West (Oregon)']
INDEX_CACHE = '/tmp/aws_ec_pricing_index.json'
PRICING_INDEX_URL ='https://pricing.us-east-1.amazonaws.com/offers/v1.0/aws/AmazonElastiCache/current/index.json'

if !File.exist?(INDEX_CACHE)
  puts "fetching pricing index from: #{PRICING_INDEX_URL}"
  f = open(PRICING_INDEX_URL)
  puts "writing pricing index cache: #{INDEX_CACHE}"
  IO.write(INDEX_CACHE, IO.read(f))
end
puts "reading pricing index cache: #{INDEX_CACHE} (#{((Time.now - File.stat(INDEX_CACHE).mtime).to_i / 86400.0).round} days old)"
pricing = JSON.parse(IO.read(INDEX_CACHE))

price_by_type = pricing['products'].values.map{|p| ["#{p['attributes']['cacheEngine']}:#{p['attributes']['usagetype']}".downcase.sub('-nodeusage:',':'),
                                   p['attributes'].merge(pricing['terms']['OnDemand'][p['sku']].values.first['priceDimensions'].values.first)]}.to_h

types = {}
price_by_type.each do |k,pr|
  next if pr['cacheEngine'] != 'Redis'
  next if pr['locationType'] != 'AWS Region'
  next unless GRPN_REGIONS.include?(pr['location'])
  t = pr['instanceType']
  next if t.start_with?('cache.t1')
  next if t.start_with?('cache.t2')
  next if t.start_with?('cache.m') && t != 'cache.m6g.large'
  next if t.start_with?('cache.r3')
  next if t.start_with?('cache.r4')
  next if t.start_with?('cache.r5')
  next if t.start_with?('cache.c1')
  if !types.include?(t)
    types[t] = {}
    types[t]['instanceType'] = t
    types[t]['memory'] = pr['memory'].to_f
    types[t]['networkPerformance'] = pr['networkPerformance']
    types[t]['regions'] = Set.new
  end
  types[t]['regions'].add pr['location']
  types[t]['price_mo'] = pr['pricePerUnit']['USD'].to_f*24*30 if pr['location'] == PRICE_REGION
end
info = types.values
info.delete_if{|v| v['regions'].to_a.sort != GRPN_REGIONS}

puts ""
puts "price in #{PRICE_REGION}"
puts "showing node types found in all #{GRPN_REGIONS}"
puts ""
printf "%18s %20s %10sxM) %15s\n" %["instanceType","1xM","75%%(#{NODES}","#{NODES}xM+#{NODES}xR"]
info.sort_by{|i| i['memory']}.each do |i|
  printf "%18s %20s %10sGB %15s\n" %[i['instanceType'],i['networkPerformance'],(i['memory']*0.75*NODES).round(3),"$#{(i['price_mo']*NODES*2).round}/mo"]
end
