#!/bin/bash

OUTPUT_PATH="${OUTPUT_PATH:-/output}"
ARTIFACT_PATH="${OUTPUT_PATH}/app"

mkdir -p "$OUTPUT_PATH"
gcc -o "$ARTIFACT_PATH" *.o \
    -L"/usr/src/quickjs" -lquickjs \
    -lSDL2 \
    -lm \
    -ldl
