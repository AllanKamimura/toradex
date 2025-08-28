#!/bin/bash

static() {
    while true; do
        dd if=/dev/urandom of=/dev/fb0 bs=1024 count=4096
    done
}
