FROM nginx:latest
WORKDIR /website
COPY /website/index.html /usr/share/nginx/html/index.html
