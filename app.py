###############################################################################
#                                                                             #
# Paramazon (until we get a cease & desist or some creativity)                #
# Tornado based webapp for scraping search results from ecommerce sites and   #
# displaying them in a nice graphical interface.                              #
#                                                                             #
###############################################################################

from tornado.ioloop import IOLoop
from tornado.web import RequestHandler, Application, url, asynchronous
from bs4 import BeautifulStoneSoup as bs #This is DEPRECATED -- TODO: proper import
from bottlenose import Amazon
import redis, re

#Go ahead, add more, I dare you.
mandatory_params = [
    'redis-host',
    'redis-port',
    'redis-db',
    'AWS_ACCESS_KEY_ID',
    'AWS_SECRET_ACCESS_KEY',
    'AWS_ASSOCIATE_TAG',
]

def sanitize(string):
    """
    santize(str) returns space separated list of lowercase alphanumerics
    """
    words = string.split()
    words = [re.sub(r'[^0-9A-Za-z]', '', i).lower() for i in words]
    return ' '.join(sorted(words))

class MainHandler(RequestHandler):
    def get(self):
        self.render('templates/index.html')

class AmazonSearchHandler(RequestHandler):
    def initialize(self, **kw):
        self.amazon = bottlenose.Amazon(
                kw['AWS_ACCESS_KEY_ID'],
                kw['AWS_SECRET_ACCESS_KEY'],
                kw['AWS_ASSOCIATE_TAG']
                )
        self.numpages = kw.get('pages', 10)
    def post(self):
        #TODO: proper error handling here for response
        query = int(self.get_argument('pages', self.pages))
        ASINs = []
        for i in range(1, pages)
            #TODO:figure out how long we should sleep here
            query = self.get_argument('query')
            soup  = bs(amazon.ItemSearch(Keywords=query, SearchIndex="All"))
            itemIDs = soup.findAll('ASIN') #Get all itemIDs



class SearchResultsHandler(RequestHandler):
    def initialize(self, **kw):
        pass
    def get(self):
        pass
    def post(self):
        pass

def main(config_filename):
    kw = {}
    for line in open(config_filename):
        if line[0] != '#' and len(line.split()) == 2:
            k,v = line.split()
            kw[k] = v

    #Here we check to make sure all the mandatory params are present and quit if they are not
    missing_params = [i for i in mandatory_params if i not in kw]
    if len(missing_params) > 0:
        print "Fatal error: missing the following parameters from {}".format(config_filename)
        for i in missing_params:
            print i 
        sys.exit()

    else:
        application = Application([
               (r"/", MainHandler, kw),
               (r"/results", AmazonSearchHandler, kw),
        ])


if __name__=='__main__':
    config_filename = 'config.txt' #TODO: write a proper parser with flags
    main(config_filename)
