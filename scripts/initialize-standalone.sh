#!/usr/bin/env bash
#

HOME_CONFIG=standalone

if ! command -v nix &> /dev/null
then
	echo "Please install nix first."
	exit 1
fi

mkdir -p ~/.config/nix
echo "experimental-features = nix-command flakes" > ~/.config/nix/nix.conf

script_dir="$( dirname -- "$BASH_SOURCE"; )"
root_dir="$(realpath "${script_dir}/../")"
nix_conf="${root_dir}#homeConfigurations.${HOME_CONFIG}"

nix build --no-link "${nix_conf}.activationPackage"
"$(nix path-info ${nix_conf}.activationPackage)"/activate
