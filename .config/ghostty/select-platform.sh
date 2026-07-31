#!/bin/sh
set -eu

config_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)

case "$(uname -s)" in
  Darwin)
    platform_config=macos.conf
    ;;
  Linux)
    platform_config=linux.conf
    ;;
  *)
    echo "Unsupported platform: $(uname -s)" >&2
    exit 1
    ;;
esac

ln -sfn "$platform_config" "$config_dir/platform.conf"
echo "Ghostty platform config: $platform_config"
