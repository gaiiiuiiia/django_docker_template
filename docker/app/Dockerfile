FROM python:3.10-slim

RUN apt-get update \
    && apt-get install -y postgresql \
    && apt-get install -y gcc \
    && apt-get install -y python3-dev \
    && apt-get install -y musl-dev \
    && apt-get install -y wget \
    && apt-get install -y unzip


ARG INSTALL_GECKO_AND_FIREFOX=false
RUN if [ ${INSTALL_GECKO_AND_FIREFOX}=true ];  \
    then  \
        wget https://github.com/mozilla/geckodriver/releases/download/v0.31.0/geckodriver-v0.31.0-linux64.tar.gz \
        && tar -xvzf geckodriver* \
        && chmod +x geckodriver \
        && mv geckodriver /usr/local/bin/ \
        && apt-get install -y firefox-esr; \
    fi;

ARG UID=1000
ARG GID=1000
ARG UNAME=appuser
RUN set -x ; \
    groupadd --gid ${GID} ${UNAME}; \
    useradd --uid ${UID} --gid ${GID} -m ${UNAME} && exit 0 ; exit 1

ARG APP_DIR=/var/www/app
ARG APP_FOLDER=app
WORKDIR ${APP_DIR}

COPY --chown=${UID}:${GID} . .

ARG ENV=prod
RUN python -m pip install --upgrade pip
RUN if [ -f ${APP_FOLDER}/requirements/${ENV}.txt ]; \
    then \
      pip install -r ${APP_FOLDER}/requirements/${ENV}.txt; \
    fi;

USER ${UNAME}
