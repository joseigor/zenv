#!/bin/bash

# Function to display usage information
usage() {
    echo "Usage: ${0} -o <output_dir> [-p <port>]"
    echo "       ${0} -k -o <output_dir>"
    echo "Manage the HTTP server to serve the output directory"
    echo "Options:"
    echo "    -o <output_dir>   Output directory to serve or stop serving (required)"
    echo "    -p <port>         Port to run the HTTP server on (default: 8080)"
    echo "    -k                Stop the HTTP server"
    exit 1
}

# Function to start HTTP server
start_http_server() {
    local output_dir="$1"
    local port="$2"

    # Ensure output directory is provided
    if [ -z "$output_dir" ]; then
        echo "Output directory (-o) must be provided to start the HTTP server."
        usage
    fi

    # Ensure output directory is an absolute path
    output_dir=$(realpath "$output_dir")

    local pid_file="$output_dir/server.pid"

    # Check if Python is available and start the server on specified port
    if command -v python3 &> /dev/null; then
        python3 -m http.server "$port" --directory "$output_dir" &
        echo $! > "$pid_file"
        echo "HTTP server started on port $port in the background serving $output_dir"
    else
        echo "Python3 is required to start the HTTP server."
        exit 1
    fi
}

# Function to stop HTTP server
stop_http_server() {
    local output_dir="$1"

    # Ensure output directory is provided
    if [ -z "$output_dir" ]; then
        echo "Output directory (-o) must be provided to stop the HTTP server."
        usage
    fi

    # Ensure output directory is an absolute path
    output_dir=$(realpath "$output_dir")

    local pid_file="$output_dir/server.pid"

    # Check if the server is running and stop it
    if [ -f "$pid_file" ]; then
        kill $(cat "$pid_file") && rm -f "$pid_file"
        echo "HTTP server stopped."
    else
        echo "No server is running."
    fi
}

# Variables to hold input arguments
output_dir=""
port=8080
stop_server=false

# Parse input arguments
while getopts ":o:p:k" opt; do
    case ${opt} in
        o )
            output_dir="$OPTARG"
            ;;
        p )
            port="$OPTARG"
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
    stop_http_server "$output_dir"
    exit 0
fi

# Start HTTP server if output directory is provided
if [ -n "$output_dir" ]; then
    start_http_server "$output_dir" "$port"
    exit 0
fi

# If no valid action is specified
echo "No valid action specified. Use -o <output_dir> to start server or -k -o <output_dir> to stop the server."
usage

