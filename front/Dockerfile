FROM debian:bookworm-slim AS build

RUN apt-get update && apt-get install -y curl git unzip

RUN git clone https://github.com/flutter/flutter.git -b stable /flutter
ENV PATH="/flutter/bin:/flutter/bin/cache/dart-sdk/bin:${PATH}"

WORKDIR /app

COPY . .

RUN flutter clean
RUN flutter pub get
RUN flutter build web --release

FROM nginx:alpine

COPY --from=build /app/build/web /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]