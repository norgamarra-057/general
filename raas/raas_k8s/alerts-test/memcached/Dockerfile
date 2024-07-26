FROM debian

COPY ./fake /usr/local/bin/
COPY ./res.tpl /etc/alerts-test/res.tpl

ENTRYPOINT ["/usr/local/bin/fake"]
