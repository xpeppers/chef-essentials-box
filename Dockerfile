FROM centos:6.7

RUN yum install -y sudo openssh-server openssh-clients which curl
RUN yum install -y tree git nano vim emacs httpd
RUN curl -L https://www.chef.io/chef/install.sh | bash

ENV BUSSER_ROOT /tmp/verifier

RUN GEM_HOME=$BUSSER_ROOT/gems GEM_PATH=$BUSSER_ROOT/gems GEM_CACHE=$BUSSER_ROOT/gems/cache /opt/chef/embedded/bin/gem install busser --no-rdoc --no-ri
RUN GEM_HOME=$BUSSER_ROOT/gems GEM_PATH=$BUSSER_ROOT/gems GEM_CACHE=$BUSSER_ROOT/gems/cache /opt/chef/embedded/bin/gem install serverspec --no-rdoc --no-ri
RUN GEM_HOME=$BUSSER_ROOT/gems GEM_PATH=$BUSSER_ROOT/gems GEM_CACHE=$BUSSER_ROOT/gems/cache $BUSSER_ROOT/gems/bin/busser setup
RUN GEM_HOME=$BUSSER_ROOT/gems GEM_PATH=$BUSSER_ROOT/gems GEM_CACHE=$BUSSER_ROOT/gems/cache $BUSSER_ROOT/gems/bin/busser plugin install busser-serverspec
RUN chmod -R 775 $BUSSER_ROOT

RUN echo -e '#!/bin/sh\n/usr/bin/yum --disablerepo=* $@ || true' >> /usr/local/bin/yum
RUN chmod 775 /usr/local/bin/yum
