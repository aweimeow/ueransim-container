FROM adoptopenjdk:11-jdk-hotspot
WORKDIR /
RUN apt update && apt install git make g++ maven libsctp-dev lksctp-tools -y
RUN git clone https://github.com/aligungr/UERANSIM/ --depth 1
WORKDIR /UERANSIM
RUN ./nr-build --allow-root

FROM adoptopenjdk:11-jre-hotspot
RUN apt update && apt install libsctp1 lksctp-tools iproute2 -y
WORKDIR /root/
COPY --from=0 /UERANSIM/nr-agent /root/
COPY --from=0 /UERANSIM/nr-cli /root/
COPY --from=0 /UERANSIM/build/ /root/build/
COPY --from=0 /UERANSIM/config/ /root/config/
RUN ln -s /root/nr-cli /usr/local/bin

LABEL maintainer="Wei-Yu Chen <weiyu_chen@edge-core.com>" \
      ueransim_commit_id="b146a85" \
      free5gc_version="3.0.4"

CMD ["./nr-agent"]
