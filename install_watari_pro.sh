#!/bin/bash
# Watari Proprietary Installer (Encrypted)
eval "$(base64 -d << 'WATARI_EOF' | gzip -d
WATARI_EOF
)"
