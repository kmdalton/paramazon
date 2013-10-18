require "affiliate_request"
local lom = require "lxp.lom"
local cjson = require("cjson")

args = {}
for i,v in pairs(arg) do
  if i > 0 then args[i] = v end
end

keywords = table.concat(args, " ")

r = requester:new("private.conf")
r["Keywords"] = keywords
r["ItemPage"] = "1"
r["SearchIndex"] = "Books"
r["ResponseGroup"]="ItemAttributes, Reviews"

body = r:request()

print(cjson.encode(lom.parse(body)))
