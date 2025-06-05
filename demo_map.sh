#!/bin/bash

# === Map dimensions ===
ROWS=10
COLS=10

# === Initial player position ===
player_row=5
player_col=5

# === Function to draw the map ===
draw_map() {
  clear
  for ((i=0; i<ROWS; i++)); do
    for ((j=0; j<COLS; j++)); do
      if [[ $i -eq $player_row && $j -eq $player_col ]]; then
        echo -n "1 "  # Player symbol
      else
        echo -n ". "  # Empty space
      fi
    done
    echo
  done
}

# === Function to update player position ===
move_player() {
  case $1 in
    w) ((player_row > 0))     && ((player_row--));;
    s) ((player_row < ROWS-1)) && ((player_row++));;
    a) ((player_col > 0))     && ((player_col--));;
    d) ((player_col < COLS-1)) && ((player_col++));;
  esac
}   

# === Game loop ===
while true; do
  draw_map
  echo "Use WASD to move. Press q to quit."
  read -n 1 key  # Read one character
  echo           # Move to next line
  [[ $key == "q" ]] && break
  move_player $key
done
