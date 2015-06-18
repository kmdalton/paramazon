###############################################################################
#                                                                             #
# Paramazon (until we get a cease & desist or some creativity)                #
# Tornado based webapp for scraping search results from ecommerce sites and   #
# displaying them in a nice graphical interface.                              #
#                                                                             #
###############################################################################

from tornado.ioloop import IOLoop
from tornado.web import RequestHandler, Application, url, asynchronous
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
