#!/bin/sh
set -e

# Ensure Artist metadata is not corrupt, does exist and >= 3 chars
test_artist () {
    print_error () {
        echo "Failure! $1 missing Artist metadata! See README.md."
        exit 1
    }

    ARTIST="$(exif --tag=Artist --no-fixup -m "$1")" || print_error "$1"
    if [ "$(echo "$ARTIST" | wc -m)" -lt 3 ]; then
        print_error "$1"
    fi
}


# Ensure image size cannot be further optimized
test_jpegoptim () {
    print_error () {
        echo "Failure! $1 not optimized! See README.md."
        exit 1
    }

    RESULT=$(jpegoptim -n "$1") || print_error "$1"
    if [ "$(echo "$RESULT" | grep optimized)" != "" ]; then
        print_error "$1"
    fi
}

for WALLPAPER in *.jpg
do
    test_artist "$WALLPAPER"
    test_jpegoptim "$WALLPAPER"
done

echo "Success! Wallpapers have Artist metadata and are optimized."
