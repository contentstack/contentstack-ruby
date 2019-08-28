client1 = Contentstack::Client.new("blt5e17a22511d66341", "blt3ee1eeeae1f7b9f9", "environments",{"region": Contentstack::Region::EU})
client2 = Contentstack::Client.new("site_api_key", "access_token", "enviroment_name",{"host": "https://stag-cdn.contentstack.io"})
client3 = Contentstack::Client.new("site_api_key", "access_token", "enviroment_name")
client1 = Contentstack::Client.new("blt5e17a22511d66341", "blt3ee1eeeae1f7b9f9", "environments",{"region": Contentstack::Region::EU})
irb -Ilib -rContentstack


