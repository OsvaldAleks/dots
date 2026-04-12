while true; do
  awww img "$(find ~/Pictures/wallpapers -type f | shuf -n 1)" \
    --transition-type fade \
    --transition-duration 2
  sleep 300
done
