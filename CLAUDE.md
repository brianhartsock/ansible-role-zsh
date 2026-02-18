# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Ansible role that installs ZSH and optionally ZSH completions. Supports Ubuntu (22.04, 24.04) and macOS. Published to Ansible Galaxy as `brianhartsock.zsh`.

## Common Commands

```bash
# Install dependencies
uv sync

# Linting
uv run ansible-lint
uv run yamllint .
uv run flake8

# Run all pre-commit hooks
uv run pre-commit run --all-files

# Run full test suite (default scenario: Ubuntu 22.04, 24.04 in Docker)
uv run molecule test

# Run check mode tests (Ubuntu 24.04 only)
uv run molecule test -s check_mode

# Run individual molecule steps (useful during development)
uv run molecule create          # Start Docker containers
uv run molecule converge        # Run the role
uv run molecule verify          # Run TestInfra tests only
uv run molecule destroy         # Cleanup containers
```

## Architecture

**Task flow** (`tasks/main.yml`): OS-specific install → get ZSH path → change user's default shell to ZSH.

Platform-specific installation is dispatched via `include_tasks: install-{{ ansible_os_family }}.yml`:
- `install-Darwin.yml` — Homebrew-based install of `zsh` and `zsh-completions`, adds shell to `/etc/shells`
- `install-Debian.yml` — apt-based install, optionally adds OpenSUSE repo for ZSH completions
- `install.yml` — generic fallback using the `package` module

**Role variables** (defined in `defaults/main.yml`):
- `zsh_install_completions` (bool, default: false) — whether to install ZSH completions
- `zsh_completions_deb_url` — URL for the Debian completions package repository

**Testing**: Molecule with Docker driver. TestInfra tests live in `molecule/default/tests/test_default.py`. The `prepare.yml` playbooks install prerequisites (apt cache update, GPG) before converge.

## CI

GitHub Actions runs lint (ansible-lint, yamllint, flake8) and both molecule scenarios on PRs and pushes to master. Releases to Ansible Galaxy are triggered by GitHub release events.
