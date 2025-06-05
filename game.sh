#!/bin/bash

echo "Starting player script..."
echo "Your IP is: $(hostname -I)"
echo "Waiting for messages..."

# Listen for messages (you can change port later)
while true; do
  nc -l -p 9000
done
