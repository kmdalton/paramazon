package = "paramazon"
version = "0.0.1"

source = {
  url = "git://github.com/kmdalton/paramazon.git",
  branch = "master"
}

description = {
  summary = "Parameterized Amazon searches displayed graphically."
  license = "BSD"
}

dependencies = {
  "https://raw.github.com/leafo/heroku-openresty/master/heroku-openresty-1.2.8.6-1.rockspec",
  "socket",
  "luaexpat"
}
