###############################################################################
#                                                                             #
# Paramazon (until we get a cease & desist or some creativity)                #
# Tornado based webapp for scraping search results from ecommerce sites and   #
# displaying them in a nice graphical interface.                              #
#                                                                             #
###############################################################################

from tornado.ioloop import IOLoop
from tornado.web import RequestHandler, Application, url, asynchronous
import redis

class MainHandler(RequestHandler):
    def initialize(self, **kw):
        pass
    def get(self):
        pass
    def post(self):
        pass

class AmazonSearchHandler(RequestHandler):
    def initialize(self, **kw):
        pass
    def get(self):
        pass
    def post(self):
        pass

class SearchResultsHandler(RequestHandler):
    def initialize(self, **kw):
        pass
    def get(self):
        pass
    def post(self):
        pass

def main(config_filename):
    kwargs = {}
    for line in open(config_filename):
        if line[0] != '#' and len(line.split()) == 2:
            k,v = line.split()
            kwargs[k] = v

if __name__=='__main__':
    config_filename = 'config.txt' #TODO: write a proper parser with flags
    main(config_filename)
