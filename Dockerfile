FROM centos:latest

# 作成者情報
MAINTAINER mori <frostnday@gmail.com>

# php
RUN yum install -y https://dl.fedoraproject.org/pub/epel/7/x86_64/Packages/e/epel-release-7-11.noarch.rpm http://rpms.famillecollet.com/enterprise/7/remi/x86_64/remi-release-7.4-1.el7.remi.noarch.rpm
RUN rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-7 /etc/pki/rpm-gpg/RPM-GPG-KEY-remi /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7
RUN yum-config-manager --enable remi,remi-php71 && yum clean all
RUN yum install -y git php php-gd php-intl php-fpm php-tidy php-pdo php-cli php-process php-xml php-mysql php-mbstring php-bcmath php-pecl-imagick php-pecl-zip php-pecl-xdebug vim-enhanced
RUN yum update -y

# composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin

# nginx
RUN yum install -y http://nginx.org/packages/centos/7/noarch/RPMS/nginx-release-centos-7-0.el7.ngx.noarch.rpm
RUN yum install -y --enablerepo=nginx nginx
RUN nginx -t
RUN chmod -R 755 /var/www/

# 設定ファイル上書き
RUN curl https://raw.githubusercontent.com/itmori/docker-file/master/nginx.conf > /etc/nginx/nginx.conf
RUN curl https://raw.githubusercontent.com/itmori/docker-file/master/www.conf > /etc/php-fpm.d/www.conf
RUN curl https://raw.githubusercontent.com/itmori/docker-file/master/15-xdebug.ini > /etc/php.d/15-xdebug.ini
RUN curl https://raw.githubusercontent.com/itmori/docker-file/master/vimrc > /etc/vimrc

# 自動起動
RUN chkconfig nginx on
RUN chkconfig php-fpm on

# TimeZone設定
RUN rm -rf /etc/localtime
RUN cp /usr/share/zoneinfo/Japan /etc/localtime
RUN echo 'date.timezone=Asia/Tokyo' > /etc/php.d/00-docker-php-date-timezone.ini
