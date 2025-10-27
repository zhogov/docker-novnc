FROM alpine:3.22.1

ENV NOVNC_TAG="v1.6.0"

ENV WEBSOCKIFY_TAG="v0.13.0"

RUN apk --no-cache --update --upgrade add \
        python3 \
        python3-dev \
        gfortran \
        py-pip \
        build-base \
        procps \
        git

RUN pip install --no-cache-dir --break-system-packages numpy

RUN git config --global advice.detachedHead false && \
    git clone https://github.com/novnc/noVNC --branch ${NOVNC_TAG} /root/noVNC && \
    git clone https://github.com/novnc/websockify --branch ${WEBSOCKIFY_TAG} /root/noVNC/utils/websockify && \
    rm -rf /root/noVNC/.git && \
    rm -rf root/noVNC/utils/websockify/.git

RUN cp /root/noVNC/vnc.html /root/noVNC/index.html

ENTRYPOINT [ "sh", "-c", "/root/noVNC/utils/novnc_proxy --vnc 172.17.0.1:5900 --listen 8081" ]