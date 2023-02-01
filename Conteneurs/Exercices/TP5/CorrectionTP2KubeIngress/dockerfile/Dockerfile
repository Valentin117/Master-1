FROM nginx:1.17

ARG MENU_TYPE=pizza

COPY index.html /usr/share/nginx/html/

RUN sed -i -e "s|MY_MENU|${MENU_TYPE}|g" /usr/share/nginx/html/index.html

CMD ["nginx", "-g", "daemon off;"]