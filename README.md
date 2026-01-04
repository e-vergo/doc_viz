# Lean Docs Syntax Highlighter

A Safari Web Extension that adds dark mode and syntax highlighting to the [Lean 4 language reference documentation](https://lean-lang.org/doc/reference/latest/).

## Problem

The official Lean reference documentation at `lean-lang.org/doc/reference` renders code examples in a monochrome light theme with no syntax highlighting. This makes the code difficult to read, especially for users with reading comprehension challenges or those accustomed to syntax-highlighted editors.

Meanwhile, the interactive Lean playground at `live.lean-lang.org` displays the same code with full syntax highlighting on a dark background - much easier to parse visually.

This extension bridges that gap by injecting CSS that transforms the documentation to match the playground's appearance.

## How It Works

### The Key Insight

The Lean reference manual is built using [Verso](https://github.com/leanprover/verso), a custom documentation framework written in Lean itself. Verso uses [SubVerso](https://github.com/leanprover/subverso) for syntax highlighting, which outputs **semantic CSS classes** on code tokens:

| Class | Purpose |
|-------|---------|
| `.hl.lean` | Wrapper for all Lean code blocks |
| `.keyword` | Language keywords (`def`, `structure`, `where`, `theorem`, etc.) |
| `.const` | Constants and constructors |
| `.var` | Variables |
| `.literal` | String and numeric literals |
| `.sort` | Sorts (`Type`, `Prop`, etc.) |
| `.comment` | Comments |

These classes exist in the production HTML but have minimal color styling applied. This extension simply injects a stylesheet that applies colors and dark backgrounds to these existing semantic classes.

### Why This Approach Works

- **No scraping or transformation needed** - we're just adding CSS
- **Semantic highlighting** - colors reflect actual token types from Lean's parser, not regex guesses
- **Stable** - class names are unlikely to change since they're tied to Lean's AST
- **Lightweight** - pure CSS injection, no JavaScript manipulation of the DOM

## Project Structure

```
doc_viz/
├── README.md                          # This file
├── docs.png                           # Screenshot: original docs (light, no highlighting)
├── live_lean.png                      # Screenshot: live playground (dark, highlighted)
├── .gitignore                         # Includes Xcode build artifacts
│
└── Lean Docs Highlighter/             # Xcode project directory
    ├── build.sh                       # Command-line build script
    ├── run.sh                         # Build + launch + open Safari prefs
    ├── README.md                      # Quick setup instructions
    │
    ├── Lean Docs Highlighter.xcodeproj/   # Xcode project (auto-generated)
    │
    ├── Shared (Extension)/
    │   └── Resources/
    │       ├── manifest.json          # Extension manifest (target URLs, permissions)
    │       ├── content.css            # THE MAIN FILE: dark theme + syntax colors
    │       ├── content.js             # Minimal JS (Xcode template, mostly unused)
    │       ├── background.js          # Background script (Xcode template)
    │       ├── popup.html/css/js      # Toolbar popup (Xcode template)
    │       ├── images/                # Extension icons
    │       └── _locales/en/messages.json  # Extension name/description
    │
    ├── Shared (App)/                  # Container app resources (Xcode template)
    ├── macOS (App)/                   # macOS app wrapper (Xcode template)
    ├── macOS (Extension)/             # macOS extension target (Xcode template)
    └── iOS (App|Extension)/           # iOS targets (unused, can be deleted)
```

### Key Files

**`Shared (Extension)/Resources/content.css`** - This is the core of the extension. Contains:
- CSS custom properties for all colors (easy theming)
- Dark mode base styles (backgrounds, text colors, links)
- Syntax highlighting rules for each token class
- Styles for interactive elements (tooltips, tactic states)
- Scrollbar and selection styling

**`Shared (Extension)/Resources/manifest.json`** - Defines:
- Target URL patterns: `https://lean-lang.org/doc/reference/*`
- Content scripts to inject (content.css, content.js)
- Extension metadata and icons

## Building and Running

### Prerequisites

- macOS with Xcode installed
- Safari 14+ (included with macOS Big Sur and later)

### Option 1: Command Line

```bash
cd "Lean Docs Highlighter"
./build.sh    # Build the extension
./run.sh      # Build, launch app, open Safari Extensions prefs
```

### Option 2: Xcode

1. Open `Lean Docs Highlighter.xcodeproj`
2. Select scheme "Lean Docs Highlighter (macOS)"
3. Press Cmd+R to build and run

### Enabling in Safari

1. The container app will launch briefly (this registers the extension)
2. Open Safari → Settings → Extensions
3. Check "Lean Docs Highlighter"
4. Grant permission for `lean-lang.org` when prompted

**Note for development:** You may need to enable Safari → Develop → Allow Unsigned Extensions. Enable the Develop menu first in Safari → Settings → Advanced → Show Develop menu.

## Customizing Colors

Edit `Shared (Extension)/Resources/content.css`. All colors are defined as CSS custom properties at the top:

```css
:root {
  /* Backgrounds */
  --bg-primary: #1e1e1e;
  --bg-secondary: #252526;
  --bg-code: #1a1a1a;

  /* Syntax colors (VS Code dark inspired) */
  --syn-keyword: #569cd6;    /* blue */
  --syn-const: #dcdcaa;      /* yellow/gold */
  --syn-var: #9cdcfe;        /* light blue */
  --syn-literal: #ce9178;    /* orange */
  --syn-sort: #4ec9b0;       /* teal/green */
  --syn-comment: #6a9955;    /* green */
}
```

After editing, rebuild with `./build.sh` and refresh the docs page.

## Debugging

### Extension not appearing in Safari

- Ensure you built the main app target, not just the extension
- Enable Safari → Develop → Allow Unsigned Extensions
- Check Console.app for Safari extension errors

### Styles not applying

1. Check Safari → Settings → Extensions → Lean Docs Highlighter → Website Access
2. Ensure `lean-lang.org` is in the allowed list
3. Open Safari Web Inspector (Cmd+Option+I) on a docs page
4. Check if `content.css` is loaded in the Sources tab
5. Inspect code elements to verify CSS classes exist (`.keyword`, `.const`, etc.)

### Colors look wrong or incomplete

The Lean docs may have updated their CSS class names. To investigate:

1. Open Safari Web Inspector on a docs page
2. Inspect a code block element
3. Look at the class names on `<span>` elements within code
4. Compare with the selectors in `content.css`
5. Update selectors as needed

## Technical Context

### Verso Documentation System

The Lean reference manual source lives at [github.com/leanprover/reference-manual](https://github.com/leanprover/reference-manual). Key points:

- Written in Lean itself using Verso markup
- Code examples are type-checked during doc generation
- SubVerso provides semantic highlighting based on Lean's actual parser
- Output is static HTML with CSS classes for token types
- The production site has CSS for these classes but uses minimal coloring

### Safari Web Extension Architecture

Safari Web Extensions use the WebExtension API (same as Chrome/Firefox) but require:

- An Xcode project with a container app
- The extension is bundled inside the `.app` as a `.appex` plugin
- For distribution: Apple Developer account and notarization
- For personal use: runs in development mode (re-enable after Safari restarts)

### Why Safari-Specific?

The user exclusively uses Safari on Apple Silicon Macs. The same `content.css` could be adapted for Chrome/Firefox extensions with minimal changes to the manifest format.

## Future Improvements

Potential enhancements (not currently implemented):

- **Toggle switch** - Add popup UI to enable/disable dark mode
- **Theme options** - Multiple color schemes (Solarized, Monokai, etc.)
- **Font customization** - User-selectable monospace fonts
- **Sync with system** - Auto-switch light/dark based on macOS appearance
- **Chrome/Firefox ports** - Cross-browser support

## License

Personal use project. The Lean documentation itself is maintained by the Lean community at [leanprover/reference-manual](https://github.com/leanprover/reference-manual).
