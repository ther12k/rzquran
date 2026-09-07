---
type: Reference
title: Official technical source register
description: Primary sources checked for format, export, platform and GitHub behavior.
tags:
- rz-quran-kids
- godot-mvp
status: draft
generated:
  by: chatgpt/rzq-godot-mvp-1.0
  at: '2026-09-07T07:53:44Z'
sources:
- id: okf
  resource: https://raw.githubusercontent.com/GoogleCloudPlatform/knowledge-catalog/main/okf/SPEC.md
  title: Google Cloud Platform — OKF specification v0.2
- id: web
  resource: https://docs.godotengine.org/en/stable/tutorials/export/exporting_for_web.html
  title: Godot — Exporting for the Web
- id: android
  resource: https://docs.godotengine.org/en/stable/tutorials/export/exporting_for_android.html
  title: Godot — Exporting for Android
- id: ios
  resource: https://docs.godotengine.org/en/stable/tutorials/export/exporting_for_ios.html
  title: Godot — Exporting for iOS
- id: bridge
  resource: https://docs.godotengine.org/en/stable/classes/class_javascriptbridge.html
  title: Godot — JavaScriptBridge
- id: http
  resource: https://docs.godotengine.org/en/stable/tutorials/networking/http_request_class.html
  title: Godot — Making HTTP requests
- id: layout
  resource: https://docs.godotengine.org/en/stable/tutorials/ui/gui_containers.html
  title: Godot — Using Containers
- id: i18n
  resource: https://docs.godotengine.org/en/stable/tutorials/i18n/internationalizing_games.html
  title: Godot — Internationalizing games
- id: a11y
  resource: https://docs.godotengine.org/en/stable/classes/class_displayserver.html
  title: Godot — DisplayServer accessibility support
- id: gh-issue
  resource: https://cli.github.com/manual/gh_issue_create
  title: GitHub CLI — gh issue create
- id: gh-api
  resource: https://cli.github.com/manual/gh_api
  title: GitHub CLI — gh api
- id: gh-label
  resource: https://cli.github.com/manual/gh_label_create
  title: GitHub CLI — gh label create
- id: gh-milestone
  resource: https://docs.github.com/en/rest/issues/milestones?apiVersion=2022-11-28
  title: GitHub REST — issue milestones
x_rzq:
  bundle_version: '1.0'
  review_state: unreviewed
  language: en
  ui_language: id
---

# Official sources

Accessed for this package on 2026-09-07. The `/stable/` Godot documentation and upstream OKF `main` are moving references; implementation must pin actual tools and record any changed constraint. These links are technical references, not sources of content licenses or religious approval.

| ID | Source | Resource |
|---|---|---|
| `okf` | Google Cloud Platform — OKF specification v0.2 | https://raw.githubusercontent.com/GoogleCloudPlatform/knowledge-catalog/main/okf/SPEC.md |
| `web` | Godot — Exporting for the Web | https://docs.godotengine.org/en/stable/tutorials/export/exporting_for_web.html |
| `android` | Godot — Exporting for Android | https://docs.godotengine.org/en/stable/tutorials/export/exporting_for_android.html |
| `ios` | Godot — Exporting for iOS | https://docs.godotengine.org/en/stable/tutorials/export/exporting_for_ios.html |
| `bridge` | Godot — JavaScriptBridge | https://docs.godotengine.org/en/stable/classes/class_javascriptbridge.html |
| `http` | Godot — Making HTTP requests | https://docs.godotengine.org/en/stable/tutorials/networking/http_request_class.html |
| `layout` | Godot — Using Containers | https://docs.godotengine.org/en/stable/tutorials/ui/gui_containers.html |
| `i18n` | Godot — Internationalizing games | https://docs.godotengine.org/en/stable/tutorials/i18n/internationalizing_games.html |
| `a11y` | Godot — DisplayServer accessibility support | https://docs.godotengine.org/en/stable/classes/class_displayserver.html |
| `gh-issue` | GitHub CLI — gh issue create | https://cli.github.com/manual/gh_issue_create |
| `gh-api` | GitHub CLI — gh api | https://cli.github.com/manual/gh_api |
| `gh-label` | GitHub CLI — gh label create | https://cli.github.com/manual/gh_label_create |
| `gh-milestone` | GitHub REST — issue milestones | https://docs.github.com/en/rest/issues/milestones?apiVersion=2022-11-28 |

Godot platform constraints are used only to justify compatibility boundaries. The proposed architecture, pairing flow, UX, measurements, task sequencing and release gates are project design decisions, not claims that the documentation prescribes them.

The GitHub import procedure uses the official CLI/API interfaces for issue creation, labels, milestones and pagination.[^gh-api][^gh-issue][^gh-label][^gh-milestone] It does not use a repository connection, publish data, or register issues while this package is authored. Its local tests use a fake API only.

[^gh-issue]: GitHub CLI — gh issue create.

[^gh-api]: GitHub CLI — gh api.

[^gh-label]: GitHub CLI — gh label create.

[^gh-milestone]: GitHub REST — issue milestones.
