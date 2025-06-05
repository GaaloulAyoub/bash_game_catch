# Dockerfile
FROM ubuntu:22.04

# Install netcat and bash utilities
RUN apt update && apt install -y netcat iputils-ping

# Create game directory and add script
WORKDIR /game
COPY game.sh .

# Make script executable
RUN chmod +x game.sh

# Start the game
CMD ["bash", "game.sh"]
