#!/bin/sh

CMD="/usr/local/bin/ddc-bright-helper"

get_brightness() {
  $CMD get 2>/dev/null \
    | awk '
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

case "$1" in
  up)   $CMD up   >/dev/null 2>&1 ;;
  down) $CMD down >/dev/null 2>&1 ;;
esac

BR=$(get_brightness)
[ -z "$BR" ] && BR=0

printf '{ "text": "%s", "tooltip": "Brightness %s%%" }
' "$BR" "$BR"
