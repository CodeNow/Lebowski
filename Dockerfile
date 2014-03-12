# Pull base image.
FROM dockerfile/ubuntu

# Install Node.js
RUN apt-get install -y software-properties-common python g++ make
RUN add-apt-repository -y ppa:chris-lea/node.js
RUN apt-get update
RUN apt-get install -y nodejs

# Append to $PATH variable.
RUN echo '\n# Node.js\nexport PATH="node_modules/.bin:$PATH"' >> /root/.bash_profile

# Add files
WORKDIR /Lebowski
ADD . /Lebowski

# Npm install
RUN npm install

# Build
RUN npm run build

# Expose Port
EXPOSE 3480

# Define default command.
CMD ["bash",
  "-c",
  "/harbourmaster/node_modules/pm2 start server.js && /harbourmaster/node_modules/pm2 logs"]