#!/bin/bash
set -e

cargo build --release # --target=x86_64-unknown-linux-musl
cargo build-sbf --manifest-path program/Cargo.toml --features ci --dump

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
done

cp target/release/{neon-api,neon-core-api}
