FROM python:latest

MAINTAINER aa66609@gmail.com

# WeasyPrint latest
RUN apt-get install libcairo2 libpango-1.0-0 libpangocairo-1.0-0 libgdk-pixbuf2.0-0 libffi-dev shared-mime-info \
    && pip install cairocffi WeasyPrint

# fix phantomjs can't find openssl error
ENV OPENSSL_CONF=/etc/ssl/
# phantomjs 2.1.1
RUN export PHANTOM_JS="phantomjs-2.1.1-linux-x86_64" \
    && wget https://bitbucket.org/ariya/phantomjs/downloads/$PHANTOM_JS.tar.bz2 \
    && tar xvjf $PHANTOM_JS.tar.bz2 -C /usr/local/share \
    && ln -s /usr/local/share/$PHANTOM_JS/bin/phantomjs /usr/local/bin \
    && rm $PHANTOM_JS.tar.bz2

# ghostscript-9.52
RUN export GHOST_SCRIPT="ghostscript-9.52" && GS_VER="gs952" \
    && wget https://github.com/ArtifexSoftware/ghostpdl-downloads/releases/download/$GS_VER/$GHOST_SCRIPT.tar.gz \
    && tar zxvf $GHOST_SCRIPT.tar.gz \
    && cd $GHOST_SCRIPT \
    && ./configure --prefix=/usr \
    && make all \
    && make install \
    && cd .. && rm -r $GHOST_SCRIPT && rm $GHOST_SCRIPT.tar.gz

# check install ok
RUN gs -v && phantomjs -v && weasyprint --version

CMD ["bin/sh"]