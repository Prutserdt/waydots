#!/usr/bin/env bash

LAT="$(< "$HOME/stack/Command_line/latitude_thuis")"
LON="$(< "$HOME/stack/Command_line/longitude_thuis")"
API_KEY="$(< "$HOME/stack/Command_line/openweather_api_key")"
UNIT="metric"

url="https://api.openweathermap.org/data/2.5/weather"
data=$(curl --fail-with-body -sS \
  --get "$url" \
  --data-urlencode "lat=$LAT" \
  --data-urlencode "lon=$LON" \
  --data-urlencode "appid=$API_KEY" \
  --data-urlencode "units=$UNIT")

if jq -e '.main.temp' >/dev/null 2>&1 <<< "$data"; then
  temp=$(jq -r '.main.temp' <<< "$data" | xargs printf "%.0f")
  icon=$(jq -r '.weather[0].icon' <<< "$data")

  case "$icon" in
    01d) weather_icon="☀️" ;;
    01n) weather_icon="🌙" ;;
    02*) weather_icon="⛅" ;;
    03*|04*) weather_icon="☁️" ;;
    09*|10*) weather_icon="🌧️" ;;
    11*) weather_icon="⛈️" ;;
    13*) weather_icon="❄️" ;;
    50*) weather_icon="🌫️" ;;
    *) weather_icon="🌈" ;;
  esac

  printf '%s %s°C\n' "$weather_icon" "$temp"
else
  echo "Weather: N/A"
  echo "$data" >&2
fi
