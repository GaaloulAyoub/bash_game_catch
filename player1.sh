#!/bin/bash

# === Map size ===
ROWS=10
COLS=10

# === Initial player positions ===
my_row=1
my_col=1
other_row=8
other_col=8

# === Netcat configuration ===
MY_PORT=9001
OTHER_PORT=9002
OTHER_HOST=127.0.0.1

# === Draw map ===
draw_map() {
  clear
  for ((i=0; i<ROWS; i++)); do
    for ((j=0; j<COLS; j++)); do
      if [[ $i -eq $my_row && $j -eq $my_col ]]; then
        echo -n "1 "
      elif [[ $i -eq $other_row && $j -eq $other_col ]]; then
        echo -n "2 "
      else
        echo -n ". "
      fi
    done
    echo
  done
}

# === Move ===
move() {
  case "$1" in
    w) ((my_row > 0)) && ((my_row--));;
    s) ((my_row < ROWS - 1)) && ((my_row++));;
    a) ((my_col > 0)) && ((my_col--));;
    d) ((my_col < COLS - 1)) && ((my_col++));;
  esac
}

# === Listener in background ===
listen_for_opponent() {
  while true; do
    data=$(nc -l -p $MY_PORT)
    if [[ $data =~ ^POS\|2\|([0-9]+),([0-9]+)$ ]]; then
      other_row=${BASH_REMATCH[1]}
      other_col=${BASH_REMATCH[2]}
    fi
  done
}

# Start listening in background
listen_for_opponent &

# === Main loop ===
while true; do
  draw_map
  echo "Use WASD to move. 'q' to quit."
  read -n1 key
  echo
  [[ "$key" == "q" ]] && break
  move $key

  # Send position to player 2
  echo "POS|1|$my_row,$my_col" | nc $OTHER_HOST $OTHER_PORT
done
