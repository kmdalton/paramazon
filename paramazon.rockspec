package = "paramazon"
version = "0.1.0"

source = {
  url = "git://github.com/kmdalton/paramazon.git",
  branch = "master",
}

description = {
  summary = "Parameterized Amazon searches displayed graphically."
  license = "BSD",
}

dependencies = {
  "https://raw.github.com/leafo/heroku-openresty/master/heroku-openresty-dev-1.rockspec",
  "luasocket",
  "luaexpat",
  "luacrypto",
  "lua-cjson",
}
