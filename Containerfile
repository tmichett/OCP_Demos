FROM registry.access.redhat.com/ubi8/ubi:latest

MAINTAINER Your Name <tmichett@redhat.com>

# Environment variable for Apache Port
ENV PORT 8080

RUN dnf install -y httpd && \
    dnf clean all

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
ADD https://github.com/tmichett/OCP_Demos/blob/main/Web_HTML/index.html /var/www/html/ && \
ADD https://github.com/tmichett/OCP_Demos/blob/main/Web_HTML/images/rht_training_logo.png /var/www/html/images

# Start Apache in the foreground
CMD ["httpd", "-D", "FOREGROUND"]
