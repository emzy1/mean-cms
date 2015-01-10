FROM ubuntu:14.04

# DEPS
RUN sudo apt-get update
RUN sudo apt-get install -y curl python build-essential git mongodb-clients

# NODE
RUN curl -sL https://deb.nodesource.com/setup | sudo bash -
RUN sudo apt-get install -y nodejs
RUN sudo npm install -g coffee-script grunt grunt-cli bower

WORKDIR /app
EXPOSE 3000
CMD ["/bin/bash"]
