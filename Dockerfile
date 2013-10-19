# Paramazon on OpenResty and Ubuntu
#
# VERSION 0.1.0

# use base image provided by CoreOS
FROM coreos/openresty

RUN cp /usr/local/openresty/nginx/conf/mime.types /app/conf
RUN mkdir /app/html

ADD *.lua
ADD private.conf
ADD nginx.conf /app/conf
ADD index.html /app/html

EXPOSE 80

CMD ["nginx", "-c /app/conf/nginx.conf -p /app"]
