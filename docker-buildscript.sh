#!/bin/bash

SRC_PATH="${SRC_PATH:-/usr/src/app}"
TMP_PATH="${TMP_PATH:-/tmp}"
OUTPUT_PATH="${OUTPUT_PATH:-/output}"
ARTIFACT_PATH="${OUTPUT_PATH}/app"

cd "${TMP_PATH}"

qjsc -c -m \
    -M sdl.so,sdl \
    -o "qjsc-entrypoint.c" \
    "${SRC_PATH}/index.mjs"

find "/usr/local/gawain/src/native" -name "*.c" -exec gcc \
    -D"__CUSTOM_BUILD__=${CUSTOM_BUILD_ENV}" \
    -I"/usr/include/SDL2" \
    -I"/usr/src/quickjs" \
    -I"${TMP_PATH}" \
    -c {} \;

mkdir -p "$OUTPUT_PATH"
gcc -o "$ARTIFACT_PATH" \
    *.o \
    -L"/usr/src/quickjs" -lquickjs \
    -lSDL2 \
    -lm \
    -ldl
