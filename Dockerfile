FROM quay.io/kreuzwerker/aida.sessionhub
MAINTAINER carsten.karl@kreuzwerker.de
ENV DEBIAN_FRONTEND noninteractive
ENV HOME /root
ENV GOPATH /root/.go
# installing prereq of admin-ui
RUN apt-get update -qq
RUN apt-get install -qqy mongodb ruby bundler libssl-dev
# building admin-ui
WORKDIR /opt/kreuzwerker/sessionhub/ruby
RUN /usr/bin/bundle install
# prepare for mongo DB, will be mounted from host
RUN mkdir -p /data/db
# prepare admin-ui config, will be mounted from host
RUN rm -rf /opt/kreuzwerker/sessionhub/ruby/config && mkdir -p /opt/kreuzwerker/sessionhub/ruby/config
# Cleaning up
RUN apt-get -qqy autoremove git libssl-dev
RUN apt-get -qq clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
# configuring services
ADD docker/etc/service/mongodb/run /etc/service/mongodb/run
ADD docker/etc/service/sessionhub-admin-ui/run /etc/service/sessionhub-admin-ui/run
EXPOSE 5005:5005
EXPOSE 443:443
CMD [ "/sbin/my_init" ]
