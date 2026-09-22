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

## Bootstrap Packages

The repository maintains package manifests for applications and VS Code extensions.

### Windows applications

`packages/windows-winget.txt` contains the Windows applications that should be installed on a new machine.

The `run_onchange_install-windows-packages.ps1.tmpl` chezmoi script reads this manifest and installs the listed applications through `winget`.

To add an application:

1. Find its exact winget package ID.

2. Add the ID to `packages/windows-winget.txt`.

3. Run:

```powershell
chezmoi apply
```

The manifest checksum is included in the generated script, so changing the manifest automatically triggers the installation script.

### VS Code extensions

`packages/vscode-extensions.txt` contains the VS Code extensions that should be installed on a new machine.

The `run_onchange_install-vscode-extensions.ps1.tmpl` chezmoi script reads this manifest and installs the listed extensions through the VS Code CLI.

To add an extension:

1. List installed extensions with ` code --list-extensions `

2. Add its extension ID to `packages/vscode-extensions.txt`.

3. Run:

```powershell
chezmoi apply
```

The manifest checksum ensures that changes to the extension list trigger the script again.

The bootstrap process installs extensions listed in the manifest but does not remove extensions that are not listed.

### Current bootstrap flow

```text
Git
  ↓
chezmoi
  ↓
dotfiles
  ↓
Windows applications
  ↓
VS Code extensions
```

#### Nerd Fonts

Nerd Fonts are installed from the manifest:

`packages/nerd-fonts.txt`

Example:

```text
fira-mono
```

The installer is managed by:

`.chezmoiscripts/run_onchange_install-nerd-fonts.ps1.tmpl`

The script downloads the community PowerShell installer and installs every font listed in the manifest.

The manifest checksum is embedded in the chezmoi template, so changing `nerd-fonts.txt` automatically triggers the installer on the next:

```powershell
chezmoi apply
```

The installer runs with:

- `-Confirm:$false` for unattended installation.

- `UseBasicParsing` enabled through `$PSDefaultParameterValues` to avoid the Windows PowerShell 5.1 script-execution warning.

### Finding a Font Name

The installer provides a built-in font search/list function.

List all available fonts:

```powershell
& ([scriptblock]::Create((iwr 'https://to.loredo.me/Install-NerdFont.ps1'))) -List All
```

Search for a specific font:

```powershell
& ([scriptblock]::Create((iwr 'https://to.loredo.me/Install-NerdFont.ps1'))) -List "Fira*"
```

The value to use in `packages/nerd-fonts.txt` is the **`Name`** column, not `DisplayName`.

For example:

```text
Name       DisplayName
----       -----------
fira-code  FiraCode Nerd Font
fira-mono  FiraMono Nerd Font
```

The manifest should therefore contain:

```text
fira-mono
```

### Adding a Nerd Font

1. Find the font name using `-List`.

2. Add the `Name` value to `packages/nerd-fonts.txt`.

3. Run:

```powershell
chezmoi apply
```

For example:

```text
fira-mono
hack
jetbrains-mono
```

The manifest controls **installation only**. Removing a font from `nerd-fonts.txt` does not uninstall it from the machine.
