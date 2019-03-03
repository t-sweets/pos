FROM nginx:1.15-alpine

RUN rm -f /etc/nginx/conf.d/*

COPY rails_nginx.conf /etc/nginx/conf.d/rails_nginx.conf

CMD ["nginx", "-g", "daemon off;"]
