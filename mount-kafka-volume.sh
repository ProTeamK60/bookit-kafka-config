#Find block device that is not xvda and have no
lsblk -pnlb|sed -E 's/ +/ /g' >lsblk.log
UNMOUNTED_DISK=$( sqlite3 -batch diskdata.db <<EOF
CREATE TABLE IF NOT EXISTS BLOCKS (Name, Maj, RM, Size, Type, RO, Mountpoint);
.separator ' '
.import lsblk.log BLOCKS
SELECT DISTINCT Name FROM BLOCKS WHERE Name NOT IN (SELECT substr(Name, 1, 9) FROM BLOCKS WHERE Mountpoint LIKE '/%') AND Mountpoint LIKE '';
EOF
)
rm lsblk.log
rm diskdata.db
[ "x${UNMOUNTED_DISK}" == "x" ] && exit 1
[ "x$(file -bs ${UNMOUNTED_DISK})" != "xdata" ] && exit 2
mkfs.xfs -f "${UNMOUNTED_DISK}"
mkdir /data
mount -t xfs "${UNMOUNTED_DISK}" /data
echo "${UNMOUNTED_DISK} /data xfs defaults 0 0" >> /etc/fstab

