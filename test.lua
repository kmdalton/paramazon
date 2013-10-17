require "affiliate_request"
http = require("socket.http")

r = requester:new("private.conf")
r["Operation"]="ItemSearch"
r["Keywords"]="Lua"
r["ItemPage"]="1"
r["SearchIndex"]="Books"

url = r:request()

b, c, h = http.request(url)

body = io.open("test.xml", "w+")
body:write(b)
body:flush(); body:close()
