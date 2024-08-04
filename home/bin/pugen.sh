#!/bin/bash

# Function to display usage information
usage() {
    echo "Usage: ${0} -d <input_dir> [-o <output_dir>]"
    echo "Generate images from PlantUml diagrams"
    echo "Options:"
    echo "    -d <input_dir>    Input directory containing PlantUML files (required)"
    echo "    -o <output_dir>   Output directory for generated images (default: .plantuml-output inside the input directory)"
    exit 1
}

# Function to generate PlantUml images
generate_images() {
    local input_dir="$1"
    local output_dir="$2"

    # Ensure input directory is provided
    if [ -z "$input_dir" ]; then
        echo "Input directory (-d) must be provided for diagram generation."
        usage
    fi

    # Ensure input directory is an absolute path
    input_dir=$(realpath "$input_dir")

    # Set default output directory if not provided
    if [ -z "$output_dir" ]; then
        output_dir="$input_dir/.plantuml-output"
    else
        output_dir=$(realpath "$output_dir")
    fi

    # Create output directory if it doesn't exist
    mkdir -p "$output_dir"

    # Run PlantUml
    java -jar "$HOME/lib/java/plantuml.jar" -o "$output_dir" -tsvg "$input_dir"
}

# Variables to hold input arguments
output_dir=""
input_dir=""

# Parse input arguments
while getopts ":o:d:" opt; do
    case ${opt} in
        o )
            output_dir="$OPTARG"
            ;;
        d )
            input_dir="$OPTARG"
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

# Generate images
generate_images "$input_dir" "$output_dir"
