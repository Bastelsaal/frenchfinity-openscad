#!/bin/bash
#
# Builds dist/<timestamp>_frenchfinity.scad: src/frenchfinity.scad with all its includes merged into
# one file, ready to be uploaded to the MakerWorld customizer.
#

set -euo pipefail

cd "$(dirname "$0")"

./merge_openscad_files_to_master.sh ../src/frenchfinity.scad ../dist/frenchfinity.scad
