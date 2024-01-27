FROM debian:testing-slim

ENV SSL_CERT_FILE="/etc/ssl/certs/ca-certificates.crt"
ENV SSL_CERT_DIR="/etc/ssl/certs"
ENV RACKET_VERSION=8.7

WORKDIR /app

RUN apt update -y && apt upgrade -y \
    && apt install -y --no-install-recommends git racket ca-certificates \
    && apt autoclean -y \
    && apt autoremove -y \
    && rm -rf /var/lib/apt/lists/*

#RUN raco setup
RUN raco pkg config --set catalogs \
    "https://download.racket-lang.org/releases/${RACKET_VERSION}/catalog/" \
    "https://pkg-build.racket-lang.org/server/built/catalog/" \
    "https://pkgs.racket-lang.org" \
    "https://planet-compats.racket-lang.org"

RUN git clone --depth=1 https://gitdab.com/cadence/breezewiki.git . \
    && raco pkg install --batch --auto --no-docs --skip-installed req-lib \
    && raco req -d
EXPOSE 10416
CMD ["racket", "dist.rkt"]`
