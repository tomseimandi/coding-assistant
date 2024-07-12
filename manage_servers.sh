#!/bin/sh
# Script to run two llama.cpp inference servers on https://bacasable.peren.fr
# Function to start a server
start_server() {
  local cmd=$1
  local pidfile=$2
  local name=$3
  local logfile=$4

  if [ -f $pidfile ]; then
    local pid=$(cat $pidfile)
    if ! is_running $pid; then
      echo "$name PID file exists but process is not running. Starting $name."
      nohup $cmd > $logfile 2>&1 &
      echo $! > $pidfile
      echo "$name started with PID: $(cat $pidfile)"
    else
      echo "$name is already running with PID: $pid"
    fi
  else
    echo "Starting $name."
    nohup $cmd > $logfile 2>&1 &
    echo $! > $pidfile
    if [ $? -eq 0 ]; then
      echo "$name started with PID: $(cat $pidfile)"
    else
      echo "Failed to write PID file for $name"
    fi
  fi
}

# Function to stop a server
stop_server() {
  local pidfile=$1
  local name=$2

  if [ -f $pidfile ]; then
    local pid=$(cat $pidfile)
    if is_running $pid; then
      kill $pid
      rm $pidfile
      echo "$name stopped."
    else
      echo "$name PID file exists but process is not running. Cleaning up."
      rm $pidfile
    fi
  else
    echo "$name PID file does not exist."
  fi
}

# Function to check if a process is running
is_running() {
  if ps -p $1 > /dev/null; then
    return 0
  else
    return 1
  fi
}

# Main script logic
case "$1" in
  start)
    start_server "../llama.cpp/llama-server -m ../llama.cpp/models/Codestral-22B-v0.1-Q4_K_M.gguf -ngl 57 --port 8888" "/tmp/inference_servers/codestral.pid" "Codestral server" "/tmp/inference_servers/codestral.log"
    start_server "../llama.cpp/llama-server -m ../llama.cpp/models/deepseek-coder-6.7b-base.Q4_K_M.gguf -ngl 33 --port 8080" "/tmp/inference_servers/deepseek.pid" "Deepseek Coder server" "/tmp/inference_servers/deepseek.log"
    start_server "../text-embeddings-inference/text-embeddings-router --model-id ../../rcouronne/nomic-embed-text-v1/ --port 9090" "/tmp/inference_servers/embedding.pid" "Nomic Embedding server" "/tmp/inference_servers/embedding.log"
    ;;
  stop)
    stop_server "/tmp/inference_servers/codestral.pid" "Codestral server"
    stop_server "/tmp/inference_servers/deepseek.pid" "Deepseek Coder server"
    stop_server "/tmp/inference_servers/embedding.pid" "Nomic Embedding server"
    ;;
  *)
    echo "Usage: $0 {start|stop}"
    exit 1
    ;;
esac
