FROM quay.io/toolbx/arch-toolbox:latest

RUN pacman -Syyu --noconfirm && pacman -S --needed base-devel git --noconfirm

RUN wget https://raw.githubusercontent.com/greyltc-org/docker-archlinux-aur/refs/heads/master/add-aur.sh -O /tmp/add-aur.sh
RUN chmod +x /tmp/add-aur.sh
RUN /tmp/add-aur.sh buildhelper yay-bin
RUN userdel -r buildhelper

COPY extra-packages /
RUN grep -v '^#' /extra-packages | xargs yay -S --noconfirm

COPY distrobox-packages /
RUN grep -v '^#' /distrobox-packages | xargs yay -S --noconfirm
