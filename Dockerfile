FROM docker.io/library/node:20.11.1 as build
RUN mkdir /peer-server
WORKDIR /peer-server
COPY package.json package-lock.json ./
RUN npm clean-install
COPY . ./
RUN npm run build
RUN npm run test

FROM docker.io/library/node:20.11.1-alpine as production
RUN mkdir /peer-server
WORKDIR /peer-server
COPY package.json package-lock.json ./
RUN npm clean-install --omit=dev
COPY --from=build /peer-server/dist/bin/peerjs.js ./
ENV PORT 443
EXPOSE ${PORT}
ENTRYPOINT ["node", "peerjs.js", "--port", "${PORT}", "--key", "peerjs", "--path", "/gamingcouch", "--debug"]
