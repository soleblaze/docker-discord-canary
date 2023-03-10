FROM ubuntu:latest

RUN apt-get update && \
  apt-get install -yq tzdata && \
  ln -fs /usr/share/zoneinfo/America/Chicago /etc/localtime && \
  dpkg-reconfigure -f noninteractive tzdata \
  && rm -rf /var/lib/apt/lists/* \
  && apt-get autoremove -y \
  && apt-get autoclean
ENV TZ="America/Chicago"

RUN apt-get update && apt-get install -y \
  ca-certificates \
  curl \
  gconf-service \
  gconf2 \
  gnome-keyring \
  libappindicator1 \
  libasound2 \
  libatomic1 \
  libc++1 \
  libcanberra-gtk3-module \
  libcap2 \
  libdrm2 \
  libgconf-2-4 \
  libgbm1 \
  libgtk-3-0 \
  libnotify4 \
  libnspr4 \
  libnss3 \
  libpulse0 \
  libx11-xcb1 \
  libxkbfile1 \
  libxss1 \
  libxtst6 \
  xdg-utils \
  && rm -rf /var/lib/apt/lists/* \
  && apt-get autoremove -y \
  && apt-get autoclean

RUN groupadd discord \
  && useradd -g discord -m -d /home/discord discord

WORKDIR /home/discord

RUN export URL=$(curl -sSI 'https://discordapp.com/api/download/canary?platform=linux&format=deb' | grep -F 'location: ' | awk '{print $2}' | tr -d '[:space:]') \
  && curl -sSL "$URL" > discord.deb \
  && dpkg -i discord.deb \
  && rm discord.deb \
  && rm -rf /var/lib/apt/lists/* \
  && chown -R discord:discord /home/discord

VOLUME /home/discord/
USER discord
ENTRYPOINT [ "/usr/bin/discord-canary", "--enable-features=UseOzonePlatform", "--ozone-platform=wayland" ]
