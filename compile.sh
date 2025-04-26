#!/bin/bash

# Compile script for Lexical Analyzer project

# Project directory structure:
#   headers/
#   src/
#   bin/ (will be created)

# Define directories
PROJECT_DIR="."
SRC_DIR="${PROJECT_DIR}/src"
HEADERS_DIR="${PROJECT_DIR}/headers"
BIN_DIR="${PROJECT_DIR}/bin"
OUTPUT_NAME="lexer"

# Create bin directory if it doesn't exist
mkdir -p "${BIN_DIR}"

# Compile all source files and link them together
gcc -Wall -Wextra -g \
    -I"${HEADERS_DIR}" \
    ${SRC_DIR}/*.c \
    -o "${BIN_DIR}/${OUTPUT_NAME}"

# Check if compilation was successful
if [ $? -eq 0 ]; then
    echo "Compilation successful! Binary created at: ${BIN_DIR}/${OUTPUT_NAME}"
    echo "You can run it with: ${BIN_DIR}/${OUTPUT_NAME}"
else
    echo "Compilation failed."
    exit 1
fi
