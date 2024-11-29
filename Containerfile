FROM ghcr.io/ublue-os/arch-distrobox:latest

RUN pacman -Syyu --noconfirm && pacman -S --needed base-devel git --noconfirm

COPY distrobox-packages /
COPY extra-packages /

RUN useradd -m --shell=/bin/bash build && usermod -L build && \
    echo "build ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    echo "root ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

USER build
RUN grep -v '^#' /distrobox-packages | xargs paru -S --noconfirm
RUN grep -v '^#' /extra-packages | xargs paru -S --noconfirm

USER root
RUN userdel -r build && \
	rm -drf /home/build && \
	sed -i '/build ALL=(ALL) NOPASSWD: ALL/d' /etc/sudoers && \
	sed -i '/root ALL=(ALL) NOPASSWD: ALL/d' /etc/sudoers && \
	rm -rf /tmp/*

RUN ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/podman
RUN ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/docker
RUN ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/flatpak
RUN ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/rpm-ostree
RUN ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/tailscale
RUN ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/transactional-update
RUN ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/fish
RUN ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/ujust
RUN ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/code
