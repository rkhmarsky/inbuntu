#!/bin/bash
#Подключаем свой репозиторий, нужно указать доменное имя
apt-key add /install/intime.key
add-apt-repository http://172.16.16.156
apt update
apt upgrade -y

apt install /install/teamviewer_14.6.2452_amd64.deb -y
apt install /install/nomachine_6.8.1_1_amd64.deb -y
chmod -x /usr/NX/bin/nxplayer
echo "EnableMenuConnections 0" >> /usr/NX/etc/node.cfg
echo "UpdateFrequency 0" >> /usr/NX/etc/srever.cfg
apt install openjdk-8-jdk -y

#Устанавливаем электрум
tar -C /home/intime -xvf /install/eps_intime_client.tar
chmod +x /home/intime/eps_intime_client/eps_intime_client/run.sh
chmod +x /home/intime/eps_intime_client/rkks-fat-server.jar
usermod -a -G dialout intime
chown -R intime:intime /home/intime/eps_intime_client/

#Копируем значки на рабочем столе
mkdir /etc/skel/Desktop
tar -C '/etc/skel/Desktop' -xvf '/install/link.tar'
rm /usr/share/applications/fcitx*
rm /usr/share/applications/ibus-setup.desktop
rm /usr/share/applications/light-locker-settings.desktop
mkdir /home/intime/Рабочий\ стол
mkdir /home/intime/Desktop
cp /etc/skel/Desktop/*.desktop /home/intime/Рабочий\ стол
cp /etc/skel/Desktop/*.desktop /home/intime/Desktop

#Установка Libreoffice
apt install libreoffice -y
apt install libreoffice-l10n-ru -y
apt install libreoffice-help-ru -y
apt install hunspell-uk -y
apt install aspell-uk -y
apt install myspell-uk -y

#MS corefonts
mkdir /usr/share/fonts/truetype/msttcorefonts
tar -C /usr/share/fonts/truetype/msttcorefonts -xvf /install/msfonts.tar

#Удаляем ненужный софт
apt purge gnumeric -y
apt purge abiword -y
apt remove light-locker -y

#Прописываем параметр автопроверки и исправления ошибок жесткого диска
sed -i 's/.*GRUB_CMDLINE_LINUX_DEFAULT="quiet splash".*/GRUB_CMDLINE_LINUX_DEFAULT="quiet splash  fsck.repair=yes"/' /etc/default/grub
update-grub

#устанавливаем метапакет
apt install hello -y

apt update
apt upgrade -y
exit 0
