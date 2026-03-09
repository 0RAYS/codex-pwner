FROM rocketdev/0rays-codex-auditor:latest

RUN sed -i '/^#\\[multilib\\]$/,/^$/{s/^#//}' /etc/pacman.conf && \
    pacman -Syu --noconfirm \
    python-pwntools python-redis python-protobuf python-paho-mqtt protobuf-c \
    paho-mqtt-c msgpack-c python-lief lib32-glibc lib32-gcc-libs json-c \
    json-glib jsoncpp ceccomp boost-libs && \
    pacman -Scc --noconfirm
