#!/usr/bin/env bash
# Claude Code status line: model name, context % progress bar, git branch

input=$(cat)

model=$(echo "$input" | jq -r '.model.display_name // "Unknown"')
used=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // ""')

# Git branch (skip optional locks)
branch=""
if [ -n "$cwd" ]; then
  branch=$(git -C "$cwd" --no-optional-locks branch --show-current 2>/dev/null)
fi

# Build progress bar (10 chars wide)
bar=""
if [ -n "$used" ]; then
  filled=$(printf "%.0f" "$(echo "$used / 10" | bc -l)")
  empty=$((10 - filled))
  for i in $(seq 1 "$filled"); do bar="${bar}█"; done
  for i in $(seq 1 "$empty");  do bar="${bar}░"; done
  ctx_str=" $(printf "%.0f" "$used")% [${bar}]"
else
  ctx_str=""
fi

# Assemble output
parts=""

# Model
parts="${model}"

# Context
if [ -n "$ctx_str" ]; then
  parts="${parts} |${ctx_str}"
fi

# Git branch
if [ -n "$branch" ]; then
  parts="${parts} |  ${branch}"
fi

printf "%s" "$parts"
