require "affiliate_request"

r = requester:new("private.conf")
r["Keywords"]="Lua"
r["ItemPage"]="1"
r["SearchIndex"]="Books"
r["ResponseGroup"]="ItemAttributes, Reviews"

b, c, h = r:request()

body = io.open("test.xml", "w+")
body:write(b)
body:flush(); body:close()
