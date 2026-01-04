#!/bin/sh
set -u

CMD="/usr/local/bin/ddc-bright-helper"
T="${DDC_TIMEOUT:-0.8}"

get_brightness() {
  timeout "$T" "$CMD" get 2>/dev/null | awk '
    /current value/ {
      for (i = 1; i <= NF; i++) {
        if ($i == "value") {
          gsub(/,/, "", $(i+2));
          print $(i+2);
          exit;
        }
      }
    }'
}

if [ ! -x "$CMD" ]; then
  printf '{"text":"n/a","tooltip":"ddc-bright-helper not found"}\n'
  exit 0
fi

case "${1:-}" in
  up)   timeout "$T" "$CMD" up   >/dev/null 2>&1 || true ;;
  down) timeout "$T" "$CMD" down >/dev/null 2>&1 || true ;;
esac

BR="$(get_brightness || true)"
case "$BR" in
  ''|*[!0-9]*) BR=0 ;;
esac

printf '{"text":"%s","tooltip":"Brightness %s%%"}\n' "$BR" "$BR"
