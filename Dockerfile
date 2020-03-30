FROM debian:stretch

RUN apt update -y
RUN apt install git make cmake wget g++ libpng-dev -y

ENV TMP /tmp
ENV WLA_TMP_SOURCE_PATH $TMP/wla-dx
ENV WLA_TMP_ROOT_BUILD_PATH $WLA_TMP_SOURCE_PATH/build-wla
ENV MAKE_TYPE Unix Makefiles
ENV PCX2SNES_PATH /opt/pcx2snes
ENV CC65_PATH /opt/cc65

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

WORKDIR $TMP
#cc65
RUN mkdir -p $CC65_PATH
RUN git clone https://github.com/cc65/cc65.git $CC65_PATH
RUN cd $CC65_PATH && make && make avail

WORKDIR $TMP
#pvsneslib
#bin2txt
RUN git clone https://github.com/fabiosoaza/pvsneslib.git
RUN cd /tmp/pvsneslib && git checkout fix_linux_issues && cd tools/bin2txt/ && make &&  cp bin2txt.exe /usr/local/bin/bin2txt
#constify
RUN cd /tmp/pvsneslib && git checkout fix_linux_issues && cd tools/constify/ && make &&  cp constify.exe /usr/local/bin/constify

#gfx2snes
RUN cd /tmp/pvsneslib  && git checkout fix_linux_issues && cd tools/gfx2snes/ && make &&  cp gfx2snes.exe /usr/local/bin/gfx2snes

#smconv
RUN cd /tmp/pvsneslib  && git checkout fix_linux_issues && cd tools/smconv/ && make &&  cp smconv.exe /usr/local/bin/smconv

#snestools
RUN cd /tmp/pvsneslib  && git checkout fix_linux_issues && cd tools/snestools/ && make &&  cp snestools.exe /usr/local/bin/snestools

CMD sleep 600 