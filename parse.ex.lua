-- you will need to do 'sudo apt-get install lua-expat' to get the lxp module
require "lxp"
require "io"

body = io.input("test.xml"):read("*a")
 
function In(str, tbl)
  for _, v in pairs(tbl) do
    if str == v then return true end
  end
end

elements = {"Author", "Title", "Creator", "DetailPageURL", "FormattedPrice", "IFrameURL", "TotalReviews"}
-- http://docs.aws.amazon.com/AWSECommerceService/2011-08-01/DG/CHAP_response_elements.html#TotalReviews
-- TotalReviews comes closest to the element I want, but that does not seem to exist, AverageReview.
-- CustomerReviews/Review/Rating is too specific but may be useful, if we can figure out how to get it 

-- mostly taken from http://matthewwild.co.uk/projects/luaexpat/examples.html
callbacks = {
  StartElement = function(parser, name)
    if In(name, elements) then
      io.write(name, ": ")
      callbacks.CharacterData = function(parser, string)
        io.write(string, "\n")
      end
    end
  end,

  EndElement = function(parser, name)
    if In(name, elements) then
      callbacks.CharacterData = false
    elseif name == "Item" then
      io.write("---\n")
    end
  end,

  CharacterData = false
}

parser = lxp.new(callbacks)

parser:parse(body)
parser:close()
