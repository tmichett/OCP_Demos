FROM ubi8/ubi:8.4

MAINTAINER Your Name <tmichett@redhat.com>

# Environment variable for Apache Port
ENV PORT 8080

RUN yum install -y httpd && \
    yum clean all

# Change configuration of Apache WS to listen on the port specified as an environment variable in the Containerfile

RUN sed -ri -e "/^Listen 80/c\Listen ${PORT}" /etc/httpd/conf/httpd.conf && \
    chown -R apache:apache /etc/httpd/logs/ && \
    chown -R apache:apache /run/httpd/

RUN mkdir /var/www/html/images

USER apache

# Expose the custom port that you provided in the ENV var
EXPOSE ${PORT}

# Demo to simulate new image being built from pipeline
# Copy all files under src/ folder to Apache DocumentRoot (/var/www/html)
ADD http://github.com/tmichett/index.html /var/www/html/ && \
ADD http://github.com/tmichett/rht_training_logo.png

# Start Apache in the foreground
CMD ["httpd", "-D", "FOREGROUND"]
