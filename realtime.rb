require 'rubygems'
require 'bundler/setup'

require './gtfs-realtime.pb'
require 'beefcake'
require 'sinatra'
require 'json';
# require 'eventmachine'
# require 'em-http-request'
require 'open-uri'

url = "http://developer.trimet.org/ws/V1/TripUpdate?appID="
# Read the feed, decode it, and display it as a hash
get '/' do
	content_type :json
	data = FeedMessage.decode(open(url + params[:appID]).read)
	procData = Hash.new
	procData['header'] = data['header'].to_hash
	procData['trips'] = Hash.new	
	data['entity'].each_with_index {
		|t,i|
		temp = Hash.new
		temp['trip_id'] = t['trip_update']['trip']['trip_id']
		if t['trip_update']['stop_time_update'].class == Array
			#temp['stop_sequence'] = t['trip_update']['stop_time_update'][0]['stop_sequence']
			if t['trip_update']['stop_time_update'].length > 0
				stopTemp = Hash.new
				t['trip_update']['stop_time_update'].each_with_index {
					|s,j|
					stopTemp[j] = s['stop_sequence']
				}
				temp['stop_sequence'] = stopTemp
			end
			if t['trip_update']['stop_time_update'][0]['arrival'].class == TripUpdate::StopTimeEvent
				temp['delay'] = t['trip_update']['stop_time_update'][0]['arrival']['delay']
			end
			if t['trip_update']['stop_time_update'][0]['schedule_relationship']
				temp['scheduled'] = t['trip_update']['stop_time_update'][0]['schedule_relationship']
				#p t['trip_update']['stop_time_update'][0]['schedule_relationship']
			end
		end
		procData['trips'][i] = temp
	}
	procData.to_json
end
# In theory, beefcake is supposed built to work with eventmachine for http streaming
# However, I can't find any examples of this working…
#
# This was an attempt to get it working, which didn't succeed in opening a stream.
# Either I'm using EM wrong, or trimet's realtime stuff isn't actually streaming…
#
# EventMachine.run do
#   http = EventMachine::HttpRequest.new(url).get
#   decoded = FeedMessage.new
#   http.stream do |chunk|
#     # puts chunk
#     FeedMessage.decode(chunk, decoded)
#   end
#   puts decoded
# end
