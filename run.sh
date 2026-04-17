#!/usr/bin/env bash

# Install `pkill` and `entr` first from your package manager.
# This script watches file changes within `lib/` using `entr`,
# then sends `SIGUSR1` to Flutter's PID file on file change.

FLUTTER_PID=$(mktemp -u)
echo "PID: $FLUTTER_PID"
find lib -type f -name "*.dart" | entr -np sh -c "pkill --signal USR1 --pidfile $FLUTTER_PID" &
flutter run --pid-file="$FLUTTER_PID"
pkill entr
pkill java
exit 0
