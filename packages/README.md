# Package Manifests

This directory contains package and extension manifests used by the bootstrap scripts.

These files are **Git-managed repository data**. They are intentionally ignored by chezmoi so that they remain in the source repository without being copied to the user's home directory.

## Files

### `windows-winget.txt`

Contains WinGet package IDs for applications that should be installed on a Windows machine.

Example:

```text
Git.Git
Microsoft.VisualStudioCode
MarkText.MarkText
Starship.Starship
Microsoft.WindowsTerminal
```

One package ID is specified per line.

Empty lines and lines beginning with `#` are ignored by the installer script.

### - `vscode-extensions.txt`

Contains VS Code extension IDs.

Example:

```text
golang.go
ms-python.python
ms-python.debugpy
ms-python.vscode-pylance
ms-python.vscode-python-envs
```

One extension ID is specified per line.

## Adding Packages

Add the package's exact identifier to the appropriate manifest.

For WinGet, the ID should be verified with:

```powershell
winget search <package>
```

For VS Code, use the extension's publisher and extension ID.

Avoid adding applications that are not part of the core development environment.

## 

## Relationship with chezmoi

The manifests are consumed by chezmoi templates/scripts but are not themselves target files.

Conceptually:

```text
packages/*.txt
      │
      │ Git
      ▼
GitHub repository
      │
      │ chezmoi init
      ▼
chezmoi source directory
      │
      │ template/include
      ▼
bootstrap scripts
      │
      ▼
WinGet / VS Code
```

The manifests therefore describe **what should be installed**, while the scripts describe **how it should be installed**.
