#
# Provide SSH service via openSSH
#
# VERSION               2.0.1
#
FROM alpine:3.8

# Install open-ssh server
RUN apk add --no-cache openssh-server rsync openssh

# Reconfigure the SSH to accept login as root, with the specified password
# RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config
# RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# Lets enable root login
RUN echo "" >> /etc/ssh/sshd_config && echo "PermitRootLogin yes" >> /etc/ssh/sshd_config

# Environment variable, used to setup root password (instead of having a fixed one)
ENV SSH_USER root
ENV SSH_PASS password_pls_change

# Expose port 22 (for SSH)
EXPOSE 22

# Copy over entrypoint file
COPY entry.sh /entry.sh

# Logging of entrypoint file into autobuilds
RUN chmod +x /entry.sh && cat /entry.sh

# Lets setup entry, and command arguments
ENTRYPOINT [ "/entry.sh" ]
CMD ["/usr/sbin/sshd", "-D", "-e", "-f", "/etc/ssh/sshd_config"]