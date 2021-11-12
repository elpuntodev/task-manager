FROM ruby:3.0.0

# Download and descompress ChromeDriver
ADD https://chromedriver.storage.googleapis.com/80.0.3987.106/chromedriver_linux64.zip /tmp/chromedriver.zip
RUN unzip /tmp/chromedriver.zip -d /usr/bin

# Pre install Yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
  bash -c "echo 'deb https://dl.yarnpkg.com/debian/ stable main' >> /etc/apt/sources.list"
# Update package list
RUN apt-get update -y && \
  # install packages
  apt-get install -y build-essential curl wget openssl libssl-dev libreadline-dev dirmngr\
   zlib1g-dev libmagickwand-dev imagemagick-6.q16 libffi-dev libpq-dev cmake libwebp-dev &&\
  # Install Yarn
  apt --no-install-recommends install -y yarn && \
  # Install Node
  curl -sL https://deb.nodesource.com/setup_8.x | bash - && \
  apt-get install -y nodejs

# Install yarn packages
RUN yarn add bootstrap jquery @popperjs/core roboto-fontface @nathanvda/cocoon @rails/webpacker

# Create and change to work directory
WORKDIR /app

# Copy dependencies file and install
COPY ["./Gemfile", "./Gemfile.lock", "./"]
RUN bundle install

EXPOSE 3000

CMD [ "./docker/local/rails/start.sh" ]
