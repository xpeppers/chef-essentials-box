FROM centos:6.7

RUN yum install -y sudo openssh-server openssh-clients which curl
RUN yum install -y tree git nano vim emacs httpd
RUN curl -L https://www.chef.io/chef/install.sh | bash

RUN BUSSER_ROOT=/opt/busser GEM_HOME=/opt/busser/gems GEM_PATH=/opt/busser/gems GEM_CACHE=/opt/busser/gems/cache /opt/chef/embedded/bin/gem install busser --no-rdoc --no-ri
RUN BUSSER_ROOT=/opt/busser GEM_HOME=/opt/busser/gems GEM_PATH=/opt/busser/gems GEM_CACHE=/opt/busser/gems/cache /opt/chef/embedded/bin/gem install serverspec --no-rdoc --no-ri
RUN BUSSER_ROOT=/opt/busser GEM_HOME=/opt/busser/gems GEM_PATH=/opt/busser/gems GEM_CACHE=/opt/busser/gems/cache /opt/busser/gems/bin/busser setup
RUN BUSSER_ROOT=/opt/busser GEM_HOME=/opt/busser/gems GEM_PATH=/opt/busser/gems GEM_CACHE=/opt/busser/gems/cache /opt/busser/gems/bin/busser plugin install busser-serverspec
