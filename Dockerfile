FROM debian:stretch

RUN apt update -y
RUN apt install git make cmake wget g++ libpng-dev -y

ENV TMP /tmp
ENV WLA_TMP_SOURCE_PATH $TMP/wla-dx
ENV WLA_TMP_ROOT_BUILD_PATH $WLA_TMP_SOURCE_PATH/build-wla
ENV MAKE_TYPE Unix Makefiles
ENV PCX2SNES_PATH /opt/pcx2snes

WORKDIR $TMP

#wla-dx
RUN git clone https://github.com/vhelin/wla-dx.git $WLA_TMP_SOURCE_PATH
RUN mkdir -p $WLA_TMP_ROOT_BUILD_PATH/
RUN chmod -R 0755 $WLA_TMP_ROOT_BUILD_PATH
RUN cd $WLA_TMP_ROOT_BUILD_PATH
RUN cmake -G "$MAKE_TYPE" "$WLA_TMP_SOURCE_PATH"
RUN make && make install

#pcx2snes
COPY MakeFilePcx2Snes $TMP
RUN wget https://raw.githubusercontent.com/gilligan/snesdev/master/tools/pcx2snes/pcx2snes.c
RUN make -f MakeFilePcx2Snes
RUN mkdir -p $PCX2SNES_PATH
RUN mv pcx2snes $PCX2SNES_PATH/pcx2snes
RUN ln -s $PCX2SNES_PATH/pcx2snes /usr/local/bin

WORKDIR $TMP

#superfamicheck
RUN git clone https://github.com/Optiroc/SuperFamicheck.git
RUN cd SuperFamicheck && make
RUN cp /tmp/SuperFamicheck/bin/superfamicheck /usr/bin/superfamicheck

WORKDIR $TMP

#png2snes
RUN git clone https://github.com/NewLunarFire/png2snes.git
RUN cd png2snes && make
RUN cp /tmp/png2snes/png2snes /usr/bin/png2snes
CMD sleep 600 