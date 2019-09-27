FROM node:10

# Configure for permissive TLS (works around many major connection errors)
ENV NODE_TLS_REJECT_UNAUTHORIZED=0

# Install the required package
RUN npm install -g cbt_tunnels@0.9.10

# Hook it up to the entrpoint / command
ENTRYPOINT [ "cbt_tunnels" ]
CMD [ "--help" ]