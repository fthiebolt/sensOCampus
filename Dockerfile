#
# sensOCampus agent
#
# This application grabs raw weather data from the Toulouse
# metropole weather station, process them and republish in
# proper topics.
#
# F.Thiebolt    feb.21  initial release
#

# Fedora 33 at the time of writing
FROM fedora:latest
MAINTAINER "Francois <thiebolt@irit.fr>"

# Switch to bash as default shell
SHELL [ "/bin/bash", "-c" ]

# Build ARGS
ARG APP="/app"

# Runtime & Build-time args
# Location of files to add to the container
# Note this <relative_path> to the build env @ host
ENV DOCKYARD="/dockyard" \
    DESTDIR="/opt/app"

# Switch to root user to enable installation (default)
#USER root

# Copy configuration directory
COPY ${DOCKYARD} ${DOCKYARD}

# Copy application directory
COPY ${APP} ${DESTDIR}

# password generation:
# python -c 'import crypt; print(crypt.crypt("passwd", crypt.mksalt(crypt.METHOD_SHA512)))'

#
# Set-up ssh environnement / password / authorized-key + file copy
RUN echo -e "Starting setup ..." \
    # root passwd
    && echo 'root:$6$VmrFi2tp8ajCOxME$GSYucx0NSUo8zAdQnPPiw9khx1JQ1HvMl.1/9CRizZWAGrf9CHRIyaAF.t8/Di0yGlLOkBSdwjMlpbX5aLPy70' | chpasswd -e \
    # SSH authorized keys
    && cp -af ${DOCKYARD}/root / \
    && mkdir -p /root/.ssh \
    && cp -af ${DOCKYARD}/authorized_keys /root/.ssh/ \
    && chmod 600 /root/.ssh/authorized_keys \
    && chmod g-w /root \
    # custom motd message
    && cp -af ${DOCKYARD}/myMotd /etc/motd.d/ \
    && chmod 644 /etc/motd.d/myMotd \
    # Supervisor setup
    && cp -af ${DOCKYARD}/supervisord.d /etc \
    # system stuff
    && dnf -y --nogpgcheck install \
        git \
        gcc \
        procps \
        tmux \
        bind-utils \
        findutils \
        openssh-server \
        openssh-clients \
        supervisor \
        python3-pip \
        python3-psycopg2 \
        uwsgi \
        uwsgi-plugin-python3 \
        mailcap \
        python3-devel \
        python3-ipython \
        sqlite \
#   && dnf -y --nogpgcheck --allowerasing upgrade \
    && dnf -y --nogpgcheck install vim \
    && dnf clean all \
    # Supervisor setup
    && cp -af /${DOCKYARD}/supervisord.d /etc \
    # [oct.20] fix for 'unable to open HTTP server'
    && mkdir -p /run/supervisor \
    # SSH server setup
    && mkdir -p /var/run/sshd \
    && ssh-keygen -A \
    # app. specific requirements
    && pip3 install -r ${DOCKYARD}/requirements.txt

#
# Ports for sshd and uwsgi application
EXPOSE 22 8000 8042

# CMD
CMD [ "/usr/bin/supervisord", "-n" ]
#, "--loglevel=debug"]

