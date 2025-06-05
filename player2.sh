#!/bin/bash

# === Map size ===
ROWS=10
COLS=10

my_row=8
my_col=8
other_row=1
other_col=1

MY_PORT=9002
OTHER_PORT=9001

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
    k) ((my_row > 0)) && ((my_row--));;
    i) ((my_row < ROWS - 1)) && ((my_row++));;
    j) ((my_col > 0)) && ((my_col--));;
    l) ((my_col < COLS - 1)) && ((my_col++));;
  esac
}

# === Listener in background ===
listen_for_opponent() {
  while true; do
    data=$(nc -l -p $MY_PORT)
    if [[ $data =~ ^POS\|1\|([0-9]+),([0-9]+)$ ]]; then
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
  echo "POS|2|$my_row,$my_col" | nc $OTHER_HOST $OTHER_PORT

done
