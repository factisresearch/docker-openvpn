# Original credit: https://github.com/jpetazzo/dockvpn

# Leaner build then Ubunutu
FROM debian:jessie

MAINTAINER Kyle Manna <kyle@kylemanna.com>

RUN apt-get update && apt-get install -y eurephia iptables git-core vim

# Update checkout to use tags when v3.0 is finally released
RUN git clone https://github.com/OpenVPN/easy-rsa.git /usr/local/share/easy-rsa
RUN cd /usr/local/share/easy-rsa && git checkout -b tested 89f369c5bbd13fbf0da2ea6361632c244e8af532
RUN ln -s /usr/local/share/easy-rsa/easyrsa3/easyrsa /usr/local/bin

# Initialize eurephia database
RUN ln -s /var/lib/eurephia ~/.eurephia

# Create missing directories
RUN mkdir -p /var/lib/openvpn
RUN mkdir -p /var/lib/eurephia

# Needed by scripts
ENV OPENVPN /etc/openvpn
ENV EASYRSA /usr/local/share/easy-rsa/easyrsa3
ENV EASYRSA_PKI $OPENVPN/pki
ENV EASYRSA_VARS_FILE $OPENVPN/vars

VOLUME ["/etc/openvpn", "/var/lib/eurephia", "/var/lib/openvpn"]

# Internally uses port 1194, remap using docker
EXPOSE 1194/udp

WORKDIR /etc/openvpn
CMD ["ovpn_run"]

ADD ./bin /usr/local/bin
RUN chmod a+x /usr/local/bin/*
