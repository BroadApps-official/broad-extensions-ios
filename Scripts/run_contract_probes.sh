#!/usr/bin/env bash

set -euo pipefail

module_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
probe_directory="$module_root/.build/ContractProbes"
probe_binary="$probe_directory/BroadExtensionsContractProbe"

mkdir -p "$probe_directory"
xcrun swiftc \
    "$module_root/Sources/BroadExtensions/BroadRGBAColor.swift" \
    "$module_root/Scripts/ContractProbes/BroadExtensionsContractProbe.swift" \
    -o "$probe_binary"
"$probe_binary"

echo "BroadExtensions runtime contract probe passed."
