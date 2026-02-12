while true; do
  sleep 300
  swww img "$(find ~/Pictures/wallpapers -type f | shuf -n 1)" \
    --transition-type fade \
    --transition-duration 2
done
