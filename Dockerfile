FROM rocketdev/0rays-codex-auditor:latest

ARG GLOBAL_MIRROR
RUN if [ -n "${GLOBAL_MIRROR:-}" ]; then \
        sed -i 's/^# //' /etc/pacman.d/archlinuxcn-mirrorlist /etc/pacman.d/mirrorlist; \
    fi

RUN sed -i '/^#\\[multilib\\]$/,/^$/{s/^#//}' /etc/pacman.conf && \
    pacman -Syu --noconfirm \
    python-pwntools python-redis python-protobuf python-paho-mqtt protobuf-c \
    paho-mqtt-c msgpack-c python-lief lib32-glibc lib32-gcc-libs json-c \
    json-glib jsoncpp ceccomp && \
    pacman -Scc --noconfirm

RUN if [ -n "${GLOBAL_MIRROR:-}" ]; then \
        cp /etc/pacman.d/mirrorlist.build-default /etc/pacman.d/mirrorlist; \
        cp /etc/pacman.d/archlinuxcn-mirrorlist.build-default /etc/pacman.d/archlinuxcn-mirrorlist; \
    fi

RUN git clone https://github.com/matrix1001/glibc-all-in-one.git /root/glibc-all-in-one --depth 1

COPY configs/nginx.conf /etc/nginx/nginx.conf
COPY configs/supervisord.conf /etc/supervisord.conf
COPY configs/debian.urls /etc/debuginfod/
COPY scripts/tmux.sh /tmux.sh
COPY scripts/init /init
COPY configs/pwn.conf /root/.pwn.conf
COPY skills/* /data/skills/
RUN chmod +x /tmux.sh /init
