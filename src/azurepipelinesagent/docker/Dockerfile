FROM ubuntu:22.04

# The following environmental variables must be defined
# AZP_URL: URL of Azure Devops organization. E.g.: https://dev.azure.com/<org>
# AZP_POOL: name of pool has been created within devops organization
# AZP_TOKEN: Personal Access Token has been created within Azure Devops with permission: Agent pools (Read & Manage)

# To make it easier for build and release pipelines to run apt-get,
# configure apt to not require confirmation (assume the -y argument by default)
ENV DEBIAN_FRONTEND=noninteractive
RUN echo "APT::Get::Assume-Yes \"true\";" > /etc/apt/apt.conf.d/90assumeyes

RUN apt-get update \
&& apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        jq \
        git \
        iputils-ping \
        libcurl4 \
        libicu70 \
        libunwind8 \
        netcat \
        libssl1.0 \
		zip \
		unzip \
&& rm -rf /var/lib/apt/lists/*

RUN curl -LsS https://aka.ms/InstallAzureCLIDeb | bash \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /azp

COPY ./start.sh .
RUN chmod +x start.sh

CMD ["./start.sh"]