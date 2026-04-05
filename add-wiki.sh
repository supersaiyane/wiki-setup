#!/bin/bash
set -euo pipefail

# ============================================================
# add-wiki.sh — Add a new app wiki to the Engineering Wiki
#
# Usage:
#   Method 1 (local folder):
#     ./add-wiki.sh --name "My App" --emoji "🚀" --path ./my-wiki-files/
#
#   Method 2 (GitHub wiki URL):
#     ./add-wiki.sh --name "My App" --emoji "🚀" --url https://github.com/user/repo
#
# Options:
#   --name    Display name for the wiki (required)
#   --emoji   Emoji for the homepage card (default: 📦)
#   --path    Path to a local folder containing .md files
#   --url     GitHub repo URL (will clone its wiki)
#   --repo    GitHub repo URL for the "View Repo" badge
#             (auto-detected from --url if provided)
# ============================================================

WIKI_NAME=""
WIKI_EMOJI="📦"
LOCAL_PATH=""
GITHUB_URL=""
REPO_URL=""

while [[ $# -gt 0 ]]; do
  case $1 in
    --name)  WIKI_NAME="$2"; shift 2 ;;
    --emoji) WIKI_EMOJI="$2"; shift 2 ;;
    --path)  LOCAL_PATH="$2"; shift 2 ;;
    --url)   GITHUB_URL="$2"; shift 2 ;;
    --repo)  REPO_URL="$2"; shift 2 ;;
    *) echo "Unknown option: $1"; exit 1 ;;
  esac
done

if [[ -z "$WIKI_NAME" ]]; then
  echo "Error: --name is required"
  echo "Usage: ./add-wiki.sh --name \"My App\" --emoji \"🚀\" --url https://github.com/user/repo"
  exit 1
fi

if [[ -z "$LOCAL_PATH" && -z "$GITHUB_URL" ]]; then
  echo "Error: Either --path or --url is required"
  exit 1
fi

# Derive folder name from wiki name (kebab-case)
FOLDER_NAME=$(echo "$WIKI_NAME" | tr '[:upper:]' '[:lower:]' | sed 's/ /-/g' | sed 's/[^a-z0-9-]//g')
DOCS_DIR="docs/$FOLDER_NAME"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Check if folder already exists
if [[ -d "$SCRIPT_DIR/$DOCS_DIR" ]]; then
  echo "Error: $DOCS_DIR already exists. Remove it first or choose a different name."
  exit 1
fi

# Auto-detect repo URL from GitHub URL
if [[ -n "$GITHUB_URL" && -z "$REPO_URL" ]]; then
  REPO_URL="$GITHUB_URL"
fi

if [[ -z "$REPO_URL" ]]; then
  REPO_URL="https://github.com/supersaiyane/PLACEHOLDER"
fi

echo "==> Adding wiki: $WIKI_NAME"
echo "    Folder: $DOCS_DIR"
echo "    Emoji:  $WIKI_EMOJI"

# ---- Step 1: Get the markdown files ----

if [[ -n "$GITHUB_URL" ]]; then
  TEMP_DIR=$(mktemp -d)

  # Detect if URL points to a subfolder (contains /tree/branch/path)
  if [[ "$GITHUB_URL" =~ (.+)/tree/([^/]+)/(.*) ]]; then
    # Method 2a: Clone repo and copy from subfolder
    REPO_BASE="${BASH_REMATCH[1]}"
    BRANCH="${BASH_REMATCH[2]}"
    SUBPATH="${BASH_REMATCH[3]}"

    if [[ -z "$REPO_URL" || "$REPO_URL" == *"PLACEHOLDER"* ]]; then
      REPO_URL="$REPO_BASE"
    fi

    echo "==> Cloning repo from $REPO_BASE (branch: $BRANCH, path: $SUBPATH) ..."
    if ! git clone --quiet --depth 1 --branch "$BRANCH" "$REPO_BASE.git" "$TEMP_DIR/repo" 2>/dev/null; then
      echo "Error: Could not clone repo."
      echo "       Tried: $REPO_BASE.git"
      rm -rf "$TEMP_DIR"
      exit 1
    fi

    SOURCE_DIR="$TEMP_DIR/repo/$SUBPATH"
    if [[ ! -d "$SOURCE_DIR" ]]; then
      echo "Error: Path '$SUBPATH' not found in repo."
      rm -rf "$TEMP_DIR"
      exit 1
    fi

    mkdir -p "$SCRIPT_DIR/$DOCS_DIR"
    find "$SOURCE_DIR" -maxdepth 1 -name "*.md" -exec cp {} "$SCRIPT_DIR/$DOCS_DIR/" \;
    MD_COUNT=$(find "$SCRIPT_DIR/$DOCS_DIR" -name "*.md" | wc -l | tr -d ' ')
    echo "==> Copied $MD_COUNT markdown files from $SUBPATH/"
  else
    # Method 2b: Clone from GitHub wiki (.wiki.git)
    WIKI_GIT_URL="${GITHUB_URL%.git}.wiki.git"

    echo "==> Cloning wiki from $WIKI_GIT_URL ..."
    if ! git clone --quiet "$WIKI_GIT_URL" "$TEMP_DIR/wiki" 2>/dev/null; then
      echo "Error: Could not clone wiki. Make sure the repo has a wiki enabled."
      echo "       Tried: $WIKI_GIT_URL"
      rm -rf "$TEMP_DIR"
      exit 1
    fi

    mkdir -p "$SCRIPT_DIR/$DOCS_DIR"
    find "$TEMP_DIR/wiki" -maxdepth 1 -name "*.md" -exec cp {} "$SCRIPT_DIR/$DOCS_DIR/" \;
    MD_COUNT=$(find "$SCRIPT_DIR/$DOCS_DIR" -name "*.md" | wc -l | tr -d ' ')
    echo "==> Copied $MD_COUNT markdown files"
  fi

  rm -rf "$TEMP_DIR"
else
  # Method 1: Copy from local path
  if [[ ! -d "$LOCAL_PATH" ]]; then
    echo "Error: $LOCAL_PATH is not a directory"
    exit 1
  fi

  mkdir -p "$SCRIPT_DIR/$DOCS_DIR"
  # Copy all markdown files
  find "$LOCAL_PATH" -maxdepth 1 -name "*.md" -exec cp {} "$SCRIPT_DIR/$DOCS_DIR/" \;
  MD_COUNT=$(find "$SCRIPT_DIR/$DOCS_DIR" -name "*.md" | wc -l | tr -d ' ')
  echo "==> Copied $MD_COUNT markdown files"
fi

if [[ "$MD_COUNT" -eq 0 ]]; then
  echo "Warning: No .md files found. The wiki will be empty."
fi

# ---- Step 1b: Fix MDX-incompatible angle brackets ----
# MDX treats <word> as JSX tags even inside backtick spans.
# Replace < and > with HTML entities in .md files (skip fenced code blocks).
for md_file in "$SCRIPT_DIR/$DOCS_DIR"/*.md; do
  [[ -f "$md_file" ]] || continue
  python3 -c "
import re, sys
text = open(sys.argv[1]).read()
parts = re.split(r'(\`\`\`[\s\S]*?\`\`\`)', text)
for i in range(0, len(parts), 2):
    # Outside fenced code blocks: escape bare <word> patterns
    parts[i] = re.sub(r'<([a-zA-Z][a-zA-Z0-9_-]*)>', r'\&lt;\1\&gt;', parts[i])
open(sys.argv[1], 'w').write(''.join(parts))
" "$md_file"
done
echo "==> Sanitized angle brackets for MDX compatibility"

# ---- Step 2: Count existing wikis (for position) ----
POSITION=$(find "$SCRIPT_DIR/docs" -maxdepth 1 -type d | wc -l | tr -d ' ')

# ---- Step 3: Create _category_.json ----
cat > "$SCRIPT_DIR/$DOCS_DIR/_category_.json" <<EOF
{
  "label": "$WIKI_NAME",
  "position": $POSITION,
  "link": {
    "type": "doc",
    "id": "$FOLDER_NAME/index"
  }
}
EOF
echo "==> Created _category_.json"

# ---- Step 4: Create index.mdx with repo badge ----
cat > "$SCRIPT_DIR/$DOCS_DIR/index.mdx" <<EOF
import DocCardList from '@theme/DocCardList';

# $WIKI_NAME

Documentation for $WIKI_NAME

[![GitHub Repo](https://img.shields.io/badge/GitHub-Repo-blue?logo=github)]($REPO_URL)

<DocCardList />
EOF
echo "==> Created index.mdx"

# ---- Step 5: Add card to homepage ----
INDEX_FILE="$SCRIPT_DIR/src/pages/index.tsx"
if grep -q "name: '$WIKI_NAME'" "$INDEX_FILE" 2>/dev/null; then
  echo "==> Homepage card already exists, skipping"
else
  # Insert new card before the closing ];
  TEMP_FILE=$(mktemp)
  ENTRY_FILE=$(mktemp)
  cat > "$ENTRY_FILE" <<CARD
  {
    name: '$WIKI_NAME',
    description: 'Documentation for $WIKI_NAME',
    path: '/docs/$FOLDER_NAME/',
    emoji: '$WIKI_EMOJI',
  },
CARD
  while IFS= read -r line; do
    if [[ "$line" == "];" ]]; then
      cat "$ENTRY_FILE"
    fi
    printf '%s\n' "$line"
  done < "$INDEX_FILE" > "$TEMP_FILE"
  mv "$TEMP_FILE" "$INDEX_FILE"
  rm -f "$ENTRY_FILE"
  echo "==> Added homepage card"
fi

echo ""
echo "Done! Wiki '$WIKI_NAME' is ready."
echo ""
echo "Next steps:"
echo "  1. Update the repo URL in $DOCS_DIR/index.mdx (if placeholder)"
echo "  2. Run 'npm start' to preview"
echo "  3. Commit and push to deploy"
