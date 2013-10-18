require "io"
local lom = require "lxp.lom"
-- run 'sudo apt-get install lua-cjson' to get this one
local cjson = require("cjson")

body = io.input("test.xml"):read("*a")
 
parseTree = lom.parse(body)

json = cjson.encode(parseTree)

print(json)
