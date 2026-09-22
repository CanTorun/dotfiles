# Dotfiles

Personal Windows development environment managed with [chezmoi](https://www.chezmoi.io/) and Git.

The repository contains configuration files and bootstrap scripts used to recreate the development environment on a new Windows machine.

## Philosophy

This repository is the source of truth for the parts of the Windows environment that should be reproducible.

When setting up a new machine:

```text
New Windows installation
        ↓
Install Git + chezmoi
        ↓
chezmoi init
        ↓
Review chezmoi diff
        ↓
chezmoi apply
        ↓
Development environment restored
```

### Goals

- Recreate the development environment with minimal manual setup.

- Keep configuration and installation manifests version-controlled.

- Make changes reproducible across Windows machines.

- Keep machine-specific or unrelated data outside the bootstrap system.

## Bootstrap

### 1. Install prerequisites

Install Git and chezmoi on the new machine.

- ` winget install Git.Git `

- ` winget install twpayne.chezmoi `

### 2. Initialize chezmoi

```powershell
chezmoi init https://github.com/CanTorun/dotfiles.git
```

### 3. Review changes

Always inspect what chezmoi is going to change before applying it:

```powershell
chezmoi diff
```

### 4. Apply

```powershell
chezmoi apply
```

The chezmoi scripts will install the applications defined in the package manifests.

## Package Management

Windows applications are listed in:

```text
packages/windows-winget.txt
```

VS Code extensions are listed separately in:

```text
packages/vscode-extensions.txt
```

The `packages/` directory is intentionally ignored by chezmoi. These files are repository data used by bootstrap scripts, not files that should be copied to the target machine.

See [packages/README.md](packages/README.md) for details.

## Repository Structure

```text
.
├── .chezmoiscripts/          # Bootstrap and automation scripts
├── .config/                  # Application configuration
├── packages/                 # Installation manifests
├── Documents/                # Windows user documents/configuration
├── .gitconfig                # Git configuration
└── README.md
```

## Making Changes

Normal Git operations should be performed through chezmoi:

```powershell
chezmoi git -- status
chezmoi git -- add <file>
chezmoi git -- commit -m "message"
chezmoi git -- push
```

This avoids working directly inside chezmoi's source directory during normal use.

### Adding a Windows application

Add its WinGet package ID to:

```text
packages/windows-winget.txt
```

The Windows package installation script uses the manifest checksum to detect changes. When the manifest changes, the `run_onchange_` script runs again during `chezmoi apply`.

### Adding VS Code extensions

Add the extension ID to:

```text
packages/vscode-extensions.txt
```

The VS Code extension installer will use this manifest once that bootstrap step is configured.
