# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

A SAP CAP (Cloud Application Programming Model) project for a Vacation & Traveller Management application. Currently the data model (`db/`) is built out; `srv/` (service layer) and `app/` (UI) are scaffolded but empty — no `.cds` service definitions exist yet.

## Commands

- `cds watch` — start the dev server with live reload (default VS Code build task). Serves an OData/Fiori preview and picks up `db/` and `srv/` changes automatically.
- `cds serve --with-mocks --in-memory?` — serve with an in-memory SQLite DB and mocked services (VS Code task "cds serve").
- `npm start` — runs `cds-serve` (production-style start, no watch).
- `cds compile srv --to edmx` — validate/compile service definitions to EDMX once `srv/` has content.
- `cds compile db/schema.cds` — compile the data model alone to check for CDS syntax errors.

There are no lint/test scripts defined in `package.json` yet; `eslint.config.mjs` extends `@sap/cds/eslint.config.mjs` (`cds.recommended`) but no `lint` script is wired up — run `npx eslint .` directly if needed.

## Architecture

- **`db/common.cds`** — single source of truth for reusable/shared artifacts: SAP CodeList entities (`AddressTypes`, `TravellerStatus`, `Roles`) and the association types built on them (`AddressType`, `Status`, `Role`). All namespace is `anubhav.claude`.
- **`db/schema.cds`** — the business entities (`Destinations`, `Travellers`, `Contacts`, `Vacations`, `AppUsers`), importing shared types from `common.cds` rather than redefining them. `Travellers` is the aggregate root: it composes `Contacts`, `Destinations` (address), and `Vacations`, and is referenced by `AppUsers`.
- **`db/data/*.csv`** — seed data, one CSV per entity, named `anubhav.claude-<EntityName>.csv` (must match the fully-qualified entity name for CAP to auto-load it). CodeList seed files (`AddressTypes`, `Roles`, `TravellerStatus`) define the valid `code` values referenced by `schema.cds` associations — check these when adding new status/role/address-type values instead of hardcoding elsewhere.
- **`db/i18n/`** — all UI-facing labels (`@title` annotations in `schema.cds`/`common.cds`) resolve to `{i18n>Key}` bundle keys defined here. `i18n.properties` is the language-neutral baseline (also mirrored in `i18n_en.properties`); `i18n_ko.properties` is the Korean translation. When adding a field with a `@title`, add the corresponding key to the baseline file(s) first.
- **`srv/`, `app/`** — empty; service definitions (`.cds` + handler `.js`) and UI (Fiori elements / freestyle) have not been created yet.

## i18n workflow

Two custom slash commands manage translations and expect the structure above:
- `/cap-add-language <code>` — adds a new `i18n_<code>.properties` file by translating all keys from the baseline.
- `/cap-lang-check` — audits all `i18n_*.properties` files in `db/i18n/` (and any future `srv/i18n/`, `app/*/i18n/`) for missing/orphan/empty/duplicate keys relative to the baseline.

When editing entities, keep every `@title: '{i18n>Key}'` reference in sync across all `i18n_*.properties` files (or note gaps for these commands to fix).