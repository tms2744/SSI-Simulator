# ubuntu Dockerfile
FROM ubuntu

RUN apt update && apt install iproute2 openssh-server sudo python3 coreutils sshpass tcpdump vim tmux tmuxinator netcat ncat pip docker net-tools -y
RUN pip install paramiko pexpect
# ---------user configuration
RUN echo 'root:password' | chpasswd
RUN passwd -d root

# --------ssh session configuration
EXPOSE 22
RUN service ssh start
RUN mkdir ~/.ssh
RUN chmod 700 ~/.ssh
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config
RUN sed -i 's/#PermitEmptyPasswords no/PermitEmptyPasswords yes/g' /etc/ssh/sshd_config
RUN echo 'PubkeyAuthentication yes' >> /etc/ssh/sshd_config
RUN touch ~/.ssh/authorized_keys
COPY config /root/.ssh/
RUN chmod 600 ~/.ssh/config
RUN service ssh restart

# -------tmux session configuration
# SHELL ["/bin/bash", "-c"]
# COPY tmux.sh /usr/local/sbin/
# RUN chmod 700 /usr/local/sbin/tmux.sh

# --------docker-external.sh 
COPY internal.py /opt/
COPY launch.sh /opt/
#COPY net-start.sh /opt/
#COPY nt.sh /opt/
COPY listener.sh /opt/
#COPY ssh-connect.sh /opt/
#RUN chmod 700 /opt/tmux.sh
RUN chmod +x /opt/launch.sh
#RUN chmod +x /opt/nt.sh
RUN chmod +x /opt/internal.py
COPY cmd.txt /opt/
#COPY docker-internal.sh /opt/
#RUN chmod +x /opt/docker-internal.sh
RUN bash /opt/listner.sh &
#CMD ["/opt/docker-internal.sh"]



# commands to build containers:
# sudo docker-compose up --build
