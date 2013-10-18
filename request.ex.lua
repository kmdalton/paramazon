require "affiliate_request"

r = requester:new("private.conf")
r["Keywords"]="Lua"
r["ItemPage"]="1"
r["SearchIndex"]="Books"
r["ResponseGroup"]="ItemAttributes, Reviews"

url = r:request()

b, c, h = r:request()

print(b)
