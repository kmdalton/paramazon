require "affiliate_request"
require "lxp"
local json = require("cjson")

if not ngx.var.arg_keywords then
  ngx.say("Provide some keywords")
end

local args = ngx.req.get_uri_args()

local r = requester:new()
r["Keywords"] = args.keywords
r["ItemPage"] = "1"
r["SearchIndex"] = "Books" -- "Blended" for all product types
r["ResponseGroup"] = "ItemAttributes, Reviews"

local body = r:request()

function In(str, tbl)
  for _, v in pairs(tbl) do
    if str == v then return true end
  end
end

local elements = {
  "Author", "Title", "Creator", "DetailPageURL", "FormattedPrice", "IFrameURL", "TotalReviews"
}
local parsed = {}
local item = {}

callbacks = {
  StartElement = function(parser, name)
    if In(name, elements) then
      callbacks.CharacterData = function(parser, string)
        item[name] = string
      end
    end
  end,

  EndElement = function(parser, name)
    if In(name, elements) then
      callbacks.CharacterData = false
    elseif name == "Item" then
      parsed[#parsed + 1] = item; item = {}
    end
  end,

  CharacterData = false
}

local parser = lxp.new(callbacks)

parser:parse(body)
parser:close()

ngx.say(json.encode(parsed))
