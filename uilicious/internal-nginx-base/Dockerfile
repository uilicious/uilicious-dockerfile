FROM nginx:1.17-alpine

# This is the run script, called after git clone/pull
ENV CONFIG_POSTSCRIPT ""

RUN mkdir /application


# Ensure node modules are installed again
RUN cd /application/
RUN cp /usr/share/nginx/html/index.html /application/


COPY ./default.conf /etc/nginx/conf.d/default.conf

RUN ls /etc/nginx

RUN cat /etc/nginx/conf.d/default.conf

EXPOSE 80


# Lets chain up userpanel.sh as entrypoint
#ENTRYPOINT ["/entrypoint/config-copy.sh"]