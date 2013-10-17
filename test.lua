require "affiliate_request"
http = require("socket.http")

r = requester:new("private.conf")
r["Operation"]="ItemSearch"
r["Keywords"]="Lua"
r["ItemPage"]="1"
r["SearchIndex"]="Books"

url = r:request()

r, c, h = http.request(url)

print(r)
