# Dockerfile

FROM nginx

# Можно сразу перезаписать index.html
# RUN echo '<html><head>Hey, Netology</head><body><h1>I`m DevOps Engineer!</h1></body></html>' > /usr/share/nginx/html/index.html

# либо залить файлы сайта/приложения в папку
COPY html/ /usr/share/nginx/html

# открываем порты в контейнере
EXPOSE 80
