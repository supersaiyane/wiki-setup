# Engineering Wiki

A single, modern website that hosts all your app documentation (wikis) in one place. Instead of jumping between scattered GitHub wikis, READMEs, and Notion pages, you drop your markdown files here and get a clean, searchable, installable documentation site.

Built with [Docusaurus](https://docusaurus.io/). Deployed to [GitHub Pages](https://pages.github.com/).

**Live site:** [https://supersaiyane.github.io/wiki-setup/](https://supersaiyane.github.io/wiki-setup/)

---

## What This Project Does

- Hosts documentation for **multiple apps** on a single site
- Each app gets its own sidebar section and landing page
- Homepage shows all apps as clickable cards
- Works with plain `.md` files -- no special format needed
- Installable as a desktop/mobile app (PWA)
- Auto-deploys to GitHub Pages on every push

---

## Prerequisites

- [Node.js](https://nodejs.org/) (v18 or later)
- [npm](https://www.npmjs.com/) (comes with Node.js)
- [Git](https://git-scm.com/)

---

## Getting Started

### 1. Clone and install

```bash
git clone https://github.com/supersaiyane/wiki-setup.git
cd wiki-setup
npm install
```

### 2. Start the dev server

```bash
npm start
```

Open [http://localhost:3000/wiki-setup/](http://localhost:3000/wiki-setup/) in your browser.

### 3. Build for production

```bash
npm run build
```

---

## How to Add a New Wiki

You have **two options**. Pick whichever is easier for you.

### Option A: Use the script (recommended)

The `add-wiki.sh` script does everything automatically -- creates the folder, config files, index page, and homepage card.

**From a GitHub repo subfolder:**

```bash
./add-wiki.sh --name "My App" --emoji "🚀" --url https://github.com/username/repo/tree/main/docs
```

**From a GitHub wiki:**

```bash
./add-wiki.sh --name "My App" --emoji "🚀" --url https://github.com/username/repo
```

**From a local folder of markdown files:**

```bash
./add-wiki.sh --name "My App" --emoji "🚀" --path ./path/to/md-files/
```

**With a custom repo link on the landing page:**

```bash
./add-wiki.sh --name "My App" --emoji "🚀" --path ./md-files/ --repo https://github.com/username/repo
```

After running the script, start the dev server (`npm start`) and your new wiki is live.

### Option B: Do it manually

#### Step 1 -- Create a folder under `docs/`

```
docs/
  my-app/
    getting-started.md
    architecture.md
    deployment.md
```

Drop all your `.md` files in there.

#### Step 2 -- Add `_category_.json`

Create `docs/my-app/_category_.json`:

```json
{
  "label": "My App",
  "position": 4,
  "link": {
    "type": "doc",
    "id": "my-app/index"
  }
}
```

Change `position` to control the sidebar order (lower = higher up).

#### Step 3 -- Add `index.mdx`

Create `docs/my-app/index.mdx`:

```mdx
import DocCardList from '@theme/DocCardList';

# My App

Documentation for My App

[![GitHub Repo](https://img.shields.io/badge/GitHub-Repo-blue?logo=github)](https://github.com/username/repo)

<DocCardList />
```

> **Important:** The `import` line must be at the very top of the file.

#### Step 4 -- Add a card to the homepage

Open `src/pages/index.tsx` and add an entry to the `apps` array:

```typescript
{
  name: 'My App',
  description: 'Short description of what this app does.',
  path: '/docs/my-app/',
  emoji: '🚀',
},
```

That's it. Run `npm start` to see your new wiki.

---

## How to Remove a Wiki

1. Delete the folder from `docs/` (e.g., `rm -rf docs/my-app`)
2. Remove the card entry from `src/pages/index.tsx`

---

## Project Structure

```
wiki-setup/
|-- docs/                       # All wiki content
|   |-- Vault/                  # One folder per app
|   |   |-- _category_.json    # Sidebar config
|   |   |-- index.mdx          # Landing page
|   |   |-- *.md               # Wiki pages
|   |-- jogi/
|   |-- AI-RCA/
|-- src/
|   |-- pages/index.tsx         # Homepage (app cards)
|   |-- css/custom.css          # Theme and styles
|-- docusaurus.config.ts        # Site config (title, navbar, footer)
|-- sidebars.ts                 # Auto-generated sidebar
|-- add-wiki.sh                 # CLI to add new wikis
|-- package.json
```

---

## Customization

### Site title and tagline

Edit `docusaurus.config.ts`:

```typescript
title: 'Engineering Wiki',
tagline: 'All my apps, one place to read them all',
```

### Navbar links (top-right)

Edit `themeConfig.navbar.items` in `docusaurus.config.ts`.

### Footer links

Edit `themeConfig.footer.links` in `docusaurus.config.ts`.

### Colors and theme

Edit `src/css/custom.css`. The primary color is set via `--ifm-color-primary`.

---

## Deployment

### Automatic (GitHub Pages)

Every push to `main` triggers the GitHub Actions workflow at `.github/workflows/deploy.yml`, which builds and deploys to GitHub Pages automatically.

### Manual

```bash
npm run build
npm run deploy
```

---

## Troubleshooting

### Build error: "Expected a closing tag for `<something>`"

Your markdown has angle brackets (like `<KEY>` or `<form>`) outside of code blocks. MDX treats them as JSX tags. Fix by wrapping in backticks:

```
Wrong:  vault-<ns>.enc
Right:  `vault-<ns>.enc`
```

### Build error: "Can't resolve '@site/docs/...'"

The `import` statement in an `.mdx` file is not at the top. Move it to line 1:

```mdx
import DocCardList from '@theme/DocCardList';

# Title goes after the import
```

### Port already in use

```bash
lsof -ti:3000 | xargs kill -9
npm start
```

---

## Configuration Reference

| File | What it controls |
|------|-----------------|
| `docusaurus.config.ts` | Site title, URL, navbar, footer, plugins |
| `sidebars.ts` | Sidebar (auto-generated from `docs/` folders) |
| `src/pages/index.tsx` | Homepage layout and app cards |
| `src/css/custom.css` | Theme colors, fonts, styles |
| `docs/<app>/_category_.json` | Sidebar label and position for each wiki |
| `docs/<app>/index.mdx` | Wiki landing page with GitHub repo badge |
| `add-wiki.sh` | CLI script to add new wikis |
| `.github/workflows/deploy.yml` | GitHub Actions deploy pipeline |
| `static/manifest.json` | PWA (installable app) config |

---

## PWA Support

The site is installable as a desktop or mobile app. Visitors see an install prompt when they visit. This is configured via `@docusaurus/plugin-pwa` in `docusaurus.config.ts`.
