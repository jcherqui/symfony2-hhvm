FROM debian:wheezy

ENV DEBIAN_FRONTEND noninteractive
ENV INITRD No

# Sources
RUN echo "deb http://ftp.fr.debian.org/debian wheezy main" > /etc/apt/sources.list
RUN echo "deb http://ftp.fr.debian.org/debian wheezy-updates main"  >> /etc/apt/sources.list
RUN echo "deb http://security.debian.org wheezy/updates main" >> /etc/apt/sources.list

# HHVM source
RUN apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0x5a16e7281be7a449
RUN echo deb http://dl.hhvm.com/debian wheezy main | tee /etc/apt/sources.list.d/hhvm.list

# Install
RUN \
   apt-get update --fix-missing && \
   apt-get install -y apt-utils debconf-utils dialog locales && \
   apt-get install -y hhvm nginx wget git python build-essential curl bzip2 supervisor vim && \
   apt-get clean -y && \
   apt-get autoclean -y && \
   apt-get autoremove -y && \
   rm -rf /tmp/* && \
   rm -rf /var/lib/{apt,dpkg,cache,log,tmp}/*

# Install php tools (composer / phpunit)
RUN cd $HOME && \
    wget http://getcomposer.org/composer.phar && \
    chmod +x composer.phar && \
    mv composer.phar /usr/local/bin/composer && \
    wget https://phar.phpunit.de/phpunit.phar && \
    chmod +x phpunit.phar && \
    mv phpunit.phar /usr/local/bin/phpunit

# hhvm
RUN echo 'hhvm.libxml.ext_entity_whitelist = file,http' >> /etc/hhvm/php.ini
RUN echo 'hhvm.libxml.ext_entity_whitelist = file,http' >> /etc/hhvm/server.ini
RUN echo 'hhvm.http.slow_query_threshold = 30000' >> /etc/hhvm/php.ini
RUN echo 'xdebug.enable=1' >> /etc/hhvm/php.ini
RUN echo 'date.timezone = "Europe/Paris"' >> /etc/hhvm/php.ini
RUN echo 'date.timezone = "Europe/Paris"' >> /etc/hhvm/server.ini

# nginx
RUN sed -i -e "s/worker_processes\s*4/worker_processes 1/g" /etc/nginx/nginx.conf
RUN sed -i -e "s/worker_connections 768/worker_connections 1024/g" /etc/nginx/nginx.conf
COPY nginx.conf /etc/nginx/sites-enabled/default

# supervisor
RUN mkdir -p /var/log/supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

EXPOSE 80
CMD ["/usr/bin/supervisord", "-n"]
WORKDIR /var/www/
