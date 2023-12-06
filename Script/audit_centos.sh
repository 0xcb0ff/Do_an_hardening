#!/bin/bash
############################################################################

echo "#########################################################################"
echo "############################## CHECKLIST ################################"
echo "#########################################################################"
#CHECKLIST
############################################################################
#INFO
info="$(echo -e "\e[34m[INFO]\e[0m")"
pass="$(echo -e "\e[32m[PASSED]\e[0m")"
fail="$(echo -e "\e[31m[FAILED]\e[0m")"
remediation_filename="/tmp/$(date +'%b_%d_%H_%M_%S').txt"
touch "$remediation_filename"

############################################################################

var_1="1 Thiết lập ban đầu"
echo "$info $var_1"
var_1_1="1.1  Cấu hình filesystem"
echo "$info $var_1_1"
rem_1_1_1=$(cat  <<  EOF 
================================================
1.1.1->1.1.3 Chỉnh sửa file /etc/fstab thêm dòng <device> /tmp <fstype> defaults,rw,nosuid,nodev,noexec,relatime 0 0 vào cuối file
Chạy lệnh  mount -o remount /tmp để config lại
-----------------------------------------------
Tác động: Tác động: Việc đặt tùy chọn này đảm bảo rằng người dùng không thể tạo thiết bị đặc biệt theo khối hoặc ký tự trong /tmp. 
EOF
)
remember_1_1_1="false"

#########################################################################
var_1_1_1="1.1.1 Cấu hình tuỳ chọn nodev cho phân vùng /tmp"
if [ $(mount 2>/dev/null | grep -E "\s/tmp.*nodev" | wc -l) -eq 0 ]; then
	echo "$fail $var_1_1_1"
    remember_1_1_1="true"
else
	echo "$pass $var_1_1_1"
fi

#########################################################################
var_1_1_2="1.1.2 Cấu hình tuỳ chọn nosuid cho phân vùng /tmp"
if [ $(mount | grep -E "\s/tmp.*nosuid" | wc -l) -eq 0 ]; then
	echo "$fail $var_1_1_2"
    remember_1_1_1="true"
else
	echo "$pass $var_1_1_2"
fi

#########################################################################
var_1_1_3="1.1.3 Cấu hình tuỳ chọn noexec cho phân vùng /tmp"
if [ $(mount | grep -E "\s/tmp.*noexec" | wc -l) -eq 0 ]; then
	echo "$fail $var_1_1_3"
    remember_1_1_1="true"
else
	echo "$pass $var_1_1_3"
fi

if [ "$remember_1_1_1" == "true" ]; then
    echo "$rem_1_1_1" >> $remediation_filename
fi

remember_1_1_4="false"
rem_1_1_4=$(cat  <<  EOF 
================================================
1.1.4 - 1.1.6 Chỉnh sửa file /etc/fstab thêm dòng <device> /var/tmp <fstype> defaults,rw,nosuid,nodev,noexec,relatime 0 0 vào cuối file
Chạy lệnh  mount -o remount /var/tmp để config lại
-----------------------------------------------
Tác động: Tác động: Việc đặt tùy chọn này đảm bảo rằng người dùng không thể tạo thiết bị đặc biệt theo khối hoặc ký tự trong /var/tmp.
EOF
)
#########################################################################
var_1_1_4="1.1.4 Cấu hình tuỳ chọn nodev cho phân vùng /var/tmp"
if [ $(mount | grep "/var/tmp.*nodev" | wc -l) -eq 0 ]; then
	echo "$fail $var_1_1_4"
    remember_1_1_4="true"
else
	echo "$pass $var_1_1_4"
fi
#########################################################################
var_1_1_5="1.1.5 Cấu hình tuỳ chọn nosuid cho phân vùng /var/tmp"
if [ $(mount | grep " /var/tmp.*nosuid" | wc -l) -eq 0 ]; then
	echo "$fail $var_1_1_5"
    remember_1_1_4="true"
else
	echo "$pass $var_1_1_5"
fi
#########################################################################
var_1_1_6="1.1.6 Cấu hình tuỳ chọn noexec cho phân vùng /var/tmp"
if [ $(mount | grep " /var/tmp.*noexec" | wc -l) -eq 0 ]; then
	echo "$fail $var_1_1_6"
    remember_1_1_4="true"
else
	echo "$pass $var_1_1_6"
fi

if [ "$remember_1_1_4" == "true" ]; then
    echo "$rem_1_1_4" >> $remediation_filename
fi

rem_1_1_7=$(cat  <<  EOF 
================================================
1.1.7 Chỉnh sửa file /etc/fstab thêm dòng <device> /home <fstype> defaults,rw,nodev,relatime 0 0 vào cuối file
Chạy lệnh  mount -o remount /home để config lại
-----------------------------------------------
Tác động: Việc đặt tùy chọn này đảm bảo rằng người dùng không thể tạo thiết bị đặc biệt theo khối hoặc ký tự trong /home.
EOF
)
#########################################################################
var_1_1_7="1.1.7 Cấu hình tuỳ chọn nodev cho phân vùng /home"
if grep -q '/home' /etc/fstab; then
	if [ $(mount 2>/dev/null | grep /home.*nodev | wc -l) -eq 0 ]; then
	    echo "$fail $var_1_1_7"	
        echo "$rem_1_1_7" >> $remediation_filename
    else
	    echo "$pass $var_1_1_7"
	fi
else
	echo "$pass $var_1_1_7"
fi

remember_1_1_8=false
rem_1_1_8=$(cat  <<  EOF 
================================================
1.1.8 - 1.1.10 Phân vùng /dev/shm không được chỉ định trong file /etc/fstab, mặc dù mặc định được mount, thêm dòng sau vào cuối file /etc/fstab:
tmpfs /dev/shm tmpfs defaults,nodev,nosuid,noexec 0 0
Chạy lệnh  mount -o remount /dev/shm để config lại
-----------------------------------------------
Tác động: Việc đặt tùy chọn này đảm bảo rằng người dùng không thể tạo thiết bị đặc biệt theo khối hoặc ký tự trong /dev/shm.
EOF
)
#########################################################################
var_1_1_8="1.1.8 Cấu hình tuỳ chọn nodev cho phân vùng /dev/shm"
if [ $(mount | grep -E '\s/dev/shm.*nodev' | wc -l) -eq 0 ]; then
	echo "$fail $var_1_1_8"
    remember_1_1_8=true
else
	echo "$pass $var_1_1_8"
fi
#########################################################################
var_1_1_9="1.1.9 Cấu hình tuỳ chọn nosuid cho phân vùng /dev/shm"
if [ $(mount | grep -E '\s/dev/shm.*nosuid' | wc -l) -eq 0 ]; then
	echo "$fail $var_1_1_9"
    remember_1_1_8=true
else
	echo "$pass $var_1_1_9"
fi
#########################################################################
var_1_1_10="1.1.10 Cấu hình tuỳ chọn noexec cho phân vùng /dev/shm"
if [ $(mount | grep -E '\s/dev/shm.*noexec' | wc -l) -eq 0 ]; then
	echo "$fail $var_1_1_10"
    remember_1_1_8=true
else
	echo "$pass $var_1_1_10"
fi

if [ $remember_1_1_8 == true ]; then
    echo "$rem_1_1_8" >> $remediation_filename
fi

rem_1_1_11=$(cat  <<  EOF 
================================================
1.1.11 Thực hiện câu lệnh sau để đặt sticky bit cho toàn bộ thư mục dùng chung:
 df --local -P | awk {'if (NR!=1) print $6'} | xargs -I '{}' find '{}' -xdev -type d -perm -0002 2>/dev/null | xargs chmod a+t
-----------------------------------------------
Tác động: Không tác động lớn tới hệ thống.
EOF
)
#########################################################################
var_1_1_11="1.1.11 Cấu hình sticky bit cho tất cả các thư mục dùng chung"
if [ "$(df --local -P 2>/dev/null | awk {'if (NR!=1) print $6'} | xargs -I '{}' find '{}' -xdev -type d \( -perm -0002 -a ! -perm -1000 \) 2>/dev/null | wc -l)" -ne 0 ]; then
	echo "$fail $var_1_1_11"
    echo "$rem_1_1_11" >> $remediation_filename
else
	echo "$pass $var_1_1_11"
fi

rem_1_1_12=$(cat  <<  EOF 
================================================
1.1.12 Thực hiện câu lệnh sau để vô hiệu hóa autofs:
 systemctl disable autofs
-----------------------------------------------
Tác động: Việc sử dụng ổ đĩa cứng di động rất phổ biến đối với người dùng thông thường. Nếu tổ chức cho phép việc sử dụng lưu trữ hoặc phương tiện di động trên máy trạm, thì việc tắt autofs sẽ gây bất tiện cho người dùng.
EOF
)
#########################################################################
var_1_1_12="1.1.12 Cấu hình vô hiệu hoá automounting"
if [ "$(systemctl is-enabled autofs 2> /dev/null | grep "enabled" | wc -l)" -gt 0 ]; then
    echo "$fail $var_1_1_12"
    echo "$rem_1_1_12" >> $remediation_filename
else
	echo "$pass $var_1_1_12"
fi

############################################################################
rem_1_2_1=$(cat  <<  EOF
1.2.1. Cấu hình kích hoạt gpgcheck
Chỉnh sửa file cấu hình /etc/yum.config và đặt gpgcheck=1 ở mục [main].
Chỉnh sửa bất kỳ file nào trong /etc/yum.repos.d/* trả về gpgcheck=0 và đặt tất cả các trường hợp đó thành gpgcheck=1.
-----------------------------------------------
Tác động: Không tác động tới hệ thống.
EOF
)
var_1_2="1.2 Cấu hình cập nhật phần mềm"
echo "$info $var_1_2"
var_1_2_1="1.2.1 Cấu hình kích hoạt gpgcheck"
if [ "$(grep "^gpgcheck.*1" /etc/yum.conf | wc -l)" -eq 0 ] || [ "$(grep "^gpgcheck.*0" /etc/yum.repos.d/* | wc -l)" -gt 0 ]; then
    echo "$fail $var_1_2_1"
    echo "$rem_1_2_1" >> $remediation_filename
else
    echo "$pass $var_1_2_1"
fi

############################################################################
var_1_3="1.3 Kiểm tra tính toàn vẹn của filesystem"
echo "$info $var_1_3"
############################################################################
var_1_3_1="1.3.1 Kiểm tra cài đặt AIDE"
rem_1_3_1=$(cat  <<  EOF
Thực hiện câu lệnh sau và đảm bảo rằng aide được cài đặt:
yum install aide
aide --init
mv /var/lib/aide/aide.db.new.gz /var/lib/aide/aide.db.gz
-----------------------------------------------
Tác động: Việc theo dõi liên tục của AIDE có thể làm giảm hiệu suất hệ thống.
EOF
)
if [ "$(rpm -q aide | grep "not installed" | wc -l)" -ne 0 ]; then
    echo "$fail $var_1_3_1"
    echo "$rem_1_3_1" >> $remediation_filename
else
    echo "$pass $var_1_3_1"
fi

############################################################################
rem_1_3_2=$(cat  <<  EOF
Thực hiện câu lệnh sau:
crontab -u root -e
Đặt dòng sau vào crontab:
0 5 * * * /usr/sbin/aide --check
-----------------------------------------------
Tác động: Việc chạy crontab có thể gây tốn tài nguyên hệ thống.
EOF
)

var_1_3_2="1.3.2 Cấu hình kiểm tra tính toàn vẹn của filesystem"
if [ "$(crontab -u root -l 2> /dev/null | grep "0.*5.*\*.*\*.*\*.*/usr/sbin/aide.*--check" | wc -l)" -eq 0 ] || [ "$(grep -r "0.*5.*\*.*\*.*\*.*/usr/sbin/aide.*--check" /var/spool/cron/* | wc -l)" -eq 0 ]; then
    echo "$fail $var_1_3_2"
    echo "$rem_1_3_2" >> $remediation_filename
else
    echo "$pass $var_1_3_2"
fi

var_1_4="1.4 Cấu hình khởi động an toàn"
echo "$info $var_1_4"
############################################################################
rem_1_4_1=$(cat  <<  EOF 
================================================
1.4.1 Thực hiện các câu lệnh sau để đặt các quyền cho file cấu hình grub:
 chown root:root /boot/grub2/grub.cfg
  test -f /boot/grub2/user.cfg && chown root:root /boot/grub2/user.cfg
 chmod og-rwx /boot/grub2/grub.cfg
 test -f /boot/grub2/user.cfg && chmod og-rwx /boot/grub2/user.cfg
-----------------------------------------------
Tác động: Không tác động tới hệ thống.
EOF
)

var_1_4_1="1.4.1 Phân quyền đối với file cấu hình bootloader"
if [ $( stat /boot/grub2/grub.cfg 2>/dev/null | grep "0600.*Uid.*root.*Gid.*root" 2>/dev/null | wc -l) -eq 0 ]; then
	echo "$fail $var_1_4_1"
	echo "$rem_1_4_1" >>  $remediation_filename
else
	echo "$pass $var_1_4_1" 
fi

############################################################################
rem_1_4_2=$(cat  <<  EOF 
================================================
1.4.2 Tạo mật khẩu được mã hóa bằng grub2-setpassword:
#grub-mkpasswd-pbkdf2
#nano /etc/grub.d/01_users
#Thêm các câu lệnh sau vào cuối file 01-users
#cat <<EOF
#set superusers="<username>"
#password_pbkdf2 <username> <mật khẩu đã tạo ở trên>
#EOF
#username do người quản trị định nghĩa
#lưu lại file cấu hình
#update-grub
-----------------------------------------------
Tác động: Nếu bật tính năng bảo vệ bằng mật khẩu, chỉ người dùng có quyền được chỉ định mới có thể chỉnh sửa menu Grub 2 mục bằng cách nhấn "e" hoặc truy cập dòng lệnh GRUB 2 bằng cách nhấn "c" Nếu GRUB 2 được thiết lập để tự động khởi động vào mục menu được bảo vệ bằng mật khẩu thì người dùng có không có tùy chọn thoát khỏi lời nhắc mật khẩu để chọn mục menu khác. Giữ Phím SHIFT sẽ không hiển thị menu trong trường hợp này. Người dùng phải nhập đúng tên người dùng và mật khẩu. Nếu không thể, các tập tin cấu hình sẽ phải được chỉnh sửa qua LiveCD hoặc các phương tiện khác để khắc phục vấn đề. Có thể thêm --unrestricted vào các mục menu để cho phép hệ thống khởi động mà không cần nhập mật khẩu. Mật khẩu vẫn sẽ được yêu cầu để chỉnh sửa các mục menu.
EOF
)

var_1_4_2="1.4.2 Cấu hình mật khẩu cho bootloader"
#if [ "$( grep "set superusers" /boot/grub2/grub.cfg 2>/dev/null | awk -F'"' {'print $2'})" != 'root' ] || [ $( grep "^password" /boot/grub2/grub.cfg | wc -l) -eq 0 ] ; then
#	echo "$fail $var_1_4_2"
#	echo "$rem_1_4_2" >>  $remediation_filename
#else
	echo "$pass $var_1_4_2" 
#fi


############################################################################
rem_1_4_3=$(cat  <<  EOF 
================================================
1.4.3 Thực hiện câu lệnh sau:
Chỉnh sửa file /usr/lib/systemd/system/rescue.service và /usr/lib/systemd/system/emergency.service và đặt ExecStart để sử dụng /sbin/sulogin hoặc /usr/sbin/sulogin:
ExecStart=-/bin/sh -c "/sbin/sulogin; /usr/bin/systemctl --fail --no-block default"
Tùy chọn --fail và --job-mode=fail tương đồng với nhau. Sử dụng một trong hai cái đều được
-----------------------------------------------
Tác động: Không tác động tới hệ thống.
EOF
)

var_1_4_3="1.4.3 Cấu hình xác thực khi truy cập single user mode"
if ( [ "$(grep -r "/usr/lib/systemd/systemd-sulogin-shell.*rescue" /usr/lib/systemd/system/rescue.service | wc -l)" -eq 0 ] || [ "$(grep -r "/usr/lib/systemd/systemd-sulogin-shell.*emergency" /usr/lib/systemd/system/emergency.service | wc -l)" -eq 0 ] ) && ( [ "$(grep -E "/sbin/sulogin|/usr/sbin/sulogin" /usr/lib/systemd/system/rescue.service | wc -l)" -eq 0 ] || [ "$(grep -E "/sbin/sulogin|/usr/sbin/sulogin" /usr/lib/systemd/system/emergency.service | wc -l)" -eq 0 ] ); then
    echo "$fail $var_1_4_3"
	echo "$rem_1_4_3" >>  $remediation_filename
else
    echo "$pass $var_1_4_3"
fi

############################################################################
var_1_4_4="1.4.4 Cấu hình vô hiệu hoá interactive boot"
echo "$pass $var_1_4_4"

var_1_5="1.5 Additional Process Hardening"
echo "$info $var_1_5"

############################################################################
rem_1_5_1=$(cat  <<  EOF 
================================================
1.5.1 Thêm dòng sau vào file /etc/security/limits.conf hoặc file /etc/security/limits.d/*:
 * hard core 0
 Đặt các tham số sau và file /etc/sysctl.conf hoặc /etc/sysctl.d/*:
 fs.suid_dumpable = 0
 Thực hiện câu lệnh sau để đặt tham số vào kernel đang hoạt động:
 sysctl -w fs.suid_dumpable=0
 Nếu systemd-coredump được cài đặt, chỉnh sửa file /etc/systemd/coredump.conf và thêm/chỉnh sửa dòng sau:
 Storage=none
 ProcessSizeMax=0
-----------------------------------------------
Tác động: Không tác động tới hệ thống.
EOF
)

var_1_5_1="1.5.1 Cấu hình kiểm soát core dump"
if [ $(grep -P "^\h*\*\s+hard\s+core\s+0" /etc/security/limits.conf /etc/security/limits.d/*.conf 2>/dev/null | wc -l) -eq 0 ] || [ $(sysctl fs.suid_dumpable 2>/dev/null | grep 0 | wc -l) -eq 0 ] || [ $(grep "fs\.suid_dumpable.*=.*0" /etc/sysctl.conf /etc/sysctl.d/*.conf 2>/dev/null | wc -l) -eq 0 ] || [ $(grep -Ei '^\h*ProcessSizeMax\s*=\s*0' /etc/systemd/coredump.conf 2>/dev/null | wc -l) -eq 0 ] || [ $(grep -Ei '^\h*storage\s*=\s*none' /etc/systemd/coredump.conf 2>/dev/null | wc -l) -eq 0 ]; then
	echo "$fail $var_1_5_1"
	echo "$rem_1_5_1" >>  $remediation_filename
else
	echo "$pass $var_1_5_1"
fi

############################################################################
rem_1_5_2=$(cat  <<  EOF 
================================================
1.5.2 Đặt các tham số sau vào file /etc/sysctl.conf hoặc file /etc/sysctl.d/*:
 kernel.randomize_va_space = 2
 Thực hiện câu lệnh sau để đặt tham số vào kernel đang hoạt động:
 sysctl -w kernel.randomize_va_space=2
-----------------------------------------------
Tác động: AppArmor phải được kích hoạt khi khởi động trong cấu hình bootloader để đảm bảo rằng các điều khiển mà nó cung cấp không bị ghi đè.
EOF
)

var_1_5_2="1.5.2 Cấu hình kích hoạt ASLR (address space layout randomization)"
if [ $(sysctl kernel.randomize_va_space 2>/dev/null | grep 2 | wc -l) -eq 0 ] || [ $(grep -P "^\h*kernel.randomize_va_space.*=.*2" /etc/sysctl.conf /etc/sysctl.d/*.conf 2>/dev/null | wc -l) -eq 0 ]; then
	echo "$fail $var_1_5_2"
	echo "$rem_1_5_2" >>  $remediation_filename
else
	echo "$pass $var_1_5_2"
fi

############################################################################
rem_1_5_3=$(cat  <<  EOF 
================================================
1.5.3 Thực hiện câu lệnh sau để khôi phục binaries trở về bình thường:
 prelink -ua
 Gỡ cài đặt prelink sử dụng trình quản lý package phù hợp;
 yum remove prelink
-----------------------------------------------
Tác động: Không tác động tới hệ thống.
EOF
)

var_1_5_3="1.5.3 Cấu hình vô hiệu hóa prelink"
if [ $(rpm -qa prelink | wc -l) -ne 0 ]; then
	echo "$fail $var_1_5_3"
	echo "$rem_1_5_3" >>  $remediation_filename
else
	echo "$pass $var_1_5_3"
fi

var_1_6="1.6 Thông tin cảnh báo"
echo "$info $var_1_6"

############################################################################
rem_1_6_1=$(cat  <<  EOF 
================================================
1.6.1 Thực hiện các câu lệnh sau để đặt quyền cho file /etc/issue
 chown root:root $(readlink -e /etc/issue)
 chmod u-x,go-wx $(readlink -e /etc/issue)
-----------------------------------------------
Tác động: Không ảnh hưởng tới hệ thống.
EOF
)

var_1_6_1="1.6.1 Cấu hình phân quyền đối với file /etc/issue"
if [ $( stat /etc/issue 2>/dev/null | grep "0644.*Uid.*root.*Gid.*root" | wc -l) -eq 0 ]; then
	echo "$fail $var_1_6_1"
	echo "$rem_1_6_1" >>  $remediation_filename
else
	echo "$pass $var_1_6_1"
fi

############################################################################
rem_1_6_2=$(cat  <<  EOF 
================================================
1.6.2 Chỉnh sửa file /etc/motd với nội dung phù hợp dựa theo chính sách của tổ chức, loại bỏ các trường hợp \m, \r, \s, hoặc \v.
-----------------------------------------------
Tác động: 
EOF
)

var_1_6_2="1.6.2 Kiểm soát nội dung thông báo khi truy cập GNOME"
if [ $(grep -E -i "(\\\v|\\\r|\\\m|\\\s|$(grep '^ID=' /etc/os-release | cut -d= -f2 | sed -e 's/"//g'))" /etc/motd 2>/dev/null | wc -l) -ne 0 ]; then
	echo "$fail $var_1_6_2"
	echo "$rem_1_6_2" >>  $remediation_filename
else
	echo "$pass $var_1_6_2"
fi

var_2="2 Service"
var_2_1="2.1 inetd Service"
echo "$info $var_2"
echo "$info $var_2_1"

############################################################################
rem_2_1_1=$(cat  <<  EOF 
================================================
2.1.1 Thực hiện các câu lệnh sau để gỡ bỏ xinetd:
 yum remove xinetd
-----------------------------------------------
Tác động: Nếu muốn sử dụng các dịch vụ này phải cài đặt lại.
EOF
)

############################################################################
var_2_1_1="2.1.1 Cấu hình vô hiệu hoá xinetd"
if [ $( rpm -s xinetd 2> /dev/null | grep installed | wc -l) -ne 0 ]; then
	echo "$fail $var_2_1_1"
	echo "$rem_2_1_1" >>  $remediation_filename
else
	echo "$pass $var_2_1_1"
fi

var_2_2="2.2 Các Service với mục đích riêng biệt"
echo "$info $var_2_2"

############################################################################
rem_2_2_1=$(cat  <<  EOF 
================================================
2.2.1 Thực hiện các câu lệnh sau
Thêm và chỉnh sửa dòng server hoặc pool ở file /etc/chrony.conf sao cho phù hợp:
server <remote-server>
Thêm hoặc chỉnh sửa OPTIONS trong file /etc/sysconfig/chronyd để bao gồm ‘-u chrony’:
OPTIONS="-u chrony"
-----------------------------------------------
Tác động: Nếu sử dụng chrony, ntp hoặc systemd-timesyncd sẽ không hoạt động.
EOF
)

var_2_2_1="2.2.1 Cấu hình sử dụng chrony"
if [ $(grep -E "^(server|pool)" /etc/chrony.conf 2>/dev/null | wc -l ) -eq 0 ]; then
    echo "$fail $var_2_2_1"
    echo "$rem_2_2_1" >>  $remediation_filename
else
    echo "$pass $var_2_2_1"
fi

############################################################################
remember_2_2_2="false"
rem_2_2_2=$(cat  <<  EOF 
================================================
2.2.2 - 2.2.16 Thực hiện câu lệnh sau để gỡ bỏ X window, X window, Avahi, CUPS, DHCP,LDAP, NFS, RPC, DNS , FTP, HTTP, POP3, IMAP, Samba, HTTP Proxy,SNMP, NIS :
 yum remove xorg-x11-server*
 systemctl stop avahi-daemon.socket avahi-daemon.service
 yum remove avahi-autoipd avahi
 yum remove cups
 yum remove dhcp
 yum remove openldap-servers
 yum remove bind
 yum remove vsftpd
 yum remove httpd
 yum remove dovecot
 yum remove samba
 yum remove squid
 yum remove net-snmp
 Chỉnh sửa file /etc/postfix/main.cf và thêm vào dòng sau
 inet_interfaces = loopback-only
Chạy lệnh sau để restart postfix/main
 systemctl restart postfix
 yum remove ypserv
-----------------------------------------------
Tác động: vô hiệu hoá X Window: Nhiều hệ thống Linux chạy các ứng dụng yêu cầu môi trường chạy Java. Một số Linux Java sử dụng các gói có sự phụ thuộc vào các phông chữ X Windows xorg-x11 cụ thể. Một cách giải quyết tránh sự phụ thuộc này là sử dụng các gói Java "headless" cho môi trường chạy Java cụ thể.
Tác động vô hiệu hoá CUPS: Loại bỏ CUPS sẽ ngăn việc in khỏi hệ thống, đây là nhiệm vụ thường gặp của máy trạm hệ thống
EOF
)

var_2_2_2="2.2.2 Cấu hình vô hiệu hoá X window"
if [ $(rpm -qa xorg-x11* | wc -l) -ne 0 ]; then
    echo "$fail $var_2_2_2"
	remember_2_2_2="true"
else
    echo "$pass $var_2_2_2"
fi

var_2_2_3="2.2.3 Cấu hình vô hiệu hoá Avahi"
if [ $(rpm -q avahi-autoipd avahi | grep "not installed" |wc -l) -eq 0 ]; then
    echo "$fail $var_2_2_3"
	remember_2_2_2="true"
else
	echo "$pass $var_2_2_3"
fi

var_2_2_4="2.2.4 Cấu hình vô hiệu hoá CUPS"
if [ $(rpm -q cups | grep "not installed" |wc -l) -eq 0 ]; then
    echo "$fail $var_2_2_4"
	remember_2_2_2="true"
else
	echo "$pass $var_2_2_4"
 fi

var_2_2_5="2.2.5 Cấu hình vô hiệu hoá DHCP"
if [ $(rpm -q dhcp | grep "not installed" |wc -l) -eq 0  ]; then
	echo "$fail $var_2_2_5"
	remember_2_2_2="true"
else
	echo "$pass $var_2_2_5" 
fi

var_2_2_6="2.2.6 Cấu hình vô hiệu hoá LDAP"
if [ $(rpm -q  openldap-servers | grep "not installed" |wc -l) -eq 0  ]; then
	echo "$fail $var_2_2_6"
	remember_2_2_2="true"
else
	echo "$pass $var_2_2_6"
fi
var_2_2_7="2.2.7 Cấu hình vô hiệu hoá NFS và RPC"
echo "$pass $var_2_2_7"

var_2_2_8="2.2.8 Cấu hình vô hiệu hoá DNS"    
if [ $(rpm -q bind | grep "not installed" |wc -l) -eq 0  ]; then
	echo "$fail $var_2_2_8"
	remember_2_2_2="true"
else
	echo "$pass $var_2_2_8"  
fi

var_2_2_9="2.2.9 Cấu hình vô hiệu hoá FTP"
if [ $(rpm -q vsftpd | grep "not installed" |wc -l) -eq 0  ]; then
	echo "$fail $var_2_2_9"
	remember_2_2_2="true"
else
	echo "$pass $var_2_2_9"
fi

var_2_2_10="2.2.10 Cấu hình vô hiệu hoá HTTP"
if [ $(rpm -q httpd | grep "not installed" |wc -l) -eq 0  ]; then
	echo "$fail $var_2_2_10"
	remember_2_2_2="true"
else
	echo "$pass $var_2_2_10"
fi

var_2_2_11="2.2.11 Cấu hình vô hiệu hoá POP3 và IMAP"
if [ $(rpm -q dovecot | grep "not installed" |wc -l) -eq 0  ]; then
	echo "$fail $var_2_2_11"
	remember_2_2_2="true"
else
	echo "$pass $var_2_2_11"
fi

var_2_2_12="2.2.12 Cấu hình vô hiệu hoá Samba"
if [ $(rpm -q samba | grep "not installed" |wc -l) -eq 0  ]; then
	echo "$fail $var_2_2_12"
	remember_2_2_2="true"
else
	echo "$pass $var_2_2_12"
fi

var_2_2_13="2.2.13 Cấu hình vô hiệu HTTP Proxy"
if [ $(rpm -q squid | grep "not installed" |wc -l) -eq 0  ]; then
	echo "$fail $var_2_2_13"
	remember_2_2_2="true"
else
	echo "$pass $var_2_2_13"
fi

var_2_2_14="2.2.14 Cấu hình vô hiệu hoá SNMP"
if [ $(rpm -q net-snmp | grep "not installed" |wc -l) -eq 0  ]; then
	echo "$fail $var_2_2_14"
	remember_2_2_2="true"
else
	echo "$pass $var_2_2_14"
fi

var_2_2_15="2.2.15 Cấu hình MTA sang chế độ local-only"
if [ $(ss -lntu | grep -E ':25\s' | grep -E -v '\s(127.0.0.1|\[?::1\]?):25\s' |wc -l) -ne 0  ]; then
	echo "$fail $var_2_2_15"
	remember_2_2_2="true"
else
	echo "$pass $var_2_2_15"
fi
var_2_2_16="2.2.16 Cấu hình vô hiệu hoá NIS"
if [ $(rpm -q ypserv | grep "not installed" |wc -l) -eq 0  ]; then
	echo "$fail $var_2_2_16"
	remember_2_2_2="true"
else
	echo "$pass $var_2_2_16"
fi

if [ "$remember_2_2_2" == "true" ] ; then
    echo "$rem_2_2_2" >> $remediation_filename
fi


############################################################################
var_2_3="2.3 Service Clients"
echo "$info $var_2_3"
var_2_3_1="2.3.1 Cấu hình xoá bỏ NIS client"

remember_2_3_1="false"
rem_2_3_1=$(cat  <<  EOF 
================================================
2.3.1 Thực hiện câu lệnh sau để gỡ cài đặt NIS client, rsh client, talk client, telnet client, LDAP client:
yum remove ypbind
yum remove rsh
yum remove talk
yum remove telnet
yum remove openldap-clients
Tác động: Nhiều ứng dụng khách dịch vụ không an toàn được sử dụng làm công cụ khắc phục sự cố và thử nghiệm môi trường. Việc gỡ cài đặt chúng có thể hạn chế khả năng kiểm tra và khắc phục sự cố. Nếu chúng là cần thiết thì nên loại bỏ khách hàng sau khi sử dụng để tránh vô tình hoặc cố ý lạm dụng.
-----------------------------------------------
Tác động: Nhiều ứng dụng khách dịch vụ không an toàn được sử dụng làm công cụ khắc phục sự cố và thử nghiệm môi trường. Việc gỡ cài đặt chúng có thể hạn chế khả năng kiểm tra và khắc phục sự cố. Nếu chúng là cần thiết thì nên loại bỏ khách hàng sau khi sử dụng để tránh vô tình hoặc cố ý lạm dụng.
EOF
)

############################################################################
var_2_3_1="2.3.1 Cấu hình xoá bỏ NIS client"
if [ $(rpm -qa ypbind | wc -l) -ne 0 ]; then
    echo "$fail $var_2_3_1"
	remember_2_3_1="true"
else
    echo "$pass $var_2_3_1"
fi

var_2_3_2="2.3.2 Cấu hình xoá bỏ rsh client"
if [ $(rpm -qa rsh | wc -l) -ne 0 ]; then
    echo "$fail $var_2_3_2"
	remember_2_3_1="true"
else
	echo "$pass $var_2_3_2"  
fi

var_2_3_3="2.3.3 Cấu hình xoá bỏ hoá talk client"
if [ $(rpm -qa talk | wc -l) -ne 0 ]; then
    echo "$fail $var_2_3_3"
	remember_2_3_1="true"
else
	echo "$pass $var_2_3_3" 
fi

var_2_3_4="2.3.4 Cấu hình xoá bỏ telnet client"
if [ $(rpm -qa telnet | wc -l) -ne 0 ]; then
    echo "$fail $var_2_3_4"
	remember_2_3_1="true"
else
	echo "$pass $var_2_3_4"  
fi

var_2_3_5="2.3.5 Cấu hình xoá bỏ LDAP client"
if [ $(rpm -qa openldap-clients | wc -l) -ne 0 ]; then
    echo "$fail $var_2_3_5"
	remember_2_3_1="true"
else
	echo "$pass $var_2_3_5" 
fi

if [ "$remember_2_3_1" == "true" ] ; then
    echo "$rem_2_3_1" >> $remediation_filename
fi

############################################################################
var_3="3 Cấu hình mạng"
var_3_1="3.1 Tham số cấu hình mạng (host only)"
echo "$info $var_3"
echo "$info $var_3_1"

var_3_1_1="3.1.1 Cấu hình vô hiệu hoá IP forwarding"
rem_3_1_1=$(cat  <<  EOF 
================================================
3.1.1 Thực hiện đoạn script sau:
 grep -Els "^\s*net\.ipv4\.ip_forward\s*=\s*1" /etc/sysctl.conf /etc/sysctl.d/*.conf /usr/lib/sysctl.d/*.conf /run/sysctl.d/*.conf | while read filename; do sed -ri "s/^\s*(net\.ipv4\.ip_forward\s*)(=)(\s*\S+\b).*$/# *REMOVED* \1/" $filename; done; sysctl -w net.ipv4.ip_forward=0; sysctl -w net.ipv4.route.flush=1
 grep -Els "^\s*net\.ipv6\.conf\.all\.forwarding\s*=\s*1" /etc/sysctl.conf /etc/sysctl.d/*.conf /usr/lib/sysctl.d/*.conf /run/sysctl.d/*.conf | while read filename; do sed -ri "s/^\s*(net\.ipv6\.conf\.all\.forwarding\s*)(=)(\s*\S+\b).*$/# *REMOVED* \1/"
$filename; done; sysctl -w net.ipv6.conf.all.forwarding=0; sysctl -w net.ipv6.route.flush=1 
thực hiện thêm dòng net.ipv4.ip_forward=0 vào cuối file /etc/sysctl.conf
-----------------------------------------------
Tác động: Không ảnh hưởng tới hệ thống.
EOF
)

if [ $(sysctl net.ipv4.ip_forward | grep "0" | wc -l) -eq 0 ] || [ $(grep "net.ipv4.ip_forward.*0" /etc/sysctl.conf /etc/sysctl.d/* | wc -l) -eq 0 ]; then
    echo "$fail $var_3_1_1"
	echo "$rem_3_1_1" >>  $remediation_filename
else
	echo "$pass $var_3_1_1" 
fi

############################################################################
var_3_1_2="3.1.2 Cấu hình vô hiệu hoá tính năng chuyển hướng gói tin (packet redirect)"

rem_3_1_2=$(cat  <<  EOF 
================================================
3.1.2 Đặt các tham số sau vào file /etc/sysctl.conf hoặc /etc/sysctl.d/*
 net.ipv4.conf.all.send_redirects = 0
 net.ipv4.conf.default.send_redirects = 0
 Thực hiện các câu lệnh sau để đặt tham số vào kernel đang hoạt động:
 sysctl -w net.ipv4.conf.all.send_redirects=0
 sysctl -w net.ipv4.conf.default.send_redirects=0
 sysctl -w net.ipv4.route.flush=1
-----------------------------------------------
Tác động: Không ảnh hưởng tới hệ thống.
EOF
)
if [ $(sysctl net.ipv4.conf.all.send_redirects | grep "0" | wc -l) -eq 0 ] || [ $(sysctl net.ipv4.conf.default.send_redirects | grep "0" | wc -l) -eq 0 ] || [ $(grep "^net.ipv4.conf.all.send_redirects.*0" /etc/sysctl.conf /etc/sysctl.d/* | wc -l) -eq 0 ] || [ $(grep "^net.ipv4.conf.default.send_redirects.*0" /etc/sysctl.conf /etc/sysctl.d/* | wc -l) -eq 0 ]; then
    echo "$fail $var_3_1_2"
	echo "$rem_3_1_2" >>  $remediation_filename
else
	echo "$pass $var_3_1_2" 
fi

############################################################################
var_3_2="3.2 Tham số cấu hình mạng (host và router)"
echo "$info $var_3_2"

var_3_2_1="3.2.1 Cấu hình từ chối các gói tin với nguồn được định tuyến trước"
rem_3_2_1=$(cat  <<  EOF 
================================================
3.2.1 Đặt các thông số sau vào file /etc/sysctl.conf hoặc /etc/sysctl.d/*:
 net.ipv4.conf.all.accept_source_route = 0
 net.ipv4.conf.default.accept_source_route = 0
 net.ipv6.conf.all.accept_source_route = 0
 net.ipv6.conf.default.accept_source_route = 0
 Thực hiện các câu lệnh sau để đặt các tham số vào kernel đang hoạt động:
 sysctl -w net.ipv4.conf.all.accept_source_route=0
 sysctl -w net.ipv4.conf.default.accept_source_route=0
 sysctl -w net.ipv4.route.flush=1
-----------------------------------------------
Tác động: Không ảnh hưởng tới hệ thống.
EOF
)
if [ $( sysctl net.ipv4.conf.all.accept_source_route | grep net.ipv4.conf.all.accept.*0 | wc -l) -eq 0 ] || [ $( sysctl net.ipv4.conf.default.accept_source_route | grep net.ipv4.conf.default.accept.*0 | wc -l) -eq 0 ] || [ $( grep "^net.ipv4.conf.all.accept_source_route.*0" /etc/sysctl.conf /etc/sysctl.d/*  2> /dev/null | wc -l) -eq 0 ] || [ $( grep "^net.ipv4.conf.default.accept_source_route.*0" /etc/sysctl.conf /etc/sysctl.d/* 2> /dev/null | wc -l) -eq 0 ]; then
	echo "$fail $var_3_2_1"
	echo "$rem_3_2_1" >>  $remediation_filename
else
	echo "$pass $var_3_2_1"
fi

############################################################################
var_3_2_2="3.2.2 Cấu hình từ chối các ICMP redirect message"
rem_3_2_2=$(cat  <<  EOF 
================================================
3.2.2 Đặt các tham số sau và file /etc/sysctl.conf hoặc /etc/sysctl.d/*:
 net.ipv4.conf.all.accept_redirects = 0
 net.ipv4.conf.default.accept_redirects = 0
 net.ipv6.conf.all.accept_redirects = 0
 net.ipv6.conf.default.accept_redirects = 0
 Thực hiện các câu lệnh sau để đặt các tham số vào kernel đang hoạt động:
 sysctl -w net.ipv4.conf.all.accept_redirects=0
 sysctl -w net.ipv4.conf.default.accept_redirects=0
 sysctl -w net.ipv4.route.flush=1
-----------------------------------------------
Tác động: Không ảnh hưởng tới hệ thống.
EOF
)
if [ $( sysctl net.ipv4.conf.all.accept_redirects | grep net.ipv4.conf.all.accept_redirects.*0 | wc -l) -eq 0 ] || [ $( sysctl net.ipv4.conf.default.accept_redirects | grep net.ipv4.conf.default.accept_redirects.*0 | wc -l) -eq 0 ] || [ $( grep "^net.ipv4.conf.all.accept_redirects.*0" /etc/sysctl.conf /etc/sysctl.d/* 2> /dev/null | wc -l) -eq 0 ] || [ $( grep "^net.ipv4.conf.default.accept_redirects.*0" /etc/sysctl.conf /etc/sysctl.d/* 2> /dev/null | wc -l) -eq 0 ]; then
	echo "$fail $var_3_2_2"
	echo "$rem_3_2_2" >>  $remediation_filename
else
	echo "$pass $var_3_2_2" 
fi

############################################################################
rem_3_2_3=$(cat  <<  EOF 
================================================
3.2.3 Đặt các tham số sau vào file /etc/sysctl.conf hoặc /etc/sysctl.d/*:
 net.ipv4.conf.all.secure_redirects = 0
 net.ipv4.conf.default.secure_redirects = 0
 Thực hiện các câu lệnh sau để đặt các tham số vào kernel đang hoạt động:
 sysctl -w net.ipv4.conf.all.secure_redirects=0
 sysctl -w net.ipv4.conf.default.secure_redirects=0
 sysctl -w net.ipv4.route.flush=1
-----------------------------------------------
Tác động: Không ảnh hưởng tới hệ thống.
EOF
)

var_3_2_3="3.2.3 Cấu hình từ chối các secure ICMP redirect message"
if [ $( sysctl net.ipv4.conf.all.secure_redirects | grep net.ipv4.conf.all.secure_redirects.*0 | wc -l) -eq 0 ] || [ $( sysctl net.ipv4.conf.default.secure_redirects | grep net.ipv4.conf.default.secure_redirects.*0 | wc -l) -eq 0 ] || [ $( grep "^net.ipv4.conf.all.secure_redirects.*0" /etc/sysctl.conf /etc/sysctl.d/* 2> /dev/null | wc -l) -eq 0 ] || [ $( grep "^net.ipv4.conf.default.secure_redirects.*0" /etc/sysctl.conf /etc/sysctl.d/* 2> /dev/null | wc -l) -eq 0 ]; then
	echo "$fail $var_3_2_3"
	echo "$rem_3_2_3" >>  $remediation_filename
else
	echo "$pass $var_3_2_3" 
fi

############################################################################
rem_3_2_4=$(cat  <<  EOF 
================================================
3.2.4  Đặt các tham số sau và file /etc/sysctl.conf hoặc file /etc/sysctl.d/*:
 net.ipv4.conf.all.log_martians = 1
 net.ipv4.conf.default.log_martians = 1
 Thực hiện các câu lệnh sau để đặt các tham số vào kernel đang hoạt động:
 sysctl -w net.ipv4.conf.all.log_martians=1
 sysctl -w net.ipv4.conf.default.log_martians=1
-----------------------------------------------
Tác động: Không ảnh hưởng tới hệ thống.
EOF
)

var_3_2_4="3.2.4 Cấu hình ghi lại các gói tin khả nghi (Suspicious Packets)"
if [ "$(sysctl net.ipv4.conf.all.log_martians | grep 1 | wc -l)" -eq 0 ]||[ "$(sysctl net.ipv4.conf.default.log_martians | grep 1 | wc -l)" -eq 0 ]||[ "$(grep "net.ipv4.conf.all.log_martians.*1" /etc/sysctl.conf /etc/sysctl.d/* | wc -l)" -eq 0 ]||[ "$(grep "^net.ipv4.conf.default.log_martians.*1" /etc/sysctl.conf /etc/sysctl.d/* | wc -l)" -eq 0 ]; then
	echo "$fail $var_3_2_4"
	echo "$rem_3_2_4" >>  $remediation_filename
else
	echo "$pass $var_3_2_4"
fi

############################################################################
rem_3_2_5=$(cat  <<  EOF 
================================================
3.2.5 Đặt tham số sau vào file /etc/sysctl.conf hoặc /etc/sysctl.d/*:
 net.ipv4.icmp_echo_ignore_broadcasts = 1
 Thực hiện các câu lệnh sau để đặt tham số vào kernel đang hoạt động:
 sysctl -w net.ipv4.icmp_echo_ignore_broadcasts=1
-----------------------------------------------
Tác động: Không ảnh hưởng tới hệ thống.
EOF
)

var_3_2_5="3.2.5 Cấu hình từ chối các gói tin ICMP request broadcast"
if [ $( sysctl net.ipv4.icmp_echo_ignore_broadcasts | grep net.ipv4.icmp_echo_ignore_broadcasts.*1 | wc -l) -eq 0 ] || [ $( grep "^net.ipv4.icmp_echo_ignore_broadcasts.*1" /etc/sysctl.conf /etc/sysctl.d/* 2> /dev/null | wc -l) -eq 0 ]; then
	echo "$fail $var_3_2_5"
	echo "$rem_3_2_5" >>  $remediation_filename
else
	echo "$pass $var_3_2_5" 
fi

############################################################################
rem_3_2_6=$(cat  <<  EOF 
================================================
3.2.6 Đặt tham số sau vào file /etc/sysctl.conf hoặc /etc/sysctl.d/*:
 net.ipv4.icmp_ignore_bogus_error_responses = 1
 Thực hiện các câu lệnh sau để đặt tham số vào kernel đang hoạt động:
 sysctl -w net.ipv4.icmp_ignore_bogus_error_responses=1
-----------------------------------------------
Tác động: Không ảnh hưởng tới hệ thống.
EOF
)

var_3_2_6="3.2.6 Cấu hình bỏ quan phản hồi ICMP không hợp lệ"
if [ $( sysctl net.ipv4.icmp_ignore_bogus_error_responses | grep net.ipv4.icmp_ignore.*1 | wc -l) -eq 0 ] || [ $( grep "^net.ipv4.icmp_ignore_bogus_error_responses.*1" /etc/sysctl.conf /etc/sysctl.d/* 2> /dev/null | wc -l) -eq 0 ]; then
	echo "$fail $var_3_2_6"
	echo "$rem_3_2_6" >>  $remediation_filename
else
	echo "$pass $var_3_2_6"  
fi

############################################################################
rem_3_2_7=$(cat  <<  EOF 
================================================
3.2.7 Đặt các tham số sau vào file /etc/sysctl.conf hoặc /etc/sysctl.d/*:
 net.ipv4.conf.all.rp_filter = 1
 net.ipv4.conf.default.rp_filter = 1
 Thực hiện các câu lệnh sau để đặt các tham số vào kernel đang hoạt động:
 sysctl -w net.ipv4.conf.all.rp_filter=1
 sysctl -w net.ipv4.conf.default.rp_filter=1
-----------------------------------------------
Tác động: Không ảnh hưởng tới hệ thống.
EOF
)

var_3_2_7="3.2.7 Cấu hình Reverse Path Filtering"
if [ $( sysctl net.ipv4.conf.all.rp_filter | grep net.ipv4.conf.all.rp_filter.*1 | wc -l) -eq 0 ] || [ $( sysctl net.ipv4.conf.default.rp_filter | grep net.ipv4.conf.default.rp_filter.*1 | wc -l) -eq 0 ] || [ $( grep net.ipv4.conf.all.rp_filter.*1 /etc/sysctl.conf /etc/sysctl.d/* 2> /dev/null | wc -l) -eq 0 ] || [ $( grep net.ipv4.conf.default.rp_filter.*1 /etc/sysctl.conf /etc/sysctl.d/* 2> /dev/null | wc -l) -eq 0 ]; then
	echo "$fail $var_3_2_7"
	echo "$rem_3_2_7" >>  $remediation_filename
else
	echo "$pass $var_3_2_7" 
fi

############################################################################
rem_3_2_8=$(cat  <<  EOF 
================================================
3.2.8 Đặt tham số sau và file /etc/sysctl.conf hoặc /etc/sysctl.d/*:
 net.ipv4.tcp_syncookies = 1
 Thực hiện các câu lệnh sau để đặt các tham số vào kernel đang hoạt động:
 sysctl -w net.ipv4.tcp_syncookies=1
-----------------------------------------------
Tác động: Không ảnh hưởng tới hệ thống.
EOF
)

var_3_2_8="3.2.8 Cấu hình TCP SYN Cookies"
if [ $( sysctl net.ipv4.tcp_syncookies | grep net.ipv4.tcp_syncookies.*1 | wc -l) -eq 0 ] || [ $( grep "^net.ipv4.tcp_syncookies.*1" /etc/sysctl.conf /etc/sysctl.d/* 2> /dev/null | wc -l) -eq 0 ]; then
	echo "$fail $var_3_2_8"
	echo "$rem_3_2_8" >>  $remediation_filename
else
	echo "$pass $var_3_2_8"
fi

############################################################################
var_3_3="3.3 TCP Wrappers"
echo "$info $var_3_3"
var_3_3_1="3.3.1 Cài đặt TCP Wrappers"
var_3_3_2="3.3.2 Cấu hình file /etc/host.allow"
var_3_3_3="3.3.3 Cấu hình file /etc/hosts.deny"
echo "$pass $var_3_3_1"
echo "$pass $var_3_3_2"
echo "$pass $var_3_3_3"

$(cat COMM << EOF 2>/dev/null
############################################################################
# Thực hiện câu lệnh sau để tạo file /etc/hosts.allow:
# echo "ALL: <net>/<mask>, <net>/<mask>, ..." >/etc/hosts.allow

if [ $(grep -E "^ALL:(\s)?192|^ALL:(\s)?172|^ALL:(\s)?10|^ALL:(\s)?170|^ALL:(\s)?ALL" /etc/hosts.allow | wc -l) -eq 0 ]; then
    echo "{\"3.3.2. Cấu hình file /etc/host.allow\" : \"FAILED\"}"
else
    echo "{\"3.3.2. Cấu hình file /etc/host.allow\" : \"PASSED\"}"
fi

############################################################################
# Thực hiện câu lệnh sau để tạo file /etc/hosts.deny:
# echo "ALL: ALL" >> /etc/hosts.deny

if [ "$(grep -E "^ALL:(\s)?192|^ALL:(\s)?172|^ALL:(\s)?10|^ALL:(\s)?170|^ALL:(\s)?ALL" /etc/hosts.deny | wc -l)" -eq 0 ]; then
    echo "{\"3.3.3. Cấu hình file /etc/hosts.deny\" : \"FAILED\"}"
else
    echo "{\"3.3.3. Cấu hình file /etc/hosts.deny\" : \"PASSED\"}"
fi
-----------------------------------------------
Tác động: 
EOF
)

############################################################################
rem_3_3_4=$(cat  <<  EOF 
================================================
3.2.4 Thực hiện các câu lệnh sau để đặt các quyền ở file /etc/hosts.allow:
 chown root:root /etc/hosts.allow
 chmod 644 /etc/hosts.allow
-----------------------------------------------
Tác động: Không ảnh hưởng tới hệ thống.
EOF
)

var_3_3_4="3.3.4 Cấu hình quyền truy cập /etc/hosts.allow"
if [ "$(stat /etc/hosts.allow | grep '0644.*Uid.*0.*root.*Gid.*0.*root' | wc -l)" -eq 0 ]; then
	echo "$fail $var_3_3_4"
	echo "$rem_3_3_4" >>  $remediation_filename
else
	echo "$pass $var_3_3_4"
fi

############################################################################
rem_3_3_5=$(cat  <<  EOF 
================================================
3.2.5 Thực hiện các câu lệnh sau để đặt các quyền ở file /etc/hosts.deny:
 chown root:root /etc/hosts.deny
 chmod 644 /etc/hosts.deny
-----------------------------------------------
Tác động: Không ảnh hưởng tới hệ thống.
EOF
)

var_3_3_5="3.3.5 Cấu hình quyền truy cập /etc/hosts.deny"
if [ "$(stat /etc/hosts.deny 2> /dev/null | grep '0644.*Uid.*0.*root.*Gid.*0.*root' | wc -l)" -eq 0 ]; then
	echo "$fail $var_3_3_5"
	echo "$rem_3_3_5" >>  $remediation_filename
else
	echo "$pass $var_3_3_5"
fi

############################################################################
var_3_4="3.4 Iptables"
echo "$info $var_3_4"

var_3_4_1="3.4.1 Bật Iptables"
rem_3_4_1=$(cat  <<  EOF 
================================================
3.4.1 Thực hiện câu lệnh sau để cài đặt iptables:
yum install iptables
-----------------------------------------------
Tác động: Không ảnh hưởng tới hệ thống.
EOF
)

if [ $(rpm -qa iptables | wc -l) -eq 0 ]; then
    echo "$fail $var_3_4_1"
	echo "$rem_3_4_1" >>  $remediation_filename
else
	echo "$pass $var_3_4_1"  
fi

############################################################################
rem_3_4_2=$(cat  <<  EOF 
================================================
3.4.2 
 Thực hiện các câu lệnh sau để cấu hình traffic cho ssh:
# iptables -A INPUT -p tcp --dport 22 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
# iptables -A OUTPUT -p tcp --sport 22 -m state --state ESTABLISHED -j ACCEPT
Thực hiện các câu lệnh sau để cài đặt chính sách mặc định là DROP:
 iptables -P INPUT DROP
 iptables -P OUTPUT DROP
 iptables -P FORWARD DROP
-----------------------------------------------
Tác động: Quá trình này có thể ngắt kết nối qua mạng, phải thiết lập kết nối trên các cổng trước khi thiết lập các rule trên.
EOF
)

var_3_4_2="3.4.2 Cấu hình chính sách từ chối mặc định trên firewall"
if [ $(iptables -L 2> /dev/null | grep "INPUT.*DROP" | wc -l) -eq 0 ] || [ $(iptables -L | grep "FORWARD.*DROP" | wc -l) -eq 0 ] || [ $(iptables -L | grep "OUTPUT.*DROP" | wc -l) -eq 0 ]; then
	echo "$fail $var_3_4_2"
	echo "$rem_3_4_2" >>  $remediation_filename
else
	echo "$pass $var_3_4_2"
fi

############################################################################
rem_3_4_3=$(cat  <<  EOF 
================================================
3.4.3 Thực hiện các câu lệnh sau để cài đặt các luật cho đường truyền loopback:
 iptables -A INPUT -i lo -j ACCEPT
 iptables -A OUTPUT -o lo -j ACCEPT
 iptables -A INPUT -s 127.0.0.0/8 -j DROP
-----------------------------------------------
Tác động: Không tác động tới hệ thống.
EOF
)

var_3_4_3="3.4.3 Cấu hình loopback traffic"
if [ $(iptables -L INPUT -v -n | grep "ACCEPT.*lo" | wc -l) -eq 0 ] || [ $(iptables -L INPUT -v -n | grep "DROP.*127\.0\.0\.0/8" | wc -l) -eq 0 ] || [ $(iptables -L OUTPUT -v -n | grep "ACCEPT.*lo" | wc -l) -eq 0 ]; then
	echo "$fail $var_3_4_3"
	echo "$rem_3_4_3" >>  $remediation_filename
else
	echo "$pass $var_3_4_3"
fi

############################################################################
rem_3_4_4=$(cat  <<  EOF 
================================================
3.4.4 Với mỗi cổng được xác định ở bước kiểm tra mà không có luật tường lửa nào, thiết lập luật phù hợp để chấp nhận kết nối đến:
	yum install net-tools -y
 iptables -A INPUT -p --dport -m state --state NEW -j ACCEPT
-----------------------------------------------
Tác động: Nếu không cấu hình chính sách từ chối đã cấu hình ở mục 3.4.2 sẽ tự động từ chối tất cả các gói tin tới.
EOF
)

var_3_4_4="3.4.4 Cấu hình rule cho tất cả các port đang mở"
if [ $(netstat -ln 2>/dev/null | grep "tcp.*0:22" | wc -l) -eq 0 ] || [ $(iptables -L INPUT -v -n | grep -E ".*ACCEPT.*all.*--.*lo.*0\.0\.0.\0/0.*0\.0\.0\.0/0" | wc -l) -eq 0 ] || [ $(iptables -L INPUT -v -n | grep -E ".*DROP.*all.*--.*127\.0\.0.\0/8.*0\.0\.0\.0/0" | wc -l) -eq 0 ]; then
	echo "$fail $var_3_4_4"
	echo "$rem_3_4_4" >>  $remediation_filename
else
	echo "$pass $var_3_4_4"
fi

############################################################################
var_4="4 Logging và Auditing"
var_4_1="4.1 Cấu hình logging"
var_4_1_1=" 4.1.1 Cấu hình rsyslog"
echo "$info $var_4"
echo "$info $var_4_1"
echo "$info $var_4_1_1"

var_4_1_1_1="4.1.1.1 Cấu hình kích hoạt rsyslog service"
rem_4_1_1_1=$(cat  <<  EOF 
================================================
4.1.1.1 Thực hiện câu lệnh sau để kích hoạt rsyslog:
 systemctl --now enable rsyslog
-----------------------------------------------
Tác động: Không tác động tới hệ thống.
EOF
)
if [ $( systemctl is-enabled rsyslog 2> /dev/null | grep enabled | wc -l) -eq 0 ]; then
	echo "$fail $var_4_1_1_1"
	echo "$rem_4_1_1_1" >>  $remediation_filename
else
	echo "$pass $var_4_1_1_1"  
fi

############################################################################
rem_4_1_1_2=$(cat  <<  EOF 
================================================
4.1.1.2 Chỉnh sửa file /etc/rsyslog.conf và /etc/rsyslog.d/*.conf và đặt:
 $FileCreateMode là 0640 hoặc nghiêm ngặt hơn:
 Đảm bảo cấu hình này không bị viết đè bởi các thiết lập kém nghiêm ngặt hơn ở bất kỳ file conf nào trong /etc/rsyslog.d/*.
-----------------------------------------------
Tác động: Không tác động tới hệ thống.
EOF
)

var_4_1_1_2="4.1.1.2 Phân quyền đối với file log sinh ra từ rsyslog"
if [ $(grep "^\$FileCreateMode 0640" /etc/rsyslog.conf  /etc/rsyslog.d/*.conf 2> /dev/null | wc -l) -eq 0 ]; then
	echo "$fail $var_4_1_1_2"
	echo "$rem_4_1_1_2" >>  $remediation_filename
else
	echo "$pass $var_4_1_1_2"
fi

############################################################################
rem_4_1_1_3=$(cat  <<  EOF 
================================================
4.1.1.3 Chỉnh sửa file /etc/rsyslog.conf và /etc/rsyslog.d/*.conf và thêm một trong các dòng sau:
 format cũ : *.* @@<FQDN or ip of loghost>
 for file in /etc/rsyslog.d/*; do echo "*.* @@ <FQDN or ip of loghost>" >> "$file"; done
 Thực hiện câu lệnh sau để reload cấu hình của rsyslog:
 systemctl reload rsyslog
-----------------------------------------------
Tác động: Nếu không cấu hình log sẽ không được gửi đến máy chủ tập trung.
EOF
)

var_4_1_1_3="4.1.1.3 Cấu hình lưu trữ log tập trung"
if [ $(  grep "^*.*[^I][^I]*@" /etc/rsyslog.conf /etc/rsyslog.d/*.conf 2> /dev/null | wc -l) -eq 0 ]; then
	echo "$fail $var_4_1_1_3"
	echo "$rem_4_1_1_3" >>  $remediation_filename
else
	echo "$pass $var_4_1_1_3"
fi

############################################################################
var_4_1_2=" 4.1.2 Cấu hình syslog-ng"
echo "$info $var_4_1_2"
var_4_1_2_1="4.1.2.1 Cấu hình kích hoạt syslog-ng service"
var_4_1_2_2="4.1.2.2 Phân quyền đối với file log sinh ra từ syslog-ng"
var_4_1_2_3="4.1.2.3 Cấu hình lưu trữ log tập trung"
echo "$pass $var_4_1_2_1"
echo "$pass $var_4_1_2_2"
echo "$pass $var_4_1_2_3"

############################################################################
var_4_1_3="4.1.3 Đảm bảo rsyslog hoặc syslog-ng được cài đặt"
rem_4_1_3=$(cat  <<  EOF 
================================================
4.1.3 Cài đặt rsyslog hoặc syslog-ng sử dụng một trong những câu lệnh sau:
  apt install rsyslog
-----------------------------------------------
Tác động: Không tác động tới hệ thống.
EOF
)

if [ $(rpm -qa rsyslog 2>/dev/null | wc -l) -eq 0 ]; then
    echo "$fail $var_4_1_3"
	echo "$rem_4_1_3" >>  $remediation_filename
else
	echo "$pass $var_4_1_3"
fi

############################################################################
var_4_1_4="4.1.4 Phân quyền đối với tất cả các file log"
rem_4_1_4=$(cat  <<  EOF 
================================================
4.1.4 Thực hiện câu lệnh sau để đặt quyền cho toàn bộ file log:
 find /var/log -type f -exec chmod g-wx,o-rwx {} +
-----------------------------------------------
Tác động: Không tác động tới hệ thống.
EOF
)
if [ $(find /var/log -type f -perm /g+wx,o+rwx -ls 2> /dev/null | wc -l) -gt 0 ]; then
	echo "$fail $var_4_1_4"
	echo "$rem_4_1_4" >>  $remediation_filename
else
	echo "$pass $var_4_1_4"
fi

############################################################################
var_5="5 Cấu hình truy cập, xác thực và ủy quyền"
var_5_1="5.1 Cấu hình cron"
echo "$info $var_5"
echo "$info $var_5_1"
var_5_1_1="5.1.1 Cấu hình kích hoạt cron daemon"
rem_5_1_1=$(cat  <<  EOF 
================================================
5.1.1 Thực hiện câu lệnh sau để kích hoạt cron:
 systemctl --now enable crond
-----------------------------------------------
Tác động: Nếu cron được kích hoạt phải tắt các dịch vụ tương tự khách như systemd timers
EOF
)

if [ $(systemctl is-enabled crond | grep "enabled" | wc -l) -eq 0 ]; then
    echo "$fail $var_5_1_1"
	echo "$rem_5_1_1" >>  $remediation_filename
else
	echo "$pass $var_5_1_1"
fi

############################################################################
var_5_1_2="5.1.2 Cấu hình phân quyền cho file /etc/crontab"
rem_5_1_2=$(cat  <<  EOF 
================================================
5.1.2 Thực hiện các câu lệnh sau để đảm bảo rằng để đặt chủ sở hữu và quyền cho file /etc/crontab:
 chown root:root /etc/crontab
 chmod og-rwx /etc/crontab
-----------------------------------------------
Tác động: Không tác động tới hệ thống.
EOF
)
if [ $( stat /etc/crontab 2> /dev/null | grep "0600.*Uid.*root.*Gid.*root" | wc -l) -eq 0 ]; then
	echo "$fail $var_5_1_2"
	echo "$rem_5_1_2" >>  $remediation_filename
else
	echo "$pass $var_5_1_2"
fi

############################################################################
rem_5_1_3=$(cat  <<  EOF 
================================================
5.1.3 Thực hiện các câu lệnh sau để đặt chủ sở hữu và quyền cho file /etc/cron_hourly:
 chown root:root /etc/cron.hourly/
 chmod og-rwx /etc/cron.hourly/
-----------------------------------------------
Tác động: Không tác động tới hệ thống.
EOF
)

var_5_1_3="5.1.3 Cấu hình phân quyền cho file /etc/cron.hourly"
if [ $( stat /etc/cron.hourly 2> /dev/null | grep "0700.*Uid.*root.*Gid.*root" | wc -l) -eq 0 ]; then
	echo "$fail $var_5_1_3"
	echo "$rem_5_1_3" >>  $remediation_filename
else
	echo "$pass $var_5_1_3"
fi

############################################################################
rem_5_1_4=$(cat  <<  EOF 
================================================
5.1.4 Thực hiện các câu lệnh sau và đặt chủ sở hữu và quyền cho file /etc/cron_daily:
 chown root:root /etc/cron.daily
 chmod og-rwx /etc/cron.daily
-----------------------------------------------
Tác động: Không tác động tới hệ thống.
EOF
)

var_5_1_4="5.1.4 Cấu hình phân quyền cho file /etc/cron.daily"
if [ $( stat /etc/cron.daily 2> /dev/null | grep "0700.*Uid.*root.*Gid.*root" | wc -l) -eq 0 ]; then
	echo "$fail $var_5_1_4"
	echo "$rem_5_1_4" >>  $remediation_filename
else
	echo "$pass $var_5_1_4" 
fi

############################################################################
rem_5_1_5=$(cat  <<  EOF 
================================================
5.1.5 Thực hiện các câu lệnh sau để đặt chủ sở hữu và quyền cho file /etc/cron_weekly:
 chown root:root /etc/cron.weekly
 chmod og-rwx /etc/cron.weekly
-----------------------------------------------
Tác động: Không tác động tới hệ thống.
EOF
)

var_5_1_5="5.1.5 Cấu hình quyền cho file /etc/cron.weekly"
if [ $( stat /etc/cron.weekly 2> /dev/null | grep "0700.*Uid.*root.*Gid.*root" | wc -l) -eq 0 ]; then
	echo "$fail $var_5_1_5"
	echo "$rem_5_1_5" >>  $remediation_filename
else
	echo "$pass $var_5_1_5"   
fi

############################################################################
rem_5_1_6=$(cat  <<  EOF 
================================================
5.1.6 Thực hiện các câu lệnh sau để đặt chủ sở hữu và quyền cho file /etc/cron.monthly:
 chown root:root /etc/cron.monthly
 chmod og-rwx /etc/cron.monthly
-----------------------------------------------
Tác động: Không tác động tới hệ thống.
EOF
)

var_5_1_6="5.1.6 Cấu hình quyền cho của file /etc/cron.monthly"
if [ $( stat /etc/cron.monthly 2> /dev/null | grep "0700.*Uid.*root.*Gid.*root" | wc -l) -eq 0 ]; then
	echo "$fail $var_5_1_6"
	echo "$rem_5_1_6" >>  $remediation_filename
else
	echo "$pass $var_5_1_6"   
fi

############################################################################
rem_5_1_7=$(cat  <<  EOF 
================================================
5.1.7 Thực hiện câu lệnh sau để đặt chủ sở hữu và quyền cho file /etc/cron.d:
 chown root:root /etc/cron.d
 chmod og-rwx /etc/cron.d
-----------------------------------------------
Tác động: Không tác động tới hệ thống.
EOF
)

var_5_1_7="5.1.7 Cấu hình quyền cho file /etc/cron.d"
if [ $( stat /etc/cron.d 2> /dev/null | grep "0700.*Uid.*root.*Gid.*root" | wc -l) -eq 0 ]; then
	echo "$fail $var_5_1_7"
	echo "$rem_5_1_7" >>  $remediation_filename
else
	echo "$pass $var_5_1_7" 
fi

############################################################################
var_5_1_8="5.1.8 Cấu hình at/cron hạn chế chỉ cho người dùng được ủy quyền"
rem_5_1_8=$(cat  <<  EOF 
================================================
5.1.8 Thực hiện các câu lệnh sau:
 rm /etc/cron.deny
 touch /etc/cron.allow
 chmod 640 /etc/cron.allow
 chown root:root /etc/cron.allow
-----------------------------------------------
Tác động: Không tác động tới hệ thống.
EOF
)
if [ $(stat /etc/cron.allow 2> /dev/null | grep "0640.*Uid.*root.*Gid.*root" | wc -l) -eq 0 ] || [ $(stat /etc/cron.deny 2>/dev/null | wc -l) -ne 0 ];then
	if [ $(stat /etc/at.allow 2> /dev/null | grep "0640.*Uid.*root.*Gid.*root" | wc -l) -eq 0 ] || [ $(stat /etc/at.deny 2>/dev/null | wc -l) -ne 0 ]; then
        echo "$fail $var_5_1_8"	
        echo "$rem_5_1_8" >>  $remediation_filename
    else
	    echo "$pass $var_5_1_8"
	fi 
else
	echo "$pass $var_5_1_8"
fi

############################################################################
var_5_2="5.2 Cấu hình máy chủ SSH"
echo "$info $var_5_2"

############################################################################
rem_5_2_1=$(cat  <<  EOF 
================================================
5.2.1 Thực hiện các câu lệnh sau để đặt chủ sở hữu và quyền cho file /etc/ssh/sshd_config:
 chown root:root /etc/ssh/sshd_config
 chmod og-rwx /etc/ssh/sshd_config
-----------------------------------------------
Tác động: Không tác động tới hệ thống.
EOF
)

var_5_2_1="5.2.1 Cấu hình quyền cho file /etc/ssh/sshd_config"
if [ $( stat /etc/ssh/sshd_config 2> /dev/null | grep "0600.*Uid.*root.*Gid.*root" | wc -l) -eq 0 ]; then
	echo "$fail $var_5_2_1"
	echo "$rem_5_2_1" >>  $remediation_filename
else
	echo "$pass $var_5_2_1"
fi

############################################################################
rem_5_2_2=$(cat  <<  EOF 
================================================
5.2.2 Chỉnh sửa file /etc/ssh/sshd_config và thêm tham số như sau:
 LogLevel INFO
 Hoặc
 LogLevel VERBOSE
-----------------------------------------------
Tác động: Không tác động tới hệ thống.
EOF
)

var_5_2_2="5.2.2 Cấu hình LogLevel cho máy chủ SSH"
if [ $(grep -E "^LogLevel.*INFO" /etc/ssh/sshd_config 2> /dev/null | wc -l) -eq 0 ] && [ $(grep -E "^LogLevel.*VERBOSE" /etc/ssh/sshd_config 2> /dev/null | wc -l) -eq 0 ]; then
	echo "$fail $var_5_2_2"
	echo "$rem_5_2_2" >>  $remediation_filename
else
	echo "$pass $var_5_2_2"
fi

############################################################################
rem_5_2_3=$(cat  <<  EOF 
================================================
5.2.3 Chỉnh sửa file /etc/ssh/sshd_config và đặt tham số như sau:
 X11Forwarding no
Các chương trình X11 trên máy chủ sẽ không thể được chuyển tiếp tới màn hình ssh-client.
-----------------------------------------------
Tác động: Các chương trình X11 trên máy chủ sẽ không thể được chuyển tiếp tới màn hình ssh-client.
EOF
)

var_5_2_3="5.2.3 Cấu hình vô hiệu hóa X11 Forwarding cho máy chủ SSH"
if [ $(grep "^X11Forwarding.*no" /etc/ssh/sshd_config 2> /dev/null | wc -l) -eq 0 ]; then
	echo "$fail $var_5_2_3"
	echo "$rem_5_2_3" >>  $remediation_filename
else
	echo "$pass $var_5_2_3"
fi

############################################################################
rem_5_2_4=$(cat  <<  EOF 
================================================
5.2.4 Chỉnh sửa file /etc/ssh/sshd_config và đặt tham số như sau:
 MaxAuthTries 4
-----------------------------------------------
Tác động: Kẻ xấu có thể lợi dụng điều này gây nên một cuộc tấn công từ chối dịch vụ bằng các thử sai nhiều lần.
EOF
)

var_5_2_4="5.2.4 Cấu hình MaxAuthTries cho máy chủ SSH"
if [ $(grep "^MaxAuthTries.*4" /etc/ssh/sshd_config 2> /dev/null | wc -l) -eq 0 ]; then
	echo "$fail $var_5_2_4"
	echo "$rem_5_2_4" >>  $remediation_filename
else
	echo "$pass $var_5_2_4"
fi

############################################################################
rem_5_2_5=$(cat  <<  EOF 
================================================
5.2.5 Chỉnh sửa file /etc/ssh/sshd_config và đặt tham số như sau:
 IgnoreRhosts yes
-----------------------------------------------
Tác động: Người dùng bắt buộc phải nhập mật khẩu khi xác thực với ssh.
EOF
)

var_5_2_5="5.2.5 Cấu hình vô hiệu hóa IgnoreRhosts cho máy chủ SSH"
if [ $(grep "^IgnoreRhosts.*yes" /etc/ssh/sshd_config 2> /dev/null | wc -l) -eq 0 ]; then
	echo "$fail $var_5_2_5"
	echo "$rem_5_2_5" >>  $remediation_filename
else
	echo "$pass $var_5_2_5"
fi

############################################################################
rem_5_2_6=$(cat  <<  EOF 
================================================
5.2.6 Chỉnh sửa file /etc/ssh/sshd_config và đặt tham số như sau:
 HostbasedAuthentication no
-----------------------------------------------
Tác động: Không tác động tới hệ thống.
EOF
)

var_5_2_6="5.2.6 Cấu hình vô hiệu hóa HostbasedAuthentication cho máy chủ SSH"
if [ $(grep "^HostbasedAuthentication.*no" /etc/ssh/sshd_config 2> /dev/null | wc -l) -eq 0 ]; then
	echo "$fail $var_5_2_6"
	echo "$rem_5_2_6" >>  $remediation_filename
else
	echo "$pass $var_5_2_6"
fi

############################################################################
rem_5_2_7=$(cat  <<  EOF 
================================================
5.2.7 Chỉnh sửa file /etc/ssh/sshd_config và đặt tham số như sau:
PermitRootLogin no
-----------------------------------------------
Tác động: Không thể đăng nhập bằng tài khoản root.
EOF
)

var_5_2_7="5.2.7 Cấu hình vô hiệu hóa đăng nhập bằng root cho máy chủ SSH"
if [ $(grep "^PermitRootLogin.*no" /etc/ssh/sshd_config 2> /dev/null | wc -l) -eq 0 ]; then
	echo "$fail $var_5_2_7"
	echo "$rem_5_2_7" >>  $remediation_filename
else
	echo "$pass $var_5_2_7"
fi

############################################################################
rem_5_2_8=$(cat  <<  EOF 
================================================
5.2.8 Chỉnh sửa file /etc/ssh/sshd_config và đặt tham số như sau:
 PermitEmptyPasswords no
-----------------------------------------------
Tác động: Không tác động tới hệ thống.
EOF
)

var_5_2_8="5.2.8 Cấu hình vô hiệu hóa PermitEmptyPasswords cho máy chủ SSH"
if [ $(grep "^PermitEmptyPasswords.*no" /etc/ssh/sshd_config 2> /dev/null | wc -l) -eq 0 ]; then
	echo "$fail $var_5_2_8"
	echo "$rem_5_2_8" >>  $remediation_filename
else
	echo "$pass $var_5_2_8"
fi

############################################################################
rem_5_2_9=$(cat  <<  EOF 
================================================
5.2.9 Chỉnh sửa file /etc/ssh/sshd_config và đặt tham số như sau:
 PermitUserEnvironment no
-----------------------------------------------
Tác động: Không tác động tới hệ thống.
EOF
)

var_5_2_9="5.2.9 Cấu hình vô hiệu hóa PermitUserEnviroment cho máy chủ SSH"
if [ $(grep "^PermitUserEnvironment.*no" /etc/ssh/sshd_config 2> /dev/null | wc -l) -eq 0 ]; then
	echo "$fail $var_5_2_9"
	echo "$rem_5_2_9" >>  $remediation_filename
else
	echo "$pass $var_5_2_9"
fi

############################################################################
rem_5_2_10=$(cat  <<  EOF 
================================================
5.2.10 Chỉnh sửa file /etc/ssh/sshd_config và thêm/thay đổi dòng MACs để chứa danh sách MAC được chấp thuận:
 Ví dụ:
 MACs hmac-sha2-512-etm@openssh.com,hmac-sha2-256-etm@openssh.com,hmac-sha2-512,hmac-sha2-256
-----------------------------------------------
Tác động: Không thể sử dụng được các loại mã hoá yếu.
EOF
)

var_5_2_10="5.2.10 Cấu hình các thuật toán MAC được cho phép"
if [ $(grep "^MACs.*hmac" /etc/ssh/sshd_config 2> /dev/null | wc -l) -eq 0 ]; then
	echo "$fail $var_5_2_10"
	echo "$rem_5_2_10" >>  $remediation_filename
else
	echo "$pass $var_5_2_10"
fi

############################################################################
rem_5_2_11=$(cat  <<  EOF 
================================================
5.2.11 Chỉnh sửa file /etc/ssh/sshd_config và đặt tham số như sau:
 ClientAliveInterval 300
 ClientAliveCountMax 0
-----------------------------------------------
Tác động: Không tác động tới hệ thống.
EOF
)

var_5_2_11="5.2.11 Cấu hình khoảng thời gian chờ không hoạt động cho máy chủ SSH"
if [ $(grep "^ClientAliveInterval.*300" /etc/ssh/sshd_config 2> /dev/null | wc -l) -eq 0 ] || [ $(grep "^ClientAliveCountMax.*0" /etc/ssh/sshd_config 2> /dev/null | wc -l) -eq 0 ]; then
	echo "$fail $var_5_2_11"
	echo "$rem_5_2_11" >>  $remediation_filename
else
	echo "$pass $var_5_2_11"
fi

############################################################################
rem_5_2_12=$(cat  <<  EOF 
================================================
5.2.12 Chỉnh sửa file /etc/ssh/sshd_config và đặt tham số như sau:
 LoginGraceTime 60
-----------------------------------------------
Tác động: Nếu người dùng không đăng nhập trong 60s phiên đăng nhập sẽ kết thúc.
EOF
)

var_5_2_12="5.2.12 Cấu hình SSH LoginGraceTime cho máy chủ SSH"
if [ $(grep "^LoginGraceTime.*60" /etc/ssh/sshd_config 2> /dev/null | wc -l) -eq 0 ]; then
	echo "$fail $var_5_2_12"
	echo "$rem_5_2_12" >>  $remediation_filename
else
	echo "$pass $var_5_2_12"
fi

############################################################################
rem_5_2_13=$(cat  <<  EOF 
================================================
5.2.13 Chỉnh sửa file /etc/ssh/sshd_config và đặt tham số như sau:
 AllowUsers <list of users>
 hoặc
 AllowGroups <list of groups>
 hoặc
 DenyUsers <list of users>
 hoặc
 DenyGroups <list of groups>
-----------------------------------------------
Tác động: Chỉ cho phép các user có trong AllowUsers và AllowGroups mới được phép đăng nhập.
EOF
)

var_5_2_13="5.2.13 Cấu hình giới hạn truy cập cho máy chủ SSH"
if [ $(sshd -T | grep -E '^\s*(allow|deny)(users|groups)\s+\S+' 2> /dev/null | wc -l) -eq 0 ]; then
	echo "$fail $var_5_2_13"
	echo "$rem_5_2_13" >>  $remediation_filename
else
	echo "$pass $var_5_2_13"
fi

############################################################################
rem_5_2_14=$(cat  <<  EOF 
================================================
5.2.14 Chỉnh sửa file /etc/ssh/sshd_config và đặt tham số như sau:
 Banner /etc/issue.net
-----------------------------------------------
Tác động: Tác động: Nội dung trong /etc/issue.net cần được đảm bảo không chứa thông tin nhạy cảm.
EOF
)

var_5_2_14="5.2.14 Cấu hình cảnh báo SSH"
if [ $(grep "^Banner.*/etc/issue.net" /etc/ssh/sshd_config 2> /dev/null | wc -l) -eq 0 ]; then
	echo "$fail $var_5_2_14"
	echo "$rem_5_2_14" >>  $remediation_filename
else
	echo "$pass $var_5_2_14"
fi

############################################################################
var_5_3="5.3 Cấu hình PAM"
echo "$info $var_5_3"

############################################################################
rem_5_3_1=$(cat  <<  EOF 
================================================
5.3.1 Thực hiện các bước sau để cài đặt và chỉnh sửa libpam-pwquality
 Chỉnh sửa file /etc/security/pwquality.conf để thêm hoặc cập nhật những thiết lập sau:
 minlen = 14
 
 minclass = 4
 hoặc 
 dcredit = -1
 ucredit = -1
 ocredit = -1
 lcredit = -1
 Các thiết lập trong file /etc/security/pwquality.conf phải sử dụng dấu cách xung quanh dấu “=”.
-----------------------------------------------
Tác động: Việc thiết lập điều kiện tạo mật khẩu quá khó có thể khiến cho người dùng dễ quên mật khẩu, tăng lượng công việc cho đội ngũ quản trị.
EOF
)

var_5_3_1="5.3.1 Cấu hình điều kiện tạo mật khẩu"
if [ $(grep "^password.*requisite.*pam_pwquality\.so.*try_first_pass.*retry.*3" /etc/pam.d/system-auth | wc -l) -eq 0 ] || [ $(grep "^password.*requisite.*pam_pwquality\.so.*try_first_pass.*retry.*3" /etc/pam.d/password-auth | wc -l) -eq 0 ] || [ $(grep "^minlen = 14" /etc/security/pwquality.conf | wc -l) -eq 0 ] ; then
	echo "$fail $var_5_3_1"
	echo "$rem_5_3_1" >>  $remediation_filename
else
	echo "$pass $var_5_3_1"
fi

############################################################################
rem_5_3_2=$(cat  <<  EOF 
================================================
5.3.2 Chỉnh sửa file /etc/pam.d/system-auth và file /etc/pam.d/password-auth  
Chỉnh sửa tham số deny=5 và unlock_time=900 theo mẫu dưới đây:
Đối với phần auth:
auth required pam_env.so
auth required pam_tally2.so deny=5 onerr=fail unlock_time=900 #<- Under "auth required pam_env.so"
auth sufficient pam_unix.so nullok try_first_pass
auth requisite pam_succeed_if.so uid >= 1000 quiet_success
auth required pam_deny.so

đối với phần account:
account required pam_tally2.so
account required pam_unix.so
account sufficient pam_localuser.so
account sufficient pam_pam_succeed_if.so uid < 1000 quiet
account required pam_permit.so

-----------------------------------------------
Tác động: Kẻ tấn công có thể lợi dụng điều này gây nên một cuộc tấn công dos.
EOF
)

var_5_3_2="5.3.2 Cấu hình khóa truy cập do nhiều lần nhập mật khẩu thất bại"
if ( [ $(grep "auth.*required.*pam_tally2\.so.*deny.*5.*onerr.*fail.*unlock_time.*900" /etc/pam.d/password-auth | wc -l) -eq 0 ] || [ $(grep "account.*required.*pam_tally2\.so" /etc/pam.d/password-auth | wc -l) -eq 0 ] || [ $(grep "auth.*required.*pam_tally2\.so.*deny.*5.*onerr.*fail.*unlock_time.*900" /etc/pam.d/system-auth | wc -l) -eq 0 ] ) || ( [ $(grep "account.*required.*pam_tally2\.so" /etc/pam.d/system-auth | wc -l) -eq 0 ] ); then
    echo "$fail $var_5_3_2"
	echo "$rem_5_3_2" >>  $remediation_filename
else
	echo "$pass $var_5_3_2"
fi

############################################################################
rem_5_3_3=$(cat  <<  EOF 
================================================
5.3.3 Chỉnh sửa file /etc/pam.d/password-auth và /etc/pam.d/system-auth để bao gồm tùy chọn remember và tuân thủ theo chính sách của tổ chức theo mẫu sau:
password requisite pam_pwquality.so try_first_pass local_users_only authtok_type=
password required pam_pwhistory.so use_authtok remember=5 retry=3
password sufficient pam_unix.so sha512 shadow nullok try_first_pass use_authtok
password required pam_deny.so
-----------------------------------------------
Tác động: Việc giới hạn sử dụng lại mật khẩu có thể khiến cho người dùng đặt các mật khẩu dễ đoán như mật khẩu cũ là Admin1 thì mật khẩu mới sẽ là Admin2.
EOF
)

var_5_3_3="5.3.3 Giới hạn việc sử dụng lại mật khẩu"
if [ $(grep "^password.*sufficient.*pam_pwhistory\.so.*remember.*5" /etc/pam.d/password-auth | wc -l) -eq 0 ] && [ $(grep "^password.*sufficient.*pam_unix\.so.*remember.*5"  /etc/pam.d/system-auth | wc -l) -eq 0 ]; then
	echo "$fail $var_5_3_3"
	echo "$rem_5_3_3" >>  $remediation_filename
else
	echo "$pass $var_5_3_3"
fi

############################################################################
rem_5_3_4=$(cat  <<  EOF 
================================================
5.3.4 Chỉnh sửa file /etc/pam.d/password-auth và /etc/pam.d/system-auth để có tùy chọn sha512 cho pam_unix.so như dưới đây:
password sufficient pam_unix.so sha512
-----------------------------------------------
Tác động: Không tác động tới hệ thống.
EOF
)

var_5_3_4="5.3.4 Cấu hình thuật toán hash mật khẩu sang SHA-512"
if [ $(grep "^password.*sufficient.*pam_unix\.so.*sha512" /etc/pam.d/password-auth | wc -l) -eq 0 ] || [ $(grep "^password.*sufficient.*pam_unix\.so.*sha512" /etc/pam.d/system-auth | wc -l) -eq 0 ]; then
    echo "$fail $var_5_3_4"
	echo "$rem_5_3_4" >>  $remediation_filename
else
	echo "$pass $var_5_3_4"
fi

############################################################################
var_5_4="5.4 Cấu hình tài khoản người dùng và môi trường"
var_5_4_1=" 5.4.1 Cấu hình mật khẩu người dùng"
echo "$info $var_5_4"
echo "$info $var_5_4_1"

############################################################################
rem_5_4_1_1=$(cat  <<  EOF 
================================================
5.4.1.1 Đặt tham số PASS_MAX_DAYS trong file /etc/login.defs tuân theo chính sách của tổ chức:
 PASS_MAX_DAYS 90
 Chỉnh sửa tham số cho người dùng sử dụng mật khẩu bằng câu lệnh sau:
 chage --maxdays 90
-----------------------------------------------
Tác động: Đối với các tài khoản đặc biệt phải cấu hình ngoại lệ với mục này.
EOF
)

var_5_4_1_1="5.4.1.1 Cấu hình thời gian hết hạn sử dụng mật khẩu"
count=0
for i in $(grep -E '^[^:]+:[^!*]' /etc/shadow | cut -d: -f1,5 | awk -F ':' '{print $2}'); do
    if [ $i -gt 90 ]; then
        count=$((count+1))
    fi
done
if [ $(grep "^PASS_MAX_DAYS.*90" /etc/login.defs | wc -l) -eq 0 ] || [ "$count" -ne "1" ]; then
    echo "$fail $var_5_4_1_1"
	echo "$rem_5_4_1_1" >>  $remediation_filename
else
	echo "$pass $var_5_4_1_1"
fi

############################################################################
rem_5_4_1_2=$(cat  <<  EOF 
================================================
5.4.1.2 Đặt tham số PASS_MIIN_DAYS trong file /etc/login.defs là 7:
 PASS_MIN_DAYS 7
 Chỉnh sửa tham số cho người dùng sử dụng mật khẩu bằng câu lệnh sau:
 chage --mindays 7
-----------------------------------------------
Tác động: Đối với các tài khoản đặc biệt phải cấu hình ngoại lệ với mục này.
EOF
)

var_5_4_1_2="5.4.1.2 Cấu hình thời gian tối thiểu giữa những lần thay đổi mật khẩu"
count=0
for i in $(grep -E ^[^:]+:[^\!*] /etc/shadow | cut -d: -f1,4 | awk -F ':' '{print $2}'); do
    if [ $i -lt 7 ]; then
        count=$((count+1))
    fi
done
if [ $(grep "^PASS_MIN_DAYS.*7" /etc/login.defs | wc -l) -eq 0 ] || [ "$count" -ne "2" ]; then
    echo "$fail $var_5_4_1_2"
	echo "$rem_5_4_1_2" >>  $remediation_filename
else
	echo "$pass $var_5_4_1_2"
fi

############################################################################
rem_5_4_1_3=$(cat  <<  EOF 
================================================
5.4.1.3 Đặt tham số PASS_WARN_AGE trong file /etc/login.defs là 7:
 PASS_WARN_AGE 7
 Chỉnh sửa tham số của người dùng sử dụng mật khẩu bằng câu lệnh sau:
 chage --warndays 7
 warndays 7
-----------------------------------------------
Tác động: Đối với các tài khoản đặc biệt phải cấu hình ngoại lệ với mục này.
EOF
)

var_5_4_1_3="5.4.1.3 Cấu hình thời gian cảnh báo mật khẩu hết hạn"
count=0
for i in $( grep -E ^[^:]+:[^\!*] /etc/shadow | cut -d: -f1,6 | awk -F ':' '{print $2}'); do
    if [ $i -lt 7 ]; then
        count=$((count+1))
    fi
done
if [ $(grep "^PASS_WARN_AGE.*7" /etc/login.defs | wc -l) -eq 0 ] || [ "$count" -ne "0" ]; then
    echo "$fail $var_5_4_1_3"
	echo "$rem_5_4_1_3" >>  $remediation_filename
else
	echo "$pass $var_5_4_1_3"
fi

############################################################################
rem_5_4_1_4=$(cat  <<  EOF 
================================================
5.4.1.4 Thực hiện câu lệnh sau dể đặt khoảng thời gian tài khoản không hoạt động là 30 ngày:
 useradd -D -f 30
 Chỉnh sửa thông số của người dùng sử dụng mật khẩu bằng câu lệnh sau:
 chage --inactive 30 <user>
-----------------------------------------------
Tác động: Đối với các tài khoản đặc biệt phải cấu hình ngoại lệ với mục này.
EOF
)

var_5_4_1_4="5.4.1.4 Cấu hình thời gian khóa tài khoản không thay mật khẩu sau khi hết hạn"
count=0
for i in $(grep -E -v "^\+" /etc/shadow | awk -F: '( $2!="*" && $2!="!!" && $7>30 && $7!="") {print}'); do
    count=$((count+1))
done
if [ $(useradd -D | grep "INACTIVE.*30" | wc -l) -eq 0 ] || [ "$count" -ne "0" ]; then
    echo "$fail $var_5_4_1_4"
	echo "$rem_5_4_1_4" >>  $remediation_filename
else
	echo "$pass $var_5_4_1_4"
fi

############################################################################
rem_5_4_2=$(cat  <<  EOF 
================================================
 Đặt shell cho những tài khoản được trả về bởi script trên phần Kiểm tra sang /sbin/nologin:
 usermod -s /sbin/nologin <user>
 Script dưới đây sẽ tự động đặt toàn bộ các shell người dùng cần thiết sang /sbin/nologin và khóa các người dùng sync, shutdown, và halt:
 for user in `awk -F: '($3 < 1000) {print $1 }' /etc/passwd` ; do
     if [ $user != "root" ]; then
         usermod -L $user
         if [ $user != "sync" ] && [ $user != "shutdown" ] && [ $user != "halt" ]; then
             usermod -s /sbin/nologin $user
         fi
     fi
 done
-----------------------------------------------
Tác động: Không tác động tới hệ thống.
EOF
)

var_5_4_2="5.4.2 Đảm bảo các tài khoản hệ thống không thể đăng nhập được"
if [ $(grep -E -v "^\+" /etc/passwd | awk -F: '($1!="root" && $1!="sync" && $1!="shutdown" && $1!="halt" && $3<1000 && $7!="/sbin/nologin" && $7!="/bin/false") {print}' | wc -l) -gt 0 ]; then
    echo "$fail $var_5_4_2"
    echo "$rem_5_4_2" >> $remediation_filename
else
    echo "$pass $var_5_4_2"
fi

############################################################################
rem_5_4_3=$(cat  <<  EOF 
================================================
5.4.3 Thực hiện câu lệnh sau để đặt group mặc định cho người dùng root là GID 0:
 usermod -g 0 root
-----------------------------------------------
Tác động: Không tác động tới hệ thống, tuy nhiên cần đảm bảo không grouper nào khác có GID là 0.
EOF
)

var_5_4_3="5.4.3 Đảm bảo group mặc định của tài khoản root là GID 0"
if [ $(grep "^root:" /etc/passwd | cut -d: -f4 | grep -E "0") -ne 0 ]; then
	echo "$fail $var_5_4_3"
	echo "$rem_5_4_3" >>  $remediation_filename
else
	echo "$pass $var_5_4_3"
fi

############################################################################
rem_5_4_4=$(cat  <<  EOF 
================================================
5.4.4 Chỉnh sửa file /etc/bash.bashrc, /etc/profile và /etc/profile.d/*.sh, thêm vào hoặc chỉnh sửa tất cả các tham số umask như sau:
 umask 027
 for file in /etc/profile.d/*.sh; do echo "umask 027" >> "$file"; done
 echo "umask 027" >> /etc/bash.bashrc
 echo "umask 027" >> /etc/profile
-----------------------------------------------
Tác động: Tác động: Việc đặt USERGROUPS_ENAB no trong /etc/login.defs có thể thay đổi hành vi dự kiến của useradd và userdel.
Ghi chú: Phương pháp này chỉ áp dụng cho bash và shell. Nếu có hỗ trợ các shell khác trên hệ thống, nên kiểm tra cấu hình của chúng nữa.
EOF
)

var_5_4_4="5.4.4 Cấu hình user umask mặc định"
if [ $(grep "umask.*027" /etc/bash.bashrc 2>/dev/null | wc -l) -ne 0 ] && [ $(grep "umask.*027" /etc/profile | wc -l) -ne 0 ] && [ $(grep "UMASK.*027" /etc/login.defs | wc -l ) -ne 0 ] && [ $(grep "USERGROUPS_ENAB.*no" /etc/login.defs | wc -l ) -ne 0 ]; then
    flag=true
    for i in /etc/profile.d/*.sh; do
        if [ $(grep "umask.*027" /etc/profile.d/*.sh | wc -l) -eq 0 ]; then
            flag=false
            break
        fi
    done
    if [ "$flag" = true ]; then
	    echo "$pass $var_5_4_4"
    else
	    echo "$fail $var_5_4_4"
	    echo "$rem_5_4_4" >>  $remediation_filename
    fi
else
	echo "$fail $var_5_4_4"
	echo "$rem_5_4_4" >>  $remediation_filename
fi

############################################################################
rem_5_4_5=$(cat  <<  EOF 
================================================
5.4.5 Tạo ra một nhóm rỗng sẽ được chỉ định để sử dụng trong lệnh su. Tên nhóm nên được đặt tên theo chính sách:
 groupadd sugroup
 Thêm dòng sau vào file /etc/pam.d/su, chỉ định nhóm rỗng vừa tạo vào:
 auth required pam_wheel.so use_uid group=sugroup
-----------------------------------------------
Tác động: user không nằm trong nhóm sugroup sẽ không thể thực hiện câu lệnh su.
EOF
)

var_5_4_5="5.4.5 Cấu hình hạn chế truy cập cho câu lệnh su"
if [ $( grep -E '^\s*auth\s+required\s+pam_wheel\.so\s+(\S+\s+)*use_uid\s+(\S+\s+)*group=\S+\s*(\S+\s*)*(\s+#.*)?$' /etc/pam.d/su | wc -l) -eq 0 ] ; then
	echo "$fail $var_5_4_5"
	echo "$rem_5_4_5" >>  $remediation_filename
else
	echo "$pass $var_5_4_5" 
fi

############################################################################
var_6="6 System Maintenance"
var_6_1="6.1 Quyền của file hệ thống"
echo "$info $var_6"
echo "$info $var_6_1"

remember_6_1_1="false"
############################################################################
rem_6_1_1=$(cat  <<  EOF 
================================================
6.1.1 - 6.1.8 Thực hiện các câu lệnh sau để đặt quyền ở file /etc/passwd:
 chown root:root /etc/passwd
 chmod 644 /etc/passwd
 chown root:root /etc/shadow
 chmod 0000  /etc/shadow
 chown root:root /etc/group
 chmod 644 /etc/group
 chown root:root /etc/gshadow
 chmod 0000 /etc/gshadow
 chown root:root /etc/passwd-
 chmod 644 /etc/passwd-
 chown root:root /etc/shadow-
 chmod 0000 /etc/shadow-
 chown root:root /etc/group-
 chmod 644 /etc/group-
 chown root:root /etc/gshadow-
 chmod 0000 /etc/gshadow-
-----------------------------------------------
Tác động: Không tác động tới hệ thống.
EOF
)

############################################################################
var_6_1_1="6.1.1 Cấu hình quyền cho file /etc/passwd"
if [ $(stat /etc/passwd | grep "0644.*Uid:.*0/.*root.*Gid:.*0/.*root" | wc -l) -eq 0 ]; then
	echo "$fail $var_6_1_1"
	remember_6_1_1="true"
else
	echo "$pass $var_6_1_1"
fi

############################################################################
var_6_1_2="6.1.2 Cấu hình quyền cho file /etc/shadow"
if [ $(stat /etc/shadow | grep "0000.*Uid:.*0/.*root.*Gid:.*0/.*root" | wc -l) -eq 0 ] && [ $(stat /etc/shadow | grep "0640.*Uid:.*0/.*root.*Gid:.*42/.*shadow" | wc -l) -eq 0 ]; then
	echo "$fail $var_6_1_2"
	remember_6_1_1="true"
else
	echo "$pass $var_6_1_2"
fi

############################################################################
var_6_1_3="6.1.3 Cấu hình quyền cho file /etc/group"
if [ $(stat /etc/group | grep "0644.*Uid:.*0/.*root.*Gid:.*0/.*root" | wc -l) -eq 0 ]; then
	echo "$fail $var_6_1_3"
	remember_6_1_1="true"
else
	echo "$pass $var_6_1_3"
fi

############################################################################
var_6_1_4="6.1.4 Cấu hình quyền cho file /etc/gshadow"
if [ -f /etc/gshadow ]; then
    if [ $(stat /etc/gshadow | grep "0000.*Uid:.*0/.*root.*Gid:.*0/.*root" | wc -l) -eq 0 ] && [ $(stat /etc/shadow | grep "0000.*Uid:.*0/.*root.*Gid:.*42/.*shadow" | wc -l) -eq 0 ]; then
        echo "$fail $var_6_1_4"
        remember_6_1_1="true"
    else
	    echo "$pass $var_6_1_4"
    fi
else
	echo "$fail $var_6_1_4"
	remember_6_1_1="true"
fi

############################################################################
var_6_1_5="6.1.5 Cấu hình quyền cho file /etc/passwd-"
if [ $(stat /etc/passwd- | grep "0[0246][04][04].*Uid:.*0/.*root.*Gid:.*0/.*root" | wc -l) -eq 0 ]; then

	echo "$fail $var_6_1_5"
	remember_6_1_1="true"

else
	echo "$pass $var_6_1_5"
fi

############################################################################
var_6_1_6="6.1.6 Cấu hình quyền cho file /etc/shadow-"
if [ $(stat /etc/shadow- | grep "0000.*Uid:.*0/.*root.*Gid:.*0/.*root" | wc -l) -eq 0 ] && [ $(stat /etc/shadow | grep "0640.*Uid:.*0/.*root.*Gid:.*42/.*shadow" | wc -l) -eq 0 ]; then
	echo "$fail $var_6_1_6"
	remember_6_1_1="true"
else
	echo "$pass $var_6_1_6"
fi

############################################################################
var_6_1_7="6.1.7 Cấu hình quyền cho file /etc/group-"
if [ $(stat /etc/group- | grep "0[0246][04][04].*Uid:.*0/.*root.*Gid:.*0/.*root" | wc -l) -eq 0 ]; then
	echo "$fail $var_6_1_7"
	remember_6_1_1="true"
else
	echo "$pass $var_6_1_7"
fi

############################################################################
var_6_1_8="6.1.8 Cấu hình quyền cho file /etc/gshadow-"
if [ -f /etc/gshadow- ]; then
    if [ $(stat /etc/gshadow- | grep -E "0000.*Uid:.*0/.*root.*Gid:.*0/.*root" | wc -l) -eq 0 ] && [ $(stat /etc/shadow | grep "0000.*Uid:.*0/.*root.*Gid:.*42/.*shadow" | wc -l) -eq 0 ]; then
        echo "$fail $var_6_1_8"
        remember_6_1_1="true"
    else
	    echo "$pass $var_6_1_8"
    fi
else
	echo "$fail $var_6_1_8"
	remember_6_1_1="true"
fi

if [ "$remember_6_1_1" == "true" ] ; then
    echo "$rem_6_1_1" >> $remediation_filename
fi

############################################################################
rem_6_1_9=$(cat  <<  EOF 
================================================
6.1.9 Nên xóa quyền ghi cho danh mục "other" (chmod o-w <tên tệp>), nhưng luôn tham khảo tài liệu của nhà cung cấp có liên quan để tránh phá vỡ bất kỳ phụ thuộc ứng dụng nào trên một tệp nhất định.
-----------------------------------------------
Tác động: Nên thao khảo tài liệu cung cấp liên quan để tránh phá vỡ sự phụ thuộc trên một tệp nhất định.
EOF
)

var_6_1_9="6.1.9 Đảm bảo không có file world-writable tồn tại"
if [ $( df --local -P | awk {'if (NR!=1) print $6'} | xargs -I '{}' find '{}' -xdev -type f -perm -0002 2>/dev/null | wc -l) -gt 0 ] || [ $(find / -xdev -type f -perm -0002 | wc -l) -gt 0 ]; then
	echo "$fail $var_6_1_9"
	echo "$rem_6_1_9" >>  $remediation_filename
else
	echo "$pass $var_6_1_9" 
fi

###########################################################################
rem_6_1_10=$(cat  <<  EOF 
================================================
6.1.10 Xác định các file và thư mục được sở hữu bởi người dùng hoặc group không được liệt kê trong file cấu hình hệ thống, và reset quyền sở hữu của những file này cho những người dùng đang hoạt động khác trên hệ thống sao cho phù hợp.
-----------------------------------------------
Tác động: Nếu không xoá các file này một người dùng mới tạo có thể trùng id với id người dùng đã sở hữu những file này.
EOF
)

var_6_1_10="6.1.10 Đảm bảo các file hoặc thư mục không có chủ sở hữu không tồn tại"
result=$(df --local -P | awk {'if (NR!=1) print $6'} | xargs -I '{}' find '{}' -xdev -nouser 2>/dev/null)

if [ -n "$result1" ]; then
	if [[ -n $(echo "$result" | grep -e "/var/cache/private/fwupdmgr" -e "/var/cache/private/fwupdmgr/fwupd" -e "/var/cache/private/fwupdmgr/fwupd/lvfs-metadata.xml" -e "/var/cache/private/fwupdmgr/fwupd/lvfs-metadata.xml.gz" -e "/var/cache/private/fwupdmgr/fwupd/lvfs-metadata.xml.gz.asc") ]]; then
	    echo "$pass $var_6_1_10"
	else
        echo "$fail $var_6_1_10"
        echo "$rem_6_1_10" >>  $remediation_filename
	fi
else
	echo "$pass $var_6_1_10"
fi

############################################################################
rem_6_1_11=$(cat  <<  EOF 
================================================
6.1.11 Xác định các file và thư mục được sở hữu bởi người dùng hoặc group không được liệt kê trong file cấu hình hệ thống, và reset quyền sở hữu của những file này cho những người dùng đang hoạt động khác trên hệ thống sao cho phù hợp.
-----------------------------------------------
Tác động: Nếu không xoá các file này một nhóm mới tạo có thể trùng id với id nhóm đã sở hữu những file này.
EOF
)

var_6_1_11="6.1.11 Đảm bảo các file hoặc thư mục không có nhóm không tồn tại"
result1=$(df --local -P | awk {'if (NR!=1) print $6'} | xargs -I '{}' find '{}' -xdev -nogroup 2>/dev/null)

if [ -n "$result1" ]; then
	if [[ -n $(echo "$result1" | grep -e "/var/cache/private/fwupdmgr" -e "/var/cache/private/fwupdmgr/fwupd" -e "/var/cache/private/fwupdmgr/fwupd/lvfs-metadata.xml" -e "/var/cache/private/fwupdmgr/fwupd/lvfs-metadata.xml.gz" -e "/var/cache/private/fwupdmgr/fwupd/lvfs-metadata.xml.gz.asc") ]]; then
	    echo "$pass $var_6_1_11"
	else
        echo "$fail $var_6_1_11"
        echo "$rem_6_1_11" >>  $remediation_filename
	fi
else
	echo "$pass $var_6_1_11"
fi

############################################################################
var_6_2="6.2 Thiết lập cho người dùng và nhóm"
echo "$info $var_6_2"

############################################################################
rem_6_2_1=$(cat  <<  EOF 
================================================
6.2.1 Nếu có tài khoản nào trong file /etc/shadow không có mật khẩu, thực hiện câu lệnh sau để khóa tài khoản đến khi xác định được nguyên nhân tài khoản đó không có mật khẩu:
 passwd -l <username>
 Đồng thời, kiểm tra tài khoản đó được đăng nhập hay chưa và tìm hiểu xem tài khoản đó được sử dụng với mục đích gì để nếu nó cần phải bị xóa.
-----------------------------------------------
Tác động: Cần phải đặt ngoại lệ cho các tài khoản đặc biệt trên hệ thống.
EOF
)

var_6_2_1="6.2.1 Đảm bảo trường mật khẩu không để trống"
if [ $(awk -F: '$5==90 && $6==7 {print}' /etc/shadow | awk -F: ' $2=="!" || $2=="" || $2=="!!"{print $1}' | wc -l) -gt 0 ]; then
    echo "$fail $var_6_2_1"
	echo "$rem_6_2_1" >>  $remediation_filename
else
	echo "$pass $var_6_2_1"
fi

############################################################################
rem_6_2_2=$(cat  <<  EOF 
================================================
6.2.2 Loại bỏ bất kỳ bản ghi có dấu “+” trong file /etc/passwd
-----------------------------------------------
Tác động: Không tác động tới hệ thống.
EOF
)

var_6_2_2="6.2.2 Đảm bảo không có bản ghi chứa + trong file /etc/passwd"
if [ $(grep '\+:' /etc/passwd | wc -l) -gt 0 ]; then
	echo "$fail $var_6_2_2"
	echo "$rem_6_2_2" >>  $remediation_filename
else
	echo "$pass $var_6_2_2"
fi

############################################################################
rem_6_2_3=$(cat  <<  EOF 
================================================
6.2.3 Loại bỏ bất kỳ bản ghi nào có dấu “+” trong file /etc/shadow
-----------------------------------------------
Tác động: Không tác động tới hệ thống.
EOF
)

var_6_2_3="6.2.3 Đảm bảo không có bản ghi chứa + trong file /etc/shadow"
if [ $(grep '\+' /etc/shadow | wc -l) -gt 0 ]; then
	echo "$fail $var_6_2_3"
	echo "$rem_6_2_3" >>  $remediation_filename  
else
	echo "$pass $var_6_2_3"
fi

############################################################################
rem_6_2_4=$(cat  <<  EOF 
================================================
6.2.4 Loại bỏ bất kỳ bản ghi nào có dấu “+” trong file /etc/group
-----------------------------------------------
Tác động: Không tác động tới hệ thống.
EOF
)

var_6_2_4="6.2.4 Đảm bảo không có bản ghi chứa + trong file /etc/group"
if [ $(grep '\+' /etc/group | wc -l) -gt 0 ]; then
	echo "$fail $var_6_2_4"
	echo "$rem_6_2_4" >>  $remediation_filename
else
	echo "$pass $var_6_2_4"
fi

############################################################################
var_6_2_5="6.2.5 Đảm bảo root là tài khoản duy nhất có UID là 0"
rem_6_2_5=$(cat  <<  EOF 
================================================
6.2.5 Loại bỏ bất kỳ user nào ngoài root có UID là 0 hoặc chỉ định chúng một UID mới, phù hợp với chính sách của tổ chức.
-----------------------------------------------
Tác động: Không tác động tới hệ thống.
EOF
)
if [ "$( cat /etc/passwd | awk -F: '$3==0 {print $1}')" != 'root' ]; then
	echo "$fail $var_6_2_5"
	echo "$rem_6_2_5" >>  $remediation_filename
else
	echo "$pass $var_6_2_5" 
fi

############################################################################
var_6_2_6="6.2.6 Đảm bảo người dùng sở hữu thư mục home của chính họ"
rem_6_2_6=$(cat  <<  EOF 
================================================
6.2.6 Đảm bảo người dùng sở hữu thư mục home của chính họ.
-----------------------------------------------
Tác động: Nếu không tạo rất có thể người dùng đó sẽ không có quyền gì trên hệ thống.
EOF
)
# Đảm bảo tính toàn vẹn cho biến môi trường PATH của root.

read -r -d '' script << EOM
    if [ "'echo $PATH | grep ::'" != "" ]; then
        if [[ $1 -ne '' ]]; then
            echo "Empty Directory in PATH (::)"
        fi
    fi
    if [ "'echo $PATH | grep :$'" != "" ]; then
        if [[ $1 -ne '' ]]; then
            echo "Trailing : in PATH"
        fi
    fi
    p='echo $PATH | sed -e 's/::/:/' -e 's/:$//' -e 's/:/ /g''
    set -- $p
    while [ "$1" != "" ]; do
        if [ "$1" = "." ]; then
            shift
            continue
        fi
        if [ -d $1 ]; then
            dirperm=`ls -ldH $1 | cut -f1 -d" "`
            dirown=`ls -ldH $1 | awk '{print $3}'`
        fi	
        shift
    done
EOM
if [ $(eval $cript | wc -l) -ne 0 ]; then
    echo "$fail $var_6_2_6"
	echo "$rem_6_2_6" >>  $remediation_filename
else
    echo "$pass $var_6_2_6"
fi

############################################################################
rem_6_2_7=$(cat  <<  EOF 
================================================
6.2.7 Nếu bất kỳ người dùng nào không có thư mục home, hãy tạo và đảm bảo người dùng tương ứng sở hữu thư mục đó. Những người dùng không có thư mục home nên bị xóa hoặc chỉ định họ một thư mục home phù hợp.
-----------------------------------------------
Tác động: Nếu không tạo rất có thể người dùng đó sẽ không có quyền gì trên hệ thống.
EOF
)

var_6_2_7="6.2.7 Đảm bảo mọi người dùng đều tồn tại thư mục home"
flag=true
for dir in `awk -F: '($1!~/(halt|sync|shutdown|nfsnobody)/ && $7!~/^(\/usr)?\/sbin\/nologin(\/)?$/ && $7!~/(\/usr)?\/bin\/false(\/)?$/){print $1":"$6}' /etc/passwd | cut -d: -f2`; do
    if [ ! -d "$dir" ]; then
        echo "$fail $var_6_2_7"
		echo "$rem_6_2_7" >>  $remediation_filename
        flag=false
        break
    
    fi
done
if [ "$flag" = true ]; then
    echo "$pass $var_6_2_7"
fi

############################################################################
rem_6_2_8=$(cat  <<  EOF 
================================================
6.2.8 Thực hiện các sửa đổi toàn cầu đối với thư mục /home của người dùng mà không thông báo cho cộng đồng người dùng có thể dẫn đến sự cố không mong muốn và người dùng không hài lòng. Do đó, bạn nên thiết lập chính sách giám sát để báo cáo quyền đối với tệp người dùng và xác định hành động cần thực hiện theo chính sách tổ chức.
-----------------------------------------------
Tác động: Nếu người dùng muốn cho người dùng khác truy cập vào thư mục home của chính mình cần phải thay đổi quyền sao cho phù hợp với yêu cầu của tổ chức.
EOF
)

var_6_2_8="6.2.8 Đảm bảo quyền thư mục home của người dùng có mức bảo mật cao"
flag=true
for dir in `awk -F: '($1!~/(halt|sync|shutdown|nfsnobody)/ && $7!~/^(\/usr)?\/sbin\/nologin(\/)?$/ && $7!~/(\/usr)?\/bin\/false(\/)?$/){print $1":"$6}' /etc/passwd | cut -d: -f2`; do
    if [ ! -d "$dir" ] || [ $(stat $dir | grep -E "0750|0700" | wc -l) -eq 0 ]; then
        echo "$pass $var_6_2_8"
        echo "$rem_6_2_8" >>  $remediation_filename
        flag=false
        break
    fi
done
if [ "$flag" = true ]; then
    echo "$pass $var_6_2_8"
fi

############################################################################
rem_6_2_9=$(cat  <<  EOF 
================================================
6.2.9 Thay đổi quyền sở hữu của bất kỳ thư mục home nào không được sở hữu bởi người dùng được định danh sang đúng người dùng.
Thực hiện đoạn script sau để tự động cấu hình
#!/bin/bash
awk -F: '($1!~/(halt|sync|shutdown|nfsnobody)/ && $7!~/^(\/usr)?\/sbin\/nologin(\/)?$/ && $7!~/(\/usr)?\/bin\/false(\/)?$/) { print $1 " " $6 }' /etc/passwd | while read -r user dir; do
 if [ ! -d "$dir" ]; then
 echo "User: \"$user\" home directory: \"$dir\" does not exist, creating home directory"
 mkdir "$dir"
 chmod g-w,o-rwx "$dir"
 chown "$user" "$dir"
 else
 owner=$(stat -L -c "%U" "$dir")
 if [ "$owner" != "$user" ]; then
 chmod g-w,o-rwx "$dir"
 chown "$user" "$dir"
 fi
 fi
done
-----------------------------------------------
Tác động: Nếu người dùng không sử dụng thư mục home của chính họ sẽ dấn đến việc cài đặt các quyền trong thư mục home không được thực hiện.
EOF
)

var_6_2_9="6.2.9 Đảm bảo người dùng sở hữu thư mục home của chính họ"
flag=true
for i in `awk -F: '($1!~/(halt|sync|shutdown|nfsnobody)/ && $7!~/^(\/usr)?\/sbin\/nologin(\/)?$/ && $7!~/(\/usr)?\/bin\/false(\/)?$/){print $1":"$6}' /etc/passwd`; do
    user=$(echo "$i" | cut -d: -f1)
    dir=$(echo "$i" | cut -d: -f2)
    if [ ! -d "$dir" ]; then
        flag=false
        break
    else
        owner="$(stat -L -c "%U" "$dir")"
        if [ "$owner" != "$user" ] && [ "$owner" != "root" ]; then
            flag=false
            break
        fi
    fi
done
if [ "$flag" = false ]; then
    echo "$fail $var_6_2_9"
	echo "$rem_6_2_9" >>  $remediation_filename
else
	echo "$pass $var_6_2_9"
fi

############################################################################
rem_6_2_10=$(cat  <<  EOF 
================================================
6.2.10 Việc chỉnh sửa toàn cục cho thư mục của người dùng mà không báo trước có thể khiến người dùng không hài lòng. Bởi vậy, khuyến nghị tạo nên một chính sách theo dõi để báo cáo quyền file dot của người dùng và xác định hành động nên làm theo chính sách.
-----------------------------------------------
Tác động: Không tác động tới hệ thống.
EOF
)

var_6_2_10="6.2.10 Đảm bảo các file dot của người dùng không cấp quyền write cho group hoặc world-wide"
if [ $(find /home/ -name ".[A-Za-z0-9]*" -perm /g+w,o+w | wc -l) -ne 0 ]; then
	echo "$fail $var_6_2_10"
	echo "$rem_6_2_10" >>  $remediation_filename
else
	echo "$pass $var_6_2_10"
fi

############################################################################
rem_6_2_11=$(cat  <<  EOF 
================================================
6.2.11 Việc chỉnh sửa toàn cục cho thư mục của người dùng mà không báo trước có thể khiến người dùng không hài lòng. Bởi vậy, khuyến nghị tạo nên một chính sách theo dõi để báo cáo file .forward của người dùng và xác định hành động nên làm theo chính sách.
-----------------------------------------------
Tác động: Nếu có ngoại lệ phải được thêm vào trường hợp ngoại lệ.
EOF
)

var_6_2_11="6.2.11 Đảm bảo không người dùng nào có file .forward"
if [ $(find /home/ -type f -name "*.forward" 2> /dev/null | wc -l) -ne 0 ]; then
	echo "$fail $var_6_2_11"
	echo "$rem_6_2_11" >>  $remediation_filename
else
	echo "$pass $var_6_2_11"
fi

############################################################################
rem_6_2_12=$(cat  <<  EOF 
================================================
6.2.12 Việc chỉnh sửa toàn cục cho thư mục của người dùng mà không báo trước có thể khiến người dùng không hài lòng_ Bởi vậy, khuyến nghị tạo nên một chính sách theo dõi để báo cáo file .netrc của người dùng và xác định hành động nên làm theo chính sách.
-----------------------------------------------
Tác động: Nếu có ngoại lệ phải được thêm vào trường hợp ngoại lệ.
EOF
)

var_6_2_12="6.2.12 Đảm bảo không người dùng nào có file .netrc"
if [ $(find /home -name ".netrc" | wc -l) -ne 0 ]; then
	echo "$fail $var_6_2_12"
	echo "$rem_6_2_12" >>  $remediation_filename
else
	echo "$pass $var_6_2_12"
fi

############################################################################
rem_6_2_13=$(cat  <<  EOF 
================================================
6.2.13 Việc chỉnh sửa toàn cục cho thư mục của người dùng mà không báo trước có thể khiến người dùng không hài lòng. Bởi vậy, khuyến nghị tạo nên một chính sách theo dõi để báo cáo file .netrc của người dùng và xác định hành động nên làm theo chính sách.
-----------------------------------------------
Tác động: Nếu có ngoại lệ phải được thêm vào trường hợp ngoại lệ.
EOF
)

var_6_2_13="6.2.13 Đảm bảo file netrc của người dùng không cấp quyền cho group hoặc other"
if [ $(find /* -name ".netrc" -perm /g+w,o+w | wc -l) -ne 0 ]; then
	echo "$fail $var_6_2_13"
	echo "$rem_6_2_13" >>  $remediation_filename
else
	echo "$pass $var_6_2_13"
fi

############################################################################
rem_6_2_14=$(cat  <<  EOF 
================================================
6.2.14 Việc chỉnh sửa toàn cục cho thư mục của người dùng mà không báo trước có thể khiến người dùng không hài lòng. Bởi vậy, khuyến nghị tạo nên một chính sách theo dõi để báo cáo file .rhost của người dùng và xác định hành động nên làm theo chính sách.
-----------------------------------------------
Tác động: Nếu có ngoại lệ phải được thêm vào trường hợp ngoại lệ.
EOF
)

var_6_2_14="6.2.14 Đảm bảo không người dùng nào có file .rhosts"
if [ $(find /home -name ".rhosts" | wc -l) -ne 0 ]; then
	echo "$fail $var_6_2_14"
	echo "$rem_6_2_14" >>  $remediation_filename
else
	echo "$pass $var_6_2_14"
fi

############################################################################
rem_6_2_15=$(cat  <<  EOF 
================================================
6.2.15 Phân tích kết quả trả về ở phần Kiểm tra phía trên và thực hiện hành động phù hợp để chỉnh sửa bất kỳ khác biệt nào tìm thấy được.
-----------------------------------------------
Tác động: Không tác động tới hệ thống.
EOF
)

var_6_2_15="6.2.15 Đảm bảo mọi nhóm trong file /etc/passwd tồn tại trong file /etc/group"
count=0
for i in `awk -F: '$3>=1000 { print $4 }' /etc/passwd`; do
    if [ `grep -E "^.*?:[^:]*:$i:" /etc/group | wc -l` -eq 0 ]; then
        count=$((count+1))
    fi
done
if [ "$count" -ne "0" ]; then
	echo "$fail $var_6_2_15"
	echo "$rem_6_2_15" >>  $remediation_filename
else
	echo "$pass $var_6_2_15"
fi

############################################################################
rem_6_2_16=$(cat  <<  EOF 
================================================
6.2.16 Dựa theo kết quả từ phần Kiểm tra, tạo ra một UID độc nhất và kiểm tra toàn bộ file sở hữu bởi UID bị trùng để xác định các file đó thuộc về UID nào.
-----------------------------------------------
Tác động: Không tác động tới hệ thống.
EOF
)

var_6_2_16="6.2.16 Đảm bảo UID không bị lặp"
if [ $(awk -F: '$3>=1000 {print $3}' /etc/passwd | sort | uniq -c | awk '$1 > 1' | wc -l) -ne 0 ]; then
	echo "$fail $var_6_2_16"
	echo "$rem_6_2_16" >>  $remediation_filename
else
	echo "$pass $var_6_2_16"
fi

############################################################################
rem_6_2_17=$(cat  <<  EOF 
================================================
6.2.17 Dựa theo kết quả từ phần Kiểm tra, tạo ra một GID độc nhất và kiểm tra toàn bộ file sở hữu bởi GID bị trùng để xác định các file đó thuộc về GID nào.
 Có thể sử dụng lệnh grpck để kiểm tra các mâu thuẫn khác trong file /etc/group.
-----------------------------------------------
Tác động: Không tác động tới hệ thống.
EOF
)

var_6_2_17="6.2.17 Đảm bảo GID không bị lặp"
if [ $(awk -F: '$3>=1000 {print $3}' /etc/group | sort | uniq -c | awk '$1 > 1' | wc -l) -ne 0 ]; then
	echo "$fail $var_6_2_17"
	echo "$rem_6_2_17" >>  $remediation_filename
else
	echo "$pass $var_6_2_17"
fi

############################################################################
rem_6_2_18=$(cat  <<  EOF 
================================================
6.2.18 Dựa theo kết quả ở phần Kiểm tra, tạo ra một tên người dùng độc nhất cho người dùng. Quyền sở hữu của người dùng ở file sẽ tự động cập nhật thay đổi nếu người dùng có UID độc nhất.
-----------------------------------------------
Tác động: Không tác động tới hệ thống.
EOF
)

var_6_2_18="6.2.18 Đảm bảo tên người dùng không bị lặp"
if [ $(awk -F: '$3>=1000 {print $1}' /etc/passwd | sort -n | uniq -c | awk '$1 > 1' | wc -l) -ne 0 ]; then
	echo "$fail $var_6_2_18"
	echo "$rem_6_2_18" >>  $remediation_filename
else
	echo "$pass $var_6_2_18"
fi

############################################################################
rem_6_2_19=$(cat  <<  EOF 
================================================
6.2.19 Dựa theo kết quả ở phần Kiểm tra, tạo ra một tên group độc nhất cho người dùng. Quyền sở hữu của group ở file sẽ tự động cập nhật thay đổi nếu group có GID độc nhất.
-----------------------------------------------
Tác động: Không tác động tới hệ thống.
EOF
)

var_6_2_19="6.2.19 Đảm bảo tên group không bị lặp"
if [ $(awk -F: '$3>=1000 {print $1}' /etc/group | sort -n | uniq -c | awk '$1 > 1' | wc -l) -ne 0 ]; then
	echo "$fail $var_6_2_19"
	echo "$rem_6_2_19" >>  $remediation_filename
else
	echo "$pass $var_6_2_19"
fi
echo ""
echo ""
echo "#########################################################################"
echo "############################## REMEDIATION ##############################"
echo "#########################################################################"
echo ""
cat $remediation_filename
rm -fr $remediation_filename
