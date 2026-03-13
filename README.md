# OpenCode Install

Linux/macOS one-script installer for:

- latest `@anomalyco/opencode`
- optional `ohmyopencode`

## One-line install

Default (ask whether to install OhMyOpenCode):

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/TIZ36/opencodeinstall/main/install_opencode.sh)
```

Install OhMyOpenCode directly:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/TIZ36/opencodeinstall/main/install_opencode.sh) --with-ohmyopencode
```

Skip OhMyOpenCode:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/TIZ36/opencodeinstall/main/install_opencode.sh) --without-ohmyopencode
```

Alternative style:

```bash
curl -fsSL https://raw.githubusercontent.com/TIZ36/opencodeinstall/main/install_opencode.sh | bash -s -- --with-ohmyopencode
```

## Local run

```bash
chmod +x install_opencode.sh
./install_opencode.sh
```

## Options

- `--with-ohmyopencode`
- `--without-ohmyopencode`
- `-h`, `--help`
