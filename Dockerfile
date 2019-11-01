FROM openjdk:8-jre

MAINTAINER Headspace Technologies <headspacetech.com>

RUN apt-get update && apt-get install -y sudo ant python && apt-get clean

ENV HOME /opt/play
ENV PLAY_VERSION 1.5.3
ENV HOST 0.0.0.0
RUN groupadd -r play -g 1000 && \
  useradd -u 1000 -r -g play -m -d $HOME -s /sbin/nologin -c "Play user" play

WORKDIR $HOME

USER play

RUN wget -q https://downloads.typesafe.com/play/${PLAY_VERSION}/play-${PLAY_VERSION}.zip && \
  unzip -q play-${PLAY_VERSION}.zip && rm play-${PLAY_VERSION}.zip 

COPY --chown=play:play app $HOME/app/app
COPY --chown=play:play conf $HOME/app/conf
COPY --chown=play:play documentation $HOME/app/documentation
COPY --chown=play:play public ${HOME}/app/public
COPY --chown=play:play test $HOME/app/test
USER root
RUN ln -sf $HOME/play-${PLAY_VERSION}/play /usr/local/bin

WORKDIR ${HOME}/app
RUN ["play","deps"]
RUN ["play","precompile"]

USER root

EXPOSE 9000
CMD ["play","run"]