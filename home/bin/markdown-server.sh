#!/bin/bash

VENV_DIR="$HOME/grip-venv"
PID_FILE="$VENV_DIR/server.pid"

# Function to display usage information
usage() {
    echo "Usage: ${0} -d <input_dir>"
    echo "       ${0} -k"
    echo "Manage the HTTP server to serve the output directory"
    echo "Options:"
    echo "    -d <input_dir>   Input directory with the Markdown files"
    echo "    -k               Stop the HTTP server"
    exit 1
}

# Function to start HTTP server
start_http_server() {
    local dir="$1"
    local port=8081
    # Ensure input directory is provided
    if [ -z "$dir" ]; then
        echo "Input directory (-d) must be provided to start the Markdown server."
        usage
    fi

    # Ensure input directory is an absolute path
    dir=$(realpath "$dir")

    # Check if the virtual environment already exists
    if [ ! -f "$VENV_DIR/bin/activate" ]; then
        echo "Creating virtual environment..."
        python3 -m venv $VENV_DIR
        echo "Virtual environment created."
    fi
    . $VENV_DIR/bin/activate
	# Check if grip is installed
    if ! python3 -c "import grip" &> /dev/null; then
        echo "Grip is not installed. Installing grip..."
        pip3 install grip
    fi
    # Check if grip is available and start the server on specified port
    if command -v grip &> /dev/null; then
        grip "$dir" 0.0.0.0:"$port"  > /dev/null 2>&1 &
        echo $! > "$PID_FILE"
        echo "Markdown server started on port $port in the background serving $dir"
    else
        echo "grip is required to start the markdown server."
        exit 1
    fi
}

# Function to stop HTTP server
stop_http_server() {

    # Check if the server is running and stop it
    if [ -f "$PID_FILE" ]; then
        kill $(cat "$PID_FILE") && rm -f "$PID_FILE"
        echo "Markdown server stopped."
    else
        echo "No server is running."
    fi
}

# Variables to hold input arguments
dir=""
stop_server=false

# Parse input arguments
while getopts ":d:k" opt; do
    case ${opt} in
        d )
            dir="$OPTARG"
            ;;
        k )
            stop_server=true
            ;;
        \? )
            echo "Invalid option: -$OPTARG" >&2
            usage
            ;;
        : )
            echo "Option -$OPTARG requires an argument." >&2
            usage
            ;;
    esac
done

# Shift off the options and arguments processed by getopts
shift $((OPTIND - 1))

# Stop the server if the -k flag is set
if $stop_server; then
    stop_http_server "$dir"
    exit 0
fi

# Start HTTP server if output directory is provided
if [ -n "$dir" ]; then
    start_http_server "$dir"
    exit 0
fi

# If no valid action is specified
echo "No valid action specified. Use -o <dir> to start server or -k -o <dir> to stop the server."
usage
