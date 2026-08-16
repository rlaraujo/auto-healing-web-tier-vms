FROM nginx:1.27-alpine

WORKDIR /usr/share/nginx/html
COPY templates/index.html /usr/share/nginx/html/index.html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
