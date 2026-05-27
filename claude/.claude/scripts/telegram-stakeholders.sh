#!/bin/bash
# Usage: echo "message" | bash ~/.claude/scripts/telegram-stakeholders.sh
# Reads .envrc from the monorepo root for TELEGRAM_BOT_TOKEN

ENVRC="$(git rev-parse --show-toplevel 2>/dev/null)/.envrc"
[ -f "$ENVRC" ] && source "$ENVRC"

TOKEN="${TELEGRAM_BOT_TOKEN:-}"
CHAT_ID="-1003492521986"

[ -z "$TOKEN" ] && exit 0

MESSAGE=$(cat)
[ -z "$MESSAGE" ] && exit 0

curl -s -X POST "https://api.telegram.org/bot${TOKEN}/sendMessage" \
  -d chat_id="$CHAT_ID" \
  -d parse_mode="Markdown" \
  -d text="$MESSAGE" > /dev/null 2>&1
