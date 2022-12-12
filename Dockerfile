FROM node:16-alpine AS BUILD_STG
WORKDIR /
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build
ENV NODE_ENV production

FROM grafana/k6
COPY --from=BUILD_STG /build/k6-test-template.js ./k6-test-template.js
COPY --from=BUILD_STG /build/k6-test-template.js.map ./k6-test-template.js.map
ENTRYPOINT [ "k6", "run", "k6-test-template.js" ]