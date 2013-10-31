-- you will need to do 'sudo apt-get install lua-expat' to get the lxp module
require "lxp"
require "io"
local json = require("cjson")

local body = io.input("test.xml"):read("*a")
 
function In(str, tbl)
  for _, v in pairs(tbl) do
    if str == v then return true end
  end
end

local elements = {"Author", "Title", "Creator", "DetailPageURL", "FormattedPrice", "IFrameURL", "TotalReviews"}
-- http://docs.aws.amazon.com/AWSECommerceService/2011-08-01/DG/CHAP_response_elements.html#TotalReviews
-- TotalReviews comes closest to the element I want, but that does not seem to exist, AverageReview.
-- CustomerReviews/Review/Rating is too specific but may be useful, if we can figure out how to get it 

local parsed = {}
local item = {}

-- mostly taken from http://matthewwild.co.uk/projects/luaexpat/examples.html
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
 
print(json.encode(parsed))
