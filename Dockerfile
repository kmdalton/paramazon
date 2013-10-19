# Paramazon on OpenResty and Ubuntu
#
# VERSION 0.1.0

# use base image provided by CoreOS; runs on top of Ubuntu 12.10 Quantal
FROM coreos/openresty
MAINTAINER James Koppen, jk@jameskoppen.com

ENV PATH /usr/local/openresty/nginx/sbin:$PATH

ADD affiliate_request.lua /app/
ADD base64.lua /app/
ADD app.lua /app/
ADD private.conf /app/
ADD nginx.conf /app/conf/
ADD index.html /app/html/

RUN cp /usr/local/openresty/nginx/conf/mime.types /app/conf
RUN apt-get update
RUN apt-get install -y lua-expat luarocks lua-socket
RUN luarocks install luacrypto
RUN luarocks install lua-cjson

EXPOSE 80

CMD ["nginx", "-c", "/app/conf/nginx.conf"]
# ENTRYPOINT ["nginx"]
