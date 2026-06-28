#!/usr/bin/env bash
set -e

SKILL_NAME="solana-token-launch-skill"
REPO="Myles181/solana-token-launch-skill"
BRANCH="main"
DEST="$HOME/.claude/skills/$SKILL_NAME"
RAW="https://raw.githubusercontent.com/$REPO/$BRANCH"

FILES=(
  "skill/SKILL.md"
  "skill/launchpad.md"
  "skill/token-standard.md"
  "skill/authorities.md"
  "skill/tokenomics.md"
  "skill/liquidity.md"
  "skill/gtm.md"
  "skill/resources.md"
  "skill/red-flags.md"
  "commands/token-launch-plan.md"
  "commands/token-audit.md"
  "commands/launch-day-checklist.md"
  "agents/token-launch-advisor.md"
  "rules/safety.md"
  "rules/defaults.md"
  "rules/scope.md"
  "CLAUDE.md"
)

echo "Installing $SKILL_NAME to $DEST"
mkdir -p "$DEST/skill"
mkdir -p "$DEST/commands"
mkdir -p "$DEST/agents"
mkdir -p "$DEST/rules"

for file in "${FILES[@]}"; do
  echo "  Downloading $file..."
  curl -sSL "$RAW/$file" -o "$DEST/$file"
done

echo "Registering slash commands in ~/.claude/commands/..."
mkdir -p "$HOME/.claude/commands"
cp "$DEST/commands/token-launch-plan.md"    "$HOME/.claude/commands/token-launch-plan.md"
cp "$DEST/commands/token-audit.md"          "$HOME/.claude/commands/token-audit.md"
cp "$DEST/commands/launch-day-checklist.md" "$HOME/.claude/commands/launch-day-checklist.md"
echo "  /token-launch-plan, /token-audit, /launch-day-checklist registered"

echo ""
echo "Done. Add the following to your project's CLAUDE.md to activate:"
echo ""
echo "  See ~/.claude/skills/$SKILL_NAME/CLAUDE.md"
