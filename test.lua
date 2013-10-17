require "affiliate_request"

r = requester:new("private.conf")
r["Operation"]="ItemSearch"
r["Keywords"]="Lua"
r["ItemPage"]="1"
r["SearchIndex"]="Books"

print(r:request())
