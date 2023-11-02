while true; do
  {
    read COLOR
    while read NEXT_COLOR; do
      ./generate-colors.sh $COLOR $NEXT_COLOR 150 | \
        grep -v '#' | \
        xargs -I@ zsh -c "sleep 0.03; hsetroot -solid \#@"

      COLOR=$NEXT_COLOR
    done
  } < $HOME/.cache/wal/colors
done
