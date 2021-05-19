require "google/cloud/dns"

Google::Cloud::Dns.configure do |config|
  config.project_id  = ENV["PROJECT_NAME"]
  config.credentials = "/app/credentials.json"
end

dns = Google::Cloud::Dns.new

if ARGV.first == "list"
  require "terminal-table"

  tables = dns.zones.map do |zone|
    Terminal::Table.new do |t|
      t.title = "#{zone.dns} (ZONE_NAME = #{zone.name})"
      t.headings = "RECORD_NAME", "Current Data"
      zone.records.reject {|record| record.type != "A"}.each do |record|
        t << [record.name, record.data]
      end
    end
  end

  tables.each do |table|
    puts table
    puts
  end

  exit 0
end

# Here's the actual daemon:
require 'net/http'

loop do
  zone_name = ENV["ZONE_NAME"]
  record_names = ENV["RECORD_NAME"].split(",")

  zone = dns.zone zone_name

  ip_address = Net::HTTP.get(URI("https://checkip.amazonaws.com")).chomp

  record_names.each do |record_name|
    zone.modify record_name, "A" do |r|
      r.data = [ip_address]
    end
  end

rescue StandardError => e
  puts e
ensure
  sleep ENV["INTERVAL"] || 60*60*24 # one day
end