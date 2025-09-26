  FROM debian:bookworm-slim AS build-env
          RUN apt-get update && apt-get install -y \
              curl git wget unzip xz-utils zip libglu1-mesa ca-certificates \
&& rm -rf /var/lib/apt/lists/*
 
          ENV FLUTTER_HOME="/opt/flutter"
          ENV PATH="$FLUTTER_HOME/bin:$PATH"
          ENV PUB_CACHE="/opt/flutter/.pub-cache"
 
          RUN git clone --depth 1 --branch stable https://github.com/flutter/flutter.git $FLUTTER_HOME
          RUN flutter config --enable-web
          RUN flutter precache --web
          RUN flutter doctor -v
 
          WORKDIR /app
          COPY pubspec.yaml pubspec.lock ./
          RUN flutter pub get
          COPY . .
 
          RUN flutter clean
          RUN flutter pub get
          RUN flutter packages pub run build_runner build --delete-conflicting-outputs
          RUN flutter pub run intl_utils:generate
          RUN flutter pub get
 
          RUN flutter build web \
              --release \
              --target=lib/main/main_dev.dart \
              --base-href=/ \
              --verbose
 
          FROM nginx:alpine AS production
          RUN rm -rf /usr/share/nginx/html/*
          COPY --from=build-env /app/build/web /usr/share/nginx/html/
          COPY nginx.conf /etc/nginx/conf.d/default.conf
          RUN echo 'server {' > /etc/nginx/conf.d/default.conf && \
              echo '    listen 80;' >> /etc/nginx/conf.d/default.conf && \
              echo '    server_name localhost;' >> /etc/nginx/conf.d/default.conf && \
              echo '    root /usr/share/nginx/html/;' >> /etc/nginx/conf.d/default.conf && \
              echo '' >> /etc/nginx/conf.d/default.conf && \
              echo '    # Disable caching for HTML files' >> /etc/nginx/conf.d/default.conf && \
              echo '    location /exchek {' >> /etc/nginx/conf.d/default.conf && \
              echo '        try_files $uri $uri/ /index.html =404;' >> /etc/nginx/conf.d/default.conf && \
              echo '        add_header Cache-Control "no-store, no-cache, must-revalidate, proxy-revalidate, max-age=0";' >> /etc/nginx/conf.d/default.conf && \
              echo '    }' >> /etc/nginx/conf.d/default.conf && \
              echo '' >> /etc/nginx/conf.d/default.conf && \
              echo '    # Handle static assets with no caching for immediate updates' >> /etc/nginx/conf.d/default.conf && \
              echo '    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot|json|map)$ {' >> /etc/nginx/conf.d/default.conf && \
              echo '        add_header Cache-Control "no-store, no-cache, must-revalidate, proxy-revalidate, max-age=0";' >> /etc/nginx/conf.d/default.conf && \
              echo '        add_header Pragma "no-cache";' >> /etc/nginx/conf.d/default.conf && \
              echo '        add_header Expires 0;' >> /etc/nginx/conf.d/default.conf && \
              echo '        try_files $uri =404;' >> /etc/nginx/conf.d/default.conf && \
              echo '    }' >> /etc/nginx/conf.d/default.conf && \
              echo '}' >> /etc/nginx/conf.d/default.conf
 
          EXPOSE 80
          CMD ["nginx", "-g", "daemon off;"]