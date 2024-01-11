from ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive 

RUN apt-get update && \
	apt-get dist-upgrade -y && \
	apt-get install -y python3 python3-pip wget libssl-dev && \
	wget https://github.com/XapaJIaMnu/translateLocally/releases/download/latest/translateLocally-v0.0.2+3cbe86d-Ubuntu-22.04.AVX.deb && \
	apt-get install -y  ./translateLocally-v0.0.2+3cbe86d-Ubuntu-22.04.AVX.deb && rm -f ./translateLocally-v0.0.2+3cbe86d-Ubuntu-22.04.AVX.deb && \
	apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /translator
COPY /translator/* /translator/

RUN pip3 install -r requirements.txt

ENV MODEL=enru
ENV MODSL=en-ru

RUN mkdir ${MODEL} && \
    cd ${MODEL} && \
    wget -O vocab.${MODEL}.spm.gz http://bergamot.s3.amazonaws.com/models/${MODEL}/vocab.${MODEL}.spm && \
    wget -O lex.50.50.${MODEL}.s2t.bin.gz http://bergamot.s3.amazonaws.com/models/${MODEL}/lex.50.50.${MODEL}.s2t.bin && \
    wget -O model.${MODEL}.intgemm.alphas.bin.gz http://bergamot.s3.amazonaws.com/models/${MODEL}/model.${MODEL}.intgemm.alphas.bin && \
    gunzip vocab.${MODEL}.spm.gz && \
    gunzip lex.50.50.${MODEL}.s2t.bin.gz && \
    gunzip model.${MODEL}.intgemm.alphas.bin.gz && \
    cat ../config.intgemm8bitalpha.tpl | sed "s|%MODEL%|${MODEL}|g" > config.intgemm8bitalpha.yml && \
    mv ../modelMeta.json modelMeta.json && \
    cat ../model_info.tpl | sed "s|%MODSL%|${MODSL}|g" > model_info.json && \
	cd .. && rm -f *.tpl

RUN useradd -m -s /bin/bash -u 1000 -U translator

USER translator

ENTRYPOINT [ "uvicorn", "api:app", "--host", "0.0.0.0", "--port", "3000", "--workers", "6" ]
