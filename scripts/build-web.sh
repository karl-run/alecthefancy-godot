#!/bin/bash

rm -rf build/web
mkdir -p build/web
godot --headless --export-release Web ./build/web/alec.html
