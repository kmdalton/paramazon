-- you will need to do 'sudo apt-get install lua-expat' to get the lxp module
require "lxp"
require "io"

body = io.input("test.xml"):read("*a")
 
-- parseTree = lxp.lom.parse(body)

function In(str, tbl)
  for _, v in pairs(tbl) do
    if str == v then return true end
  end
end

elements = {"Author", "Title", "Creator", "DetailPageURL"}

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
    elseif name == "ItemAttributes" then
      io.write("---\n")
    end
  end,

  CharacterData = false
}

parser = lxp.new(callbacks)

parser:parse(body)
parser:close()
