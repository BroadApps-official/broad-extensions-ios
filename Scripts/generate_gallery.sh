#!/usr/bin/env bash

set -euo pipefail

module_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
gallery_root="$module_root/Examples/BroadExtensionsGallery"
expected_xcodegen_version="2.45.4"
xcodegen_binary="$module_root/.build/tooling/xcodegen-$expected_xcodegen_version/xcodegen/bin/xcodegen"

bash "$module_root/Scripts/install_build_tools.sh"
actual_xcodegen_version="$("$xcodegen_binary" --version | awk '{print $2}')"
if [[ "$actual_xcodegen_version" != "$expected_xcodegen_version" ]]; then
    echo "XcodeGen version mismatch: expected $expected_xcodegen_version, got $actual_xcodegen_version."
    exit 1
fi

"$xcodegen_binary" generate --spec "$gallery_root/project.yml" --project "$gallery_root"
echo "BroadExtensionsGallery project generated."
