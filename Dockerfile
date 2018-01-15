FROM node:alpine
WORKDIR /srv/node

COPY . .

RUN yarn --force

HEALTHCHECK --interval=10s --timeout=2s --start-period=5m --retries=3 \
    CMD wget -qO- http://localhost:32100/health | grep -i "ok" 2>/dev/null >/dev/null || false

CMD ["node", "."]
