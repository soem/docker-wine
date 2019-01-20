FROM archimg/base:2019.01.01
MAINTAINER ChihChieh Huang <soem.hcc@gmail.com>

RUN \
    sed -i '/^#\[multilib\]$/!b;s/#//;n;s/#//' /etc/pacman.conf && \
    echo 'Server = http://ftp.tku.edu.tw/Linux/ArchLinux/$repo/os/$arch' > /etc/pacman.d/mirrorlist

# update
RUN \
    pacman -Syu --noconfirm && \
    pacman --noconfirm -S pacman-contrib && \
    pacman --noconfirm -S wget && \
    ##########################################################################
    # CLEAN UP SECTION - THIS GOES AT THE END                                #
    ##########################################################################
    # Remove info, man and docs
    rm -rf /usr/share/info/* && \
    rm -rf /usr/share/man/* && \
    rm -rf /usr/share/doc/* && \

    # Delete any backup files like /etc/pacman.d/gnupg/pubring.gpg~
    find /. -name "*~" -type f -delete && \

    # Cleanup pacman
    bash -c "echo 'y' | pacman -Scc >/dev/null 2>&1" && \
    paccache -rk0 >/dev/null 2>&1 &&  \
    rm -rf /var/lib/pacman/sync/*

RUN \
    pacman -Syy --noconfirm && \

    # Install common packages.
    pacman --noconfirm -S lib32-glibc lib32-zlib lib32-gcc-libs libxdamage libxxf86vm && \

    # Install the X-server and default to mesa both 32 and 64 bit
    #pacman --noconfirm -S libinput libwacom --ignore systemd -dd && \
    pacman --noconfirm -S xorg-server mesa-libgl lib32-mesa-libgl && \

    # Download and cache the Nvidia 367 drivers for run time.
    pacman --noconfirm \
           -S \
           nvidia-libgl \
           nvidia-utils \
           lib32-nvidia-utils \
           lib32-nvidia-libgl && \

    ##########################################################################
    # CLEAN UP SECTION - THIS GOES AT THE END                                #
    ##########################################################################
    # Remove info, man and docs
    rm -rf /usr/share/info/* && \
    rm -rf /usr/share/man/* && \
    rm -rf /usr/share/doc/* && \

    # Delete any backup files like /etc/pacman.d/gnupg/pubring.gpg~
    find /. -name "*~" -type f -delete && \

    # Cleanup pacman
    bash -c "echo 'y' | pacman -Scc >/dev/null 2>&1" && \
    paccache -rk0 >/dev/null 2>&1 &&  \
    rm -rf /var/lib/pacman/sync/*

#ADD scripts/X /service/X
ADD scripts/initialize-graphics /usr/bin/initialize-graphics

RUN \
    pacman -Syy --noconfirm && \

    # Install remaining packages
    pacman --noconfirm -S \
                inetutils \
                libxv \
                virtualgl \
                lib32-virtualgl \
                mesa-demos \
                lib32-mesa-demos && \

    # Fix VirtualGL for this hardcoded directory otherwise we can not connect with SSH.
    mkdir /opt/VirtualGL && \
    ln -s /usr/bin /opt/VirtualGL && \

    # Force VirtualGL to be preloaded into setuid/setgid executables (do not do if security is an issue)
    # chmod u+s /usr/lib/librrfaker.so && chmod u+s /usr/lib64/librrfaker.so && \

    ##########################################################################
    # CLEAN UP SECTION - THIS GOES AT THE END                                #
    ##########################################################################
    # Remove man and docs
    rm -rf /usr/share/man/* && \
    rm -rf /usr/share/doc/* && \

    # Delete any backup files like /etc/pacman.d/gnupg/pubring.gpg~
    find /. -name "*~" -type f -delete && \

    bash -c "echo 'y' | pacman -Scc >/dev/null 2>&1" && \
    paccache -rk0 >/dev/null 2>&1 &&  \
    rm -rf /var/lib/pacman/sync/*

RUN \
    pacman -Syy --noconfirm && \

    # Install remaining packages
    pacman --noconfirm -S \
                inetutils \
                libxv \
                virtualgl \
                lib32-virtualgl \
                mesa-demos \
                lib32-libpulse \
                lib32-alsa-plugins \
                lib32-mesa-demos && \

    # Install Wine & Winetricks dependencies
    pacman --noconfirm -S \
    cabextract \
    lib32-gnutls \
    lib32-mpg123 \
    lib32-ncurses \
    p7zip \
    unzip \
    wine-mono \
    wine_gecko \
    wine && \

    # Install samba for ntlm_auth
    pacman --noconfirm -S samba --assume-installed python2 && \

    # Install Winetricks from github as it is more recent.
    curl -o winetricks https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks && \
    install -Dm755 winetricks /usr/bin/winetricks &&  \
    rm winetricks && \

    ##########################################################################
    # CLEAN UP SECTION - THIS GOES AT THE END                                #
    ##########################################################################
    # Remove info, man and docs
    rm -rf /usr/share/info/* && \
    rm -rf /usr/share/man/* && \
    rm -rf /usr/share/doc/* && \

    # Delete any backup files like /etc/pacman.d/gnupg/pubring.gpg~
    find /. -name "*~" -type f -delete && \

    # Cleanup pacman
    bash -c "echo 'y' | pacman -Scc >/dev/null 2>&1" && \
    paccache -rk0 >/dev/null 2>&1 &&  \
    rm -rf /var/lib/pacman/sync/*

ARG uid=1000
ARG gid=1000
ARG audio_gid=92
ARG user_gid=100

RUN \
    pacman -Syy --noconfirm && \
    pacman --noconfirm -S sudo && \
    echo "docker ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/docker && \
    ( groupmod -g ${audio_gid} audio || groupadd -g ${audio_gid} audio ) && \
    #groupadd -g ${user_gid} users && \
    groupadd -g ${gid} docker && \
    useradd -m -g docker -G audio docker

USER docker

CMD \
    bash
