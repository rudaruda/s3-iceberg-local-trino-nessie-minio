FROM python:3.12-alpine

#FROM openjdk:8-jdk-alpine

#RUN  apk update \
#  && apk upgrade \
#  && apk add ca-certificates \
#  && update-ca-certificates \
#  && apk add --update coreutils && rm -rf /var/cache/apk/*   \ 
#  && apk add --update openjdk11 tzdata curl unzip bash \
#  && apk add --no-cache nss \
#  && rm -rf /var/cache/apk/*

# https://pkgs.alpinelinux.org/packages

RUN apk add --no-cache openjdk11

#export JAVA_HOME=/opt/openjdk-11
#export PATH=$JAVA_HOME/bin:$PATH

#if you need 11.0.6 specifically, install the latest openjdk11 package of the edge/community repository instead:
#RUN apk add openjdk11 --repository=http://dl-cdn.alpinelinux.org/alpine/edge/community


#ENV JAVA_HOME=/usr/java/jdk-11.0.6
#ENV PATH=$JAVA_HOME/bin:$PATH

#CMD ["python", "app.py", "--mitigations=off"]

RUN mkdir -p /code && chmod 777 /code
WORKDIR /code

COPY ./app /code/app

# create and activate virtual environment
#RUN python3.9 -m venv /opt/venv
#ENV PATH="/opt/venv/bin:$PATH"

#RUN useradd --create-home myuser
#USER myuser
#CMD ["bash"]

RUN pip3 install fastapi uvicorn
#ADD requirements.txt ./

#RUN --mount=type=cache,mode=0755,target=/root/.cache pip install -r requirements.txt
#RUN pip install --upgrade pip --no-binary --no-index #and force it to find a wheel?

#RUN pip install -r requirements.txt

#RUN rm -f ./requirements.txt

# make sure all messages always reach console
ENV PYTHONUNBUFFERED=1

# activate virtual environment
#ENV VIRTUAL_ENV=/home/myuser/venv
#ENV PATH="/home/myuser/venv/bin:$PATH"

# Outro jeito de insalar o python:

#FROM openjdk:8-jdk-alpine
#RUN apk add --no-cache \
#    bash \
#   curl \
#    python3 \
#    py3-pip

#ENV SPARK_VERSION=3.3.1 \
#    HADOOP_VERSION=3.4.0 \
#    PYSPARK_PYTHON=python3 \
#    PYSPARK_DRIVER_PYTHON=python3

#RUN curl -O https://downloads.apache.org/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz && \
#    tar -xzf hadoop-${HADOOP_VERSION}.tar.gz && \
#    mv hadoop-${HADOOP_VERSION} /usr/local/hadoop && \
#    rm hadoop-${HADOOP_VERSION}.tar.gz

#RUN curl -O https://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop3.tgz && \
#    tar -xzf spark-${SPARK_VERSION}-bin-hadoop3.tgz && \
#    mv spark-${SPARK_VERSION}-bin-hadoop3 /usr/local/spark && \
#    rm spark-${SPARK_VERSION}-bin-hadoop3.tgz

#ENV HADOOP_HOME=/usr/local/hadoop \
#    SPARK_HOME=/usr/local/spark \
#    PATH=$HADOOP_HOME/bin:$SPARK_HOME/bin:$PATH

#RUN pip3 install pyspark

#CMD ["pyspark"]

RUN echo VERSÃO DO JAVA
RUN echo -----------------
RUN java --version
RUN echo $JAVA_HOME

RUN echo -----------------

EXPOSE 8000

ENTRYPOINT ["uvicorn", "app.main:app", "--reload", "--host", "0.0.0.0", "--port", "8000"]

