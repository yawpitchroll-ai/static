# Use an official Ruby runtime as the base image
# docker build -t ypr-jekyll .
# docker run -p 4000:4000 -v "$(pwd)":/app -v my-jekyll-data:/app/_site ypr-jekyll

FROM ruby:latest

# Set environment variables for better default behavior
ENV LANG C.UTF-8
ENV BUNDLE_JOBS=4
ENV BUNDLE_RETRY=3

# Set the working directory for the app
WORKDIR /app

# Copy the Gemfile and Gemfile.lock to the container
COPY Gemfile Gemfile.lock ./

# Install the latest version of Bundler
RUN gem install bundler

# Install dependencies
RUN bundle install --jobs "$(nproc)" --retry 3

# Copy the rest of the application code to the container
COPY . .

# Build the website
RUN bundle exec jekyll build

# Expose the default Jekyll port
EXPOSE 4000

# Create a volume to persist data
VOLUME /app/_site

# Start the Jekyll server
CMD ["bundle", "exec", "jekyll", "serve", "--host", "0.0.0.0"]
