#!/bin/bash
# Install build dependencies and build the Retro68 toolchain (68k only)
# into Retro68-build/toolchain/, where build.sh expects it.
# Takes a while on first run; skipped if the toolchain is already there.
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
TOOLCHAIN="$SCRIPT_DIR/Retro68-build/toolchain/m68k-apple-macos/cmake/retro68.toolchain.cmake"

if [ -f "$TOOLCHAIN" ]; then
    echo "Retro68 toolchain already installed"
    exit 0
fi

if command -v apt-get >/dev/null 2>&1; then
    SUDO=""
    [ "$(id -u)" -ne 0 ] && SUDO="sudo"
    $SUDO apt-get update -qq || true
    DEBIAN_FRONTEND=noninteractive $SUDO apt-get install -y -qq \
        cmake ninja-build ruby bison flex texinfo \
        libgmp-dev libmpfr-dev libmpc-dev libboost-all-dev zlib1g-dev \
        hfsutils macutils
fi

if [ ! -d "$SCRIPT_DIR/Retro68" ]; then
    git clone --depth 1 --recursive --shallow-submodules \
        https://github.com/autc04/Retro68.git "$SCRIPT_DIR/Retro68"
fi

mkdir -p "$SCRIPT_DIR/Retro68-build"
cd "$SCRIPT_DIR/Retro68-build"
../Retro68/build-toolchain.bash --no-ppc --no-carbon
