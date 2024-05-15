# Use node base image for Windows
FROM node:18

# Set the working directory
WORKDIR /usr/src/app

# Update the repository info to ensure you have the updated version
RUN apt-get update

# Install necessary libraries
#RUN apt-get install -y wget gnupg ca-certificates

RUN apt-get install -y gconf-service libgbm-dev libasound2 libatk1.0-0 libc6 libcairo2 libcups2 libdbus-1-3 libexpat1 libfontconfig1 libgcc1 libgconf-2-4 libgdk-pixbuf2.0-0 libglib2.0-0 libgtk-3-0 libnspr4 libpango-1.0-0 libpangocairo-1.0-0 libstdc++6 libx11-6 libx11-xcb1 libxcb1 libxcomposite1 libxcursor1 libxdamage1 libxext6 libxfixes3 libxi6 libxrandr2 libxrender1 libxss1 libxtst6 ca-certificates fonts-liberation libappindicator1 libnss3 lsb-release xdg-utils wget
# My version of chrome installation
RUN apt-get update && apt-get install curl gnupg -y \
  && curl --location --silent https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
  && sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' \
  && apt-get update \
  && apt-get install google-chrome-stable -y --no-install-recommends \
  && rm -rf /var/lib/apt/lists/*

# Set the global variable for Chrome
ENV CHROME_BIN=google-chrome-stable

# Copy package.json
COPY package*.json ./

# npm install with force to avoid cache
RUN npm install --force

# Copy the rest of the application
COPY . .

# Expose the port on which the application will run
EXPOSE 3000

HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
  CMD curl -fs http://localhost:3000/health || exit 1
  
# Run the application
CMD ["npm", "start"]
