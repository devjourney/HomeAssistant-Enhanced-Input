# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Home Assistant custom integration (`enhanced_input`) that provides services to create and manage long text input entities. Useful for storing notes, logs, or AI LLM responses. Fork of [yohaybn/HomeAssistant-Enhanced-Input](https://github.com/yohaybn/HomeAssistant-Enhanced-Input).

## Architecture

All integration code lives in `custom_components/enhanced_input/`. There are no tests, no build step, and no local linting configured.

### Key Files

- **`__init__.py`** — The entire integration logic: setup functions, service handlers, entity class, and persistence. Contains:
  - `async_setup()` / `async_setup_entry()` / `async_unload_entry()` — Integration lifecycle
  - `handle_create_input_text()` / `handle_delete_input_text()` — Service handlers (nested in `async_setup_entry`)
  - `LongTextInputEntity(Entity)` — The entity class; state = title, attributes = `long_text` + `length`
- **`config_flow.py`** — Minimal singleton config flow (empty schema, aborts if already configured)
- **`services.yaml`** — Service definitions for `create_input_text` and `delete_input_text`
- **`manifest.json`** — Integration metadata (domain: `enhanced_input`, version managed by CI)

### Data Flow

1. Integration registers via config flow (singleton — only one instance allowed)
2. `async_setup_entry` loads persisted entities from HA's `Store` (key: `enhanced_input_storage`)
3. Services create/update/delete `LongTextInputEntity` instances managed by an `EntityComponent`
4. Entity changes are auto-persisted to storage via a shared mutable dict + save callback
5. Entity IDs follow pattern: `enhanced_input.<name_lowered_underscored>`

### Important Patterns

- Entities share a mutable `stored_data_dict` and a `save_persistent_data` callback closure (both created in `async_setup_entry`)
- Entity lookup for services uses `hass.data[DOMAIN][entry.entry_id]` dict, not HA's entity registry
- The `update_text()` / `update_title()` methods fire background saves via `hass.async_create_task()`

## Validation

No local test suite exists. CI runs two validators on push/PR:

```bash
# These run in GitHub Actions only, not locally
# hassfest: validates integration structure against HA requirements
# HACS Action: validates HACS integration requirements
```

To validate locally, install the integration into a Home Assistant dev environment and test the services manually.

## Release Process

Releases are created via GitHub Releases. The CI workflow:
1. Runs `update_manifest.py` to set the version from the git tag
2. Zips `custom_components/enhanced_input/`
3. Uploads the zip as a release asset

## Domain Constants

```
DOMAIN = "enhanced_input"
STORAGE_KEY = "enhanced_input_storage"
STORAGE_VERSION = 1
```
