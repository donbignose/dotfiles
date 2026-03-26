#!/bin/bash

/Applications/Ghostty.app/Contents/MacOS/ghostty -e bash -c '
echo "Updating formulae..."
/opt/homebrew/bin/brew upgrade
echo ""
echo "Updating casks (greedy)..."
/opt/homebrew/bin/brew upgrade --cask --greedy
echo ""
echo "Cleaning up..."
/opt/homebrew/bin/brew cleanup
echo ""
echo "✓ All done. Closing in 3s..."
sleep 3
' &
