FROM soem/wine:develop
MAINTAINER ChihChieh Huang <soem.hcc@gmail.com>

WORKDIR /home/docker

RUN \
    winetricks wenquanyi && \
    echo 'zh_TW.UTF-8 UTF-8' | sudo tee -a /etc/locale.gen && \
    echo 'ja_JP.UTF-8 UTF-8' | sudo tee -a /etc/locale.gen && \
    echo 'zh_CN.UTF-8 UTF-8' | sudo tee -a /etc/locale.gen && \
    sudo locale-gen && \
    sudo pacman -S xorg-server-xvfb --noconfirm

ARG FOOBAR2K='https://www.foobar2000.org'

RUN \
    bash -c 'sudo Xvfb :8 &' && \
    export DISPLAY=:8 && \
    echo '---- Download Foobar2000 ----' && \
    DOWNLOAD_PAGE=$(curl -s "${FOOBAR2K}/download" | gawk -F '"' '/href=".*exe"/ {print $2}' | head -n 1) && \
    DOWNLOAD_PATH=$(curl -s "${FOOBAR2K}${DOWNLOAD_PAGE}" | gawk -F '"' '/href=".*exe"/ {print $2}') && \
    echo "${FOOBAR2K}${DOWNLOAD_PATH}" && \
    wget -q "${FOOBAR2K}${DOWNLOAD_PATH}" -O foobar2k_installer.exe && \
    wine foobar2k_installer.exe /S && \
    echo '---- Download Foobar2000 EncoderPack ----' && \
    DOWNLOAD_PAGE=$(curl -s "${FOOBAR2K}/encoderpack" | gawk -F '"' '/href=".*exe"/ {print $2}' | head -n 1) && \
    DOWNLOAD_PATH=$(curl -s "${FOOBAR2K}${DOWNLOAD_PAGE}" | gawk -F '"' '/href=".*exe"/ {print $2}') && \
    echo "${FOOBAR2K}${DOWNLOAD_PATH}" && \
    wget -q "${FOOBAR2K}${DOWNLOAD_PATH}" -O foobar2k_encoderpack.exe && \
    wine foobar2k_encoderpack.exe /S && \
    echo '---- Download Foobar2000 component ----' && \
    echo 'APE' && \
    APE_URL=$(curl -s "${FOOBAR2K}/components/view/foo_input_monkey" | gawk -F '"' '/href.*fb2k-component/ {print $2}' | head -n 1) && \
    wget -q "${FOOBAR2K}${APE_URL}" && \
    echo 'TTA' && \
    TTA_URL=$(curl -s "${FOOBAR2K}/components/view/foo_input_tta" | gawk -F '"' '/href.*fb2k-component/ {print $2}' | head -n 1) && \
    wget -q "${FOOBAR2K}${TTA_URL}" && \
    echo 'TAK' && \
    TAK_URL=$(curl -s "${FOOBAR2K}/components/view/foo_input_tak" | gawk -F '"' '/href.*fb2k-component/ {print $2}' | head -n 1) && \
    wget -q "${FOOBAR2K}${TAK_URL}" && \
    unzip Monkey.fb2k-component -d .wine/drive_c/Program\ Files\ \(x86\)/foobar2000/components/ && \
    unzip foo_input_tta.fb2k-component -d .wine/drive_c/Program\ Files\ \(x86\)/foobar2000/components/ && \
    unzip foo_input_tak.fb2k-component -d .wine/drive_c/Program\ Files\ \(x86\)/foobar2000/components/ && \
    rm -f foobar2k_installer.exe foobar2k_encoderpack.exe Monkey.fb2k-component foo_input_tta.fb2k-component foo_input_tak.fb2k-component

ENV LC_ALL zh_TW.UTF-8
ENV LANG zh_TW.UTF-8

CMD \
    bash -c 'LANG=en_US.UTF-8 wine .wine/drive_c/Program\ Files\ \(x86\)/foobar2000/foobar2000.exe &' && \
    bash -c 'LANG=en_US.UTF-8 wine explorer &' && \
    bash
