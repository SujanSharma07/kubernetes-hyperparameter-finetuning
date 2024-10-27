FROM ubuntu:latest
  
LABEL maintainer="sujansharma202.gmail.com"

ARG RUNNER_VERSION="2.292.0"

RUN apt-get update -y && apt-get upgrade -y && useradd -m runner

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    curl jq build-essential libssl-dev libffi-dev python3 python3-venv python3-dev python3-pip

RUN cd /home/runner && mkdir actions-runner && cd actions-runner \
    && curl -O -L https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz \
    && tar xzf ./actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz

RUN chown -R runner ~runner && /home/runner/actions-runner/bin/installdependencies.sh

COPY start.sh start.sh

RUN chmod +x start.sh

RUN apt install -y git curl unzip

RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && unzip awscliv2.zip && ./aws/install
RUN rm awscliv2.zip
RUN apt-get install telnet -y 
RUN apt-get install iputils-ping -y
RUN apt install rsync -y
USER runner

WORKDIR /
EXPOSE 80
ENTRYPOINT ["./start.sh"]