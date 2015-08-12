FROM centos:7

# prerequisites for the Endpoint Manager CentOS patch application

RUN yum -y install \
  bzip2 \
  tar && \
  yum clean all

# install the bes client

# BES Version so it can be modified at runtime
ENV BES_VERSION=9.2.5.130

ENV AGENT_DOWNLOAD_URL=http://software.bigfix.com/download/bes/92/BESAgent-$BES_VERSION-rhe5.x86_64.rpm
RUN mkdir -p /etc/opt/BESClient && \
  curl $AGENT_DOWNLOAD_URL > /tmp/BESAgent.rpm && \
  rpm -ivh /tmp/BESAgent.rpm

# alternatively copy it from the host
#COPY ./BESAgent.rpm /tmp/BESAgent.rpm
#RUN rpm -ivh /tmp/BESAgent.rpm

# configure client to use command polling
# use \\\E to output the \E of \EnterpriseClient with echo's -e option

RUN echo -e \
    "[Software\BigFix\\\EnterpriseClient\Settings\Client\_BESClient_Comm_CommandPollIntervalSeconds] \nvalue = 300 \neffective date = Thu,%2001%20Jan%202015%2000:00:00%20+0000" \
    >> /var/opt/BESClient/besclient.config.default && \
  echo -e "[Software\BigFix\\\EnterpriseClient\Settings\Client\_BESClient_Comm_CommandPollEnable] \nvalue = 1 \neffective date = Thu,%2001%20Jan%202015%2000:00:00%20+0000" \
    >> /var/opt/BESClient/besclient.config.default
# automatic relay selection

RUN echo -e \
    "[Software\BigFix\\\EnterpriseClient\Settings\Client\__RelaySelect_Automatic] \nvalue = 1 \neffective date = Thu,%2001%20Jan%202015%2000:00:00%20+0000" \
    >> /var/opt/BESClient/besclient.config.default

# cpu usage.  Use 10,480 for 1-2%.  Use 2,500 for < .5%
RUN echo -e \
    "[Software\BigFix\\\EnterpriseClient\Settings\Client\_BESClient_Resource_WorkIdle] \nvalue = 2 \neffective date = Thu,%2001%20Jan%202015%2000:00:00%20+0000" \
    >> /var/opt/BESClient/besclient.config.default && \
  echo -e \
    "[Software\BigFix\\\EnterpriseClient\Settings\Client\_BESClient_Resource_SleepIdle] \nvalue = 500 \neffective date = Thu,%2001%20Jan%202015%2000:00:00%20+0000" \
    >> /var/opt/BESClient/besclient.config.default

# install an endpoint manager instance specific masthead

ENV ROOT_SERVER=rootserver.bigfix.com:52311

# alternatively copy masthead from the host
#COPY ./actionsite.afxm /etc/opt/BESClient/actionsite.afxm
RUN curl -k https://$ROOT_SERVER/masthead/masthead.afxm > /etc/opt/BESClient/actionsite.afxm

# run endpoint manager from script so it can be restarted
COPY ./bes-cmd.sh /
RUN chmod u+x /bes-cmd.sh
CMD ["/bes-cmd.sh"]