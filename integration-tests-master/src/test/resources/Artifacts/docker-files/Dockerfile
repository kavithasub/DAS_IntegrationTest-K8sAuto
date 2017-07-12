############################################################
# Dockerfile to build auto container images
# Based on Ubuntu
############################################################
MAINTAINER Kavitha
FROM dockerhub.private.wso2.com/kavitha-dasc5-integration:4.0.0

#print echo
RUN echo "changes are processing"
#RUN docker1.sh

COPY init.sh /usr/local/bin/init.sh
RUN chmod +x /usr/local/bin/init.sh

# Docker Entry Point
ENTRYPOINT ["/usr/local/bin/init.sh"]