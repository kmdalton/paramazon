require "affiliate_request"

r = requester:new("private.conf")
r["Keywords"]="Lua"
r["ItemPage"]="1"
r["SearchIndex"]="Books"

b, c, h = r:request(url)

body = io.open("test.xml", "w+")
body:write(b)
body:flush(); body:close()
