
echo "UPDATE / UPGRADE"

apt update

apt upgrade -y ; apt dist-upgrade -y ;

echo "INSTALLING REQ'D PACKAGES"

apt install -y logrotate cpulimit git build-essential cmake libuv1-dev libssl-dev libhwloc-dev automake libtool autoconf ;

echo "CREATING DIRECTORIES"

cd /root/

mkdir MINERS
cd MINERS

echo "CLONING XMRIG"

git clone https://github.com/MoneroOcean/xmrig.git

cd xmrig

echo "CMAKE XMRIG"

cmake ./

echo "MAKE XMRIG"

make

chmod +x xmrig

echo "INSTALLING XMRIG SERVICE"

export $HOSTNAME=$(cat /etc/hostname)

echo "HOSTNAME IS [ ${HOSTNAME} ]"

echo "[Unit]" | tee /etc/systemd/system/xmrig.service
echo "Description=XMRIG service" | tee -a /etc/systemd/system/xmrig.service
echo "After=network.target" | tee -a /etc/systemd/system/xmrig.service
echo "StartLimitIntervalSec=0" | tee -a /etc/systemd/system/xmrig.service
echo "[Service]" | tee -a /etc/systemd/system/xmrig.service
echo "Type=simple" | tee -a /etc/systemd/system/xmrig.service
echo "Restart=always" | tee -a /etc/systemd/system/xmrig.service
echo "RestartSec=3" | tee -a /etc/systemd/system/xmrig.service
echo "User=root" | tee -a /etc/systemd/system/xmrig.service
echo "ExecStart=/root/MINERS/xmrig/xmrig ${POOL_COIN} ${POOL_TLS} -o ${POOL_HOST}:${POOL_PORT} -u ${POOL_USER} -p ${POOL_PASS} ${POOL_LOG} --donate-level=0" | tee -a /etc/systemd/system/xmrig.service
echo "" | tee -a /etc/systemd/system/xmrig.service
echo "[Install]" | tee -a /etc/systemd/system/xmrig.service
echo "WantedBy=multi-user.target" | tee -a /etc/systemd/system/xmrig.service

echo "STARTING XMRIG SERVICE"

service xmrig start

echo "STARTING XMRIG SERVICE @ BOOT"

systemctl enable xmrig

