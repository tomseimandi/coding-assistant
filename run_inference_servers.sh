# !/bin/sh
# Script to run two llama.cpp inference servers on https://bacasable.peren.fr
# Command to start first inference server
start_codestral_server() {
    ./llama-server -m models/Codestral-22B-v0.1-Q4_K_M.gguf -ngl 57 --port 8888 &
    echo $! > ~/shared/tseimandi/coding_assistant/codestral.pid
    echo "Codestral inference server started with PID: $(cat ~/shared/tseimandi/coding_assistant/codestral.pid) and available on port 8888."
}

# Command to start second inference server
start_deepseek_server() {
    ./llama-server -m models/deepseek-coder-6.7b-base.Q4_K_M.gguf -ngl 33 --port 8080 &
    echo $! > ~/shared/tseimandi/coding_assistant/deepseek.pid
    echo "Deepseek Coder inference server started with PID: $(cat ~/shared/tseimandi/coding_assistant/deepseek.pid) and available on port 8080."
}

# Commands to stop the servers
stop_codestral_server() {
  if [ -f ~/shared/tseimandi/coding_assistant/codestral.pid ]; then
    kill $(cat ~/shared/tseimandi/coding_assistant/codestral.pid)
    rm ~/shared/tseimandi/coding_assistant/codestral.pid
    echo "Codestral inference server stopped."
  fi
}

stop_deepseek_server() {
  if [ -f ~/shared/tseimandi/coding_assistant/deepseek.pid ]; then
    kill $(cat ~/shared/tseimandi/coding_assistant/deepseek.pid)
    rm ~/shared/tseimandi/coding_assistant/deepseek.pid
    echo "Deepseek Coder inference server stopped."
  fi
}

# Function to check if a server is running
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
    if [ -f ~/shared/tseimandi/coding_assistant/codestral.pid ]; then
      if ! is_running $(cat ~/shared/tseimandi/coding_assistant/codestral.pid); then
        start_first_server
      fi
    else
      start_first_server
    fi

    if [ -f ~/shared/tseimandi/coding_assistant/deepseek.pid ]; then
      if ! is_running $(cat ~/shared/tseimandi/coding_assistant/deepseek.pid); then
        start_second_server
      fi
    else
      start_second_server
    fi
    ;;
  stop)
    stop_first_server
    stop_second_server
    ;;
  *)
    echo "Usage: $0 {start|stop}"
    exit 1
    ;;
esac
