FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN dpkg --add-architecture i386 && apt update

RUN apt install -y \
    wget \
    ca-certificates \
    xz-utils \
    libbz2-1.0 \
    libbz2-1.0:i386 \
    libnss3 \
    libnss3:i386 \
    libgtk2.0-0 \
    libgtk2.0-0:i386 \
    libxtst6 \
    libxtst6:i386 \
    libxrender1 \
    libxrender1:i386 \
    libxrandr2 \
    libxrandr2:i386 \
    libxi6 \
    libxi6:i386 \
    libxaw7:i386 \
    libxslt1.1:i386 \
    libc6-i386 \
    lib32stdc++6 \
    libasound2 \
    xauth \
    && rm -rf /var/lib/apt/lists/*

# Download installer
RUN wget -O /tmp/devolo.run \
    https://www.devolo.global/fileadmin/Web-Content/DE/products/hnw/devolo-cockpit/software/devolo-cockpit-v5-2-0-185-linux.run \
    && chmod +x /tmp/devolo.run

RUN /tmp/devolo.run || true

CMD ["/opt/devolo/dlancockpit/bin/dlancockpit"]
