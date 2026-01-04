# Lean Docs Highlighter - Extension

Safari Web Extension that adds dark mode and syntax highlighting to Lean documentation.

See the [project README](../README.md) for full documentation.

## Quick Start

```bash
./build.sh    # Build via command line
./run.sh      # Build + launch + open Safari Extensions prefs
```

Or open `Lean Docs Highlighter.xcodeproj` in Xcode and press Cmd+R.

## Files

| File | Purpose |
|------|---------|
| `Shared (Extension)/Resources/content.css` | Dark theme + syntax highlighting (edit this) |
| `Shared (Extension)/Resources/manifest.json` | Target URLs and extension config |
| `build.sh` | Command-line build script |
| `run.sh` | Build, launch, open Safari prefs |

## Iterating

1. Edit `Shared (Extension)/Resources/content.css`
2. Run `./build.sh`
3. Refresh the Lean docs page in Safari
