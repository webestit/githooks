![License: MIT License](https://img.shields.io/badge/License-mit-blue.svg)
![Latest Stable Version](https://img.shields.io/packagist/v/webestit/githooks.svg)
![Total Downloads](https://img.shields.io/packagist/dt/webestit/githooks.svg)
![GitHub issues](https://img.shields.io/github/issues/webestit/githooks.svg)
![GitHub forks](https://img.shields.io/github/forks/webestit/githooks.svg?style=social)
![GitHub stars](https://img.shields.io/github/stars/webestit/githooks.svg?style=social)

# 🪝 Repository-Managed Git Hooks

This package allows you to manage Git hooks centrally within your repository.
It's language-agnostic and only requires Git and a POSIX-compliant shell (like `sh`, `bash`, `dash`, or `zsh`).

## 🚀 Installation

1. Add post-install/update scripts to your composer.json
   <br>(so the package automatically configures git hooks):
   ```json
   {
       "scripts": {
           "post-install-cmd": [
              "@composer exec githooks install"
           ],
           "post-update-cmd": [
              "@composer exec githooks install"
           ]
       }
   }
   ```

2. Install the package:
   ```bash
   composer require webestit/githooks
   ```

The package will automatically:

1. Configure `core.hooksPath` to point to its own `hooks` directory.
2. Create a `.githooks` directory in your project root with subdirectories for common hooks.

## ℹ️ How it works

- The package sets Git's `core.hooksPath` to its directory which contains [all Git hooks](https://git-scm.com/docs/githooks).
- Every Git hook executes all executable scripts found in your project's `.githooks/<hook-name>/` directory.
- Scripts are executed in **alphabetical order** (e.g., `01-check.sh`, `02-test.sh`).

## ➕ Adding hooks to your project

1. Go to the `.githooks/<hook-name>/` directory in your project root.
2. Add your shell script:
   ```bash
   # Example: .githooks/pre-commit/01-lint.sh
   #!/bin/sh
   echo "Running linter..."
   # your logic here
   ```
3. Make it executable:
   ```bash
   chmod +x .githooks/pre-commit/01-lint.sh
   ```

## 💡 Examples

You can find example hooks in the package's `examples` directory. Feel free to copy and adapt them to your project's
`.githooks/` folder.

## ⚠️ Bypassing hooks temporarily

You can bypass hooks using `--no-verify`:

```sh
git commit --no-verify
```

## ⚠️ Disabling repository hooks

To stop using these managed hooks and return to Git defaults:

```sh
git config --unset core.hooksPath
```
