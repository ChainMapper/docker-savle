FROM chainmapper/walletbase-xenial-build as builder

ENV GIT_COIN_URL    https://github.com/savleproj/savle-source
ENV GIT_COIN_NAME   savle   

RUN	git clone $GIT_COIN_URL $GIT_COIN_NAME \
	&& cd $GIT_COIN_NAME \
	&& chmod +x share/genbuild.sh \
	&& chmod +x src/leveldb/build_detect_platform \
	&& cd src \
	&& mkdir obj \
	&& mkdir obj/support \
	&& mkdir obj/crypto \
	&& mkdir obj/zerocoin \
	&& make -f makefile.unix "USE_UPNP=-" \
	&& cp savled /usr/local/bin \
	&& cd / && rm -rf /$GIT_COIN_NAME
	
FROM chainmapper/walletbase-xenial as runtime

COPY --from=builder /usr/local/bin /usr/local/bin

RUN mkdir /data
ENV HOME /data

#rpc port
EXPOSE 6666

COPY start.sh /start.sh
COPY gen_config.sh /gen_config.sh
COPY wallet.sh /wallet.sh
RUN chmod 777 /*.sh
CMD /start.sh savle.conf SAVLE savled