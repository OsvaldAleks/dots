#!/bin/bash

# === DEFAULT VALUES ===
VIRTUAL_MONITOR="HEADLESS-66"
VIRTUAL_WORKSPACE=10
REAL_MONITOR="eDP-1"
RESOLUTION="1650x720@60"
OFFSET="1920x720"
SCALING="1"
PORT=5900

# === PRESETS ===
case "$1" in
  phone)
    VIRTUAL_MONITOR="HEADLESS-66"
    RESOLUTION="720x1650@60"
    OFFSET="-721x720"
    SCALING="1, transform, 2"
    ;;
  ipad)
    VIRTUAL_MONITOR="HEADLESS-67"
    RESOLUTION="2266x1488@60"
    OFFSET="2560x-948"
    SCALING="1"
    PORT=5901
    ;;
esac

# === OPTIONAL ARGUMENT OVERRIDES ===
while [[ $# -gt 0 ]]; do
  case "$1" in
    --monitor) VIRTUAL_MONITOR="$2"; shift 2 ;;
    --workspace) VIRTUAL_WORKSPACE="$2"; shift 2 ;;
    --real) REAL_MONITOR="$2"; shift 2 ;;
    --res) RESOLUTION="$2"; shift 2 ;;
    --offset) OFFSET="$2"; shift 2 ;;
    --scale) SCALING="$2"; shift 2 ;;
    --port) PORT="$2"; shift 2 ;;
    *) shift ;;
  esac
done

# === CLEANUP FUNCTION ===
cleanup() {
  echo -e "\n[wayvnc] Cleaning up..."
  hyprctl output remove "$VIRTUAL_MONITOR"
  pkill wayvnc
  echo "[wayvnc] Done."
  exit 0
}

trap cleanup INT TERM EXIT

# === CREATE HEADLESS MONITOR ===
echo "[wayvnc] Creating $VIRTUAL_MONITOR..."
hyprctl output create headless "$VIRTUAL_MONITOR"
hyprctl keyword monitor "$VIRTUAL_MONITOR,$RESOLUTION,$OFFSET,$SCALING"

# === MOVE WORKSPACE ===
echo "[wayvnc] Moving workspace $VIRTUAL_WORKSPACE to $VIRTUAL_MONITOR..."
hyprctl dispatch moveworkspacetomonitor "$VIRTUAL_WORKSPACE" "$VIRTUAL_MONITOR"
hyprctl dispatch workspace "$VIRTUAL_WORKSPACE"

# === RETURN FOCUS ===
hyprctl dispatch focusmonitor "$REAL_MONITOR"

# === START WAYVNC ===
echo "[wayvnc] Starting WayVNC on $VIRTUAL_MONITOR..."
wayvnc 0.0.0.0 -S "$PORT" -o="$VIRTUAL_MONITOR" -L=info -g --disable-input -Ldebug
