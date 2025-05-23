#!/bin/bash
set -e

export NEON_REVISION="develop"
cd `dirname $0`

cargo build-sbf --manifest-path program/Cargo.toml --features ci --dump

cargo build \
        --config 'patch.crates-io.ethnum.git="https://github.com/neonlabsorg/ethnum.git"'\
        --config 'patch.crates-io.ethnum.branch="main"'\
        --release
# --target=x86_64-unknown-linux-musl

cargo build \
        --config 'patch.crates-io.ethnum.git="https://github.com/neonlabsorg/ethnum.git"'\
        --config 'patch.crates-io.ethnum.branch="main"'

libs=(
	/usr/lib64/libudev.so.1
	/usr/lib/gcc/x86_64-pc-linux-gnu/14/libgcc_s.so.1
	/usr/lib64/libm.so.6
	/usr/lib64/libc.so.6
	/lib64/ld-linux-x86-64.so.2
	/usr/lib64/libcap.so.2
    /lib64/ld-linux-x86-64.so.2
)

mkdir -p ./target/libs
for lib in ${libs[@]}; do
    echo copying $lib
    cp $lib ./target/libs/
done

tools=(neon-cli neon-rpc neon-api)

for tool in ${tools[@]}; do
    echo patching $tool
    patchelf target/release/$tool --set-interpreter /target/libs/ld-linux-x86-64.so.2
    patchelf target/debug/$tool --set-interpreter /target/libs/ld-linux-x86-64.so.2
done

cp target/release/{neon-api,neon-core-api}
cp target/debug/{neon-api,neon-core-api}
