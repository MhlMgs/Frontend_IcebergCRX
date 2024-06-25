# Verwenden eines Basis-Image für Node.js
FROM node:14

# Installation der notwendigen Pakete
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    git \
    libjson-c-dev \
    libwebsockets-dev \
    wget \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Installation ttyd
RUN wget https://github.com/tsl0922/ttyd/archive/refs/tags/1.6.3.tar.gz && \
    tar xzf 1.6.3.tar.gz && \
    cd ttyd-1.6.3 && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make && \
    make install && \
    cd ../.. && \
    rm -rf ttyd-1.6.3 1.6.3.tar.gz

# Arbeitsverzeichnis setzen
WORKDIR /app

# Kopieren und Installieren von Abhängigkeiten
COPY package*.json ./
RUN npm install

# Kopieren des restlichen Quellcodes
COPY . .

# Build der Anwendung (falls notwendig)
RUN npm run build

# Exponieren des Ports für das Web-Terminal
EXPOSE 8080

# Startskript hinzufügen
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Standardbefehl zum Starten der Anwendung und ttyd
CMD ["/start.sh"]
