# Infinite Night Shift

A macOS menu bar app that keeps Night Shift permanently enabled. Whenever macOS or a schedule turns Night Shift off, the app immediately re-enables it.

## Features

- Sits in the menu bar — no Dock icon
- Automatically re-enables Night Shift when the system turns it off
- Pause/resume enforcement from the menu bar
- Optional launch at login
- Polls every 60 seconds as a fallback

## Requirements

- macOS 14 (Sonoma) or later

## Installation

Download the latest DMG from [Releases](https://github.com/denizmaral/InfiniteNightShift/releases), open it, and drag the app to Applications.

> Since the app uses a private macOS framework, it is not notarized. On first launch you may need to go to **System Settings > Privacy & Security** and click **Open Anyway**.

## Building from Source

```bash
git clone https://github.com/denizmaral/InfiniteNightShift.git
cd InfiniteNightShift/InfiniteNightShift
bash build.sh
```

The app bundle will be at `.build/InfiniteNightShift.app`.

## How It Works

The app uses Apple's private `CoreBrightness` framework (`CBBlueLightClient`) to monitor and control Night Shift. It listens for status change notifications and re-enables Night Shift whenever it detects it has been turned off. A 60-second polling timer acts as a safety net.

## License

MIT
