# Open Monitoring Distribution
## Version: 0.1
FROM phusion/baseimage
#MAINTAINER Gustavo Lichti <gustavo.lichti@trikan.com.br>
MAINTAINER xforty technologies "xforty.com"

ENV DEBIAN_FRONTEND noninteractive

LABEL org.freenas.interactive="false"                                   \
      org.freenas.version="1"                                           \
      org.freenas.upgradeable="true"                                    \
      org.freenas.expose-ports-at-host="true"                           \
      org.freenas.autostart="true"                                      \
      org.freenas.web-ui-protocol="http"                                \
      org.freenas.web-ui-port=                                       \
      org.freenas.web-ui-path="/cmk"                                    \
      org.freenas.port-mappings="80:80/tcp,443:443/tcp,22:22/tcp,4730:4730/tcp,5666:5666/tcp" \
      org.freenas.volumes="[                                            \
          {                                                             \
              \"name\": \"/opt/omd/sites/cmk/etc\",                     \
              \"descr\": \"CMK site /etc\"                              \
          },                                                            \
          {                                                             \
              \"name\": \"/opt/omd/sites/cmk/var\",                     \
              \"descr\": \"CMK site /var\"                              \
          },                                                            \
          {                                                             \
              \"name\": \"/opt/omd/sites/cmk/local\",                   \
              \"descr\": \"CMK site /local\"                            \
          }                                                             \
      ]"                                                                \
       org.freenas.settings="[                                          \
          {                                                             \
              \"env\": \"PUID\",                                        \
              \"descr\": \"UserID - Keep as 1000\",                     \
              \"optional\": false                                       \
          },                                                            \
          {                                                             \
              \"env\": \"PGID\",                                        \
              \"descr\": \"GroupID - Keep as 1000\",                    \
              \"optional\": false                                       \
          },                                                            \
          {                                                             \
              \"env\": \"TZ\",                                          \
              \"descr\": \"Timezone - eg Europe/London\",               \
              \"optional\": true                                        \
          }                                                             \
      ]"


# Make sure package repository is up to date
RUN apt-get update
RUN apt-get upgrade -y

# Install OMD, see http://labs.consol.de/OMD/
RUN gpg --keyserver keys.gnupg.net --recv-keys F8C1CA08A57B9ED7
RUN gpg --armor --export F8C1CA08A57B9ED7 | apt-key add -
RUN echo "deb http://labs.consol.de/repo/stable/ubuntu trusty main" >> /etc/apt/sources.list
RUN apt-get update
RUN apt-get install -y libpython2.7 omd locales tzdata

#Set timezone
RUN echo "America/New_York" > /etc/timezone; dpkg-reconfigure tzdata
#Set locale
RUN export LANGUAGE=en_US.UTF-8; export LANG=en_US.UTF-8; export LC_ALL=en_US.UTF-8; locale-gen en_US.UTF-8; dpkg-reconfigure locales

# Set up a default site
RUN omd create cmk
# We don't want TMPFS as it requires higher privileges
RUN omd config default set TMPFS off
# Accept connections on any IP address, since we get a random one
RUN omd config default set APACHE_TCP_ADDR 0.0.0.0

# Add watchdog script
ADD apache.sh /etc/service/apache/run
ADD omd.sh /etc/service/omd/run
