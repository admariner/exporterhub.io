FROM node:lts-alpine as builder

LABEL version=release-fe0.3.12

ARG NODE_ENV
ENV NODE_ENV=${NODE_ENV}
ENV TSC_COMPILE_ON_ERROR true

WORKDIR /data

COPY ./ /data

RUN yarn set version berry
RUN yarn install
RUN yarn build

FROM nginx:1.13.9

WORKDIR /usr/share/nginx/html
RUN rm -rf /etc/nginx/conf.d

COPY --from=builder /data/build /usr/share/nginx/html
COPY --from=builder /data/entrypoint.sh /usr/share/nginx/html
COPY ./nginx.conf /etc/nginx/conf.d/default.conf

ENV SERVICE_PUBLIC "n"
EXPOSE 3000

ENTRYPOINT ./entrypoint.sh
