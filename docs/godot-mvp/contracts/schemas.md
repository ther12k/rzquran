---
type: Schema
title: Embedded contract schema and validation cases
description: Nine narrow JSON Schema definitions and eight expected valid/invalid examples.
tags:
- rz-quran-kids
- godot-mvp
status: draft
generated:
  by: chatgpt/rzq-godot-mvp-1.0
  at: '2026-09-07T07:53:44Z'
sources:
- resource: /references/project-context.md
  title: User requirements and reported project baseline
x_rzq:
  bundle_version: '1.0'
  review_state: unreviewed
  language: en
  ui_language: id
---

# Schema

This fenced JSON is a starting contract artifact for GDM-003, not an executed API. The schema is deliberately limited to nine critical DTOs; [API](api.md) defines the remaining operation semantics. The implementation must complete executable schemas for all mapped operations. Validate the named `$defs` with JSON Schema 2020-12 and format checking enabled. Cross-field uniqueness, ownership, release validity, state transitions and cryptographic proof remain server checks, not schema guarantees.

```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "$id": "urn:rzq:godot:mvp:v1",
  "$defs": {
    "StartRequest": {
      "type": "object",
      "additionalProperties": false,
      "properties": {
        "lesson_id": {
          "type": "string",
          "pattern": "^[A-Za-z0-9_-]{1,80}$"
        },
        "client_request_id": {
          "type": "string",
          "format": "uuid"
        },
        "contract_version": {
          "const": "1"
        }
      },
      "required": [
        "lesson_id",
        "client_request_id",
        "contract_version"
      ]
    },
    "AttemptRequest": {
      "type": "object",
      "additionalProperties": false,
      "properties": {
        "question_id": {
          "type": "string",
          "pattern": "^[A-Za-z0-9_-]{1,80}$"
        },
        "option_id": {
          "type": "string",
          "pattern": "^[A-Za-z0-9_-]{1,80}$"
        },
        "client_request_id": {
          "type": "string",
          "format": "uuid"
        }
      },
      "required": [
        "question_id",
        "option_id",
        "client_request_id"
      ]
    },
    "FinishRequest": {
      "type": "object",
      "additionalProperties": false,
      "properties": {
        "client_request_id": {
          "type": "string",
          "format": "uuid"
        }
      },
      "required": [
        "client_request_id"
      ]
    },
    "PublicOption": {
      "type": "object",
      "additionalProperties": false,
      "properties": {
        "id": {
          "type": "string",
          "pattern": "^[A-Za-z0-9_-]{1,80}$"
        },
        "display_text": {
          "type": "string",
          "minLength": 1,
          "maxLength": 80
        }
      },
      "required": [
        "id",
        "display_text"
      ]
    },
    "PublicQuestion": {
      "type": "object",
      "additionalProperties": false,
      "properties": {
        "id": {
          "type": "string",
          "pattern": "^[A-Za-z0-9_-]{1,80}$"
        },
        "position": {
          "type": "integer",
          "minimum": 1,
          "maximum": 3
        },
        "prompt_audio_asset_id": {
          "type": "string",
          "pattern": "^[A-Za-z0-9_-]{1,80}$"
        },
        "options": {
          "type": "array",
          "minItems": 3,
          "maxItems": 3,
          "items": {
            "$ref": "#/$defs/PublicOption"
          }
        }
      },
      "required": [
        "id",
        "position",
        "prompt_audio_asset_id",
        "options"
      ]
    },
    "PairingCreate": {
      "type": "object",
      "additionalProperties": false,
      "properties": {
        "code_challenge": {
          "type": "string",
          "pattern": "^[A-Za-z0-9_-]{43}$"
        },
        "challenge_method": {
          "const": "S256"
        },
        "client_build": {
          "type": "string",
          "minLength": 1,
          "maxLength": 80
        }
      },
      "required": [
        "code_challenge",
        "challenge_method",
        "client_build"
      ]
    },
    "PairingApprove": {
      "type": "object",
      "additionalProperties": false,
      "properties": {
        "user_code": {
          "type": "string",
          "pattern": "^[A-HJ-NP-Z2-9]{8}$"
        },
        "profile_id": {
          "type": "string",
          "pattern": "^[A-Za-z0-9_-]{1,80}$"
        }
      },
      "required": [
        "user_code",
        "profile_id"
      ]
    },
    "PairingRedeem": {
      "type": "object",
      "additionalProperties": false,
      "properties": {
        "pairing_id": {
          "type": "string",
          "pattern": "^[A-Za-z0-9_-]{1,80}$"
        },
        "code_verifier": {
          "type": "string",
          "pattern": "^[A-Za-z0-9_-]{43}$"
        }
      },
      "required": [
        "pairing_id",
        "code_verifier"
      ]
    },
    "FinishResponse": {
      "type": "object",
      "additionalProperties": false,
      "properties": {
        "session_id": {
          "type": "string",
          "pattern": "^[A-Za-z0-9_-]{1,80}$"
        },
        "status": {
          "const": "completed"
        },
        "answered_count": {
          "const": 3
        },
        "first_answer_correct_count": {
          "type": "integer",
          "minimum": 0,
          "maximum": 3
        },
        "first_answer_total": {
          "const": 3
        },
        "completed_at": {
          "type": "string",
          "format": "date-time"
        },
        "content_mode": {
          "enum": [
            "fixture",
            "reviewed_learning"
          ]
        }
      },
      "required": [
        "session_id",
        "status",
        "answered_count",
        "first_answer_correct_count",
        "first_answer_total",
        "completed_at",
        "content_mode"
      ]
    }
  }
}
```

# Examples

All IDs and timestamps below are illustrative and contain no real token. Expected-invalid examples are intentional negative cases, not usable lesson content.

```json
{
  "cases": [
    {
      "name": "valid-start",
      "definition": "StartRequest",
      "valid": true,
      "value": {
        "lesson_id": "fixture-shapes-01",
        "client_request_id": "25ea7c56-5ec4-4e99-b5cf-3cc78cd46a71",
        "contract_version": "1"
      }
    },
    {
      "name": "invalid-client-score",
      "definition": "AttemptRequest",
      "valid": false,
      "value": {
        "question_id": "q_01",
        "option_id": "o_01",
        "client_request_id": "25ea7c56-5ec4-4e99-b5cf-3cc78cd46a71",
        "score": 100
      }
    },
    {
      "name": "invalid-start-version",
      "definition": "StartRequest",
      "valid": false,
      "value": {
        "lesson_id": "fixture-shapes-01",
        "client_request_id": "25ea7c56-5ec4-4e99-b5cf-3cc78cd46a71",
        "contract_version": "99"
      }
    },
    {
      "name": "invalid-id",
      "definition": "AttemptRequest",
      "valid": false,
      "value": {
        "question_id": "../parent",
        "option_id": "o_01",
        "client_request_id": "not-a-uuid"
      }
    },
    {
      "name": "valid-question",
      "definition": "PublicQuestion",
      "valid": true,
      "value": {
        "id": "q_01",
        "position": 1,
        "prompt_audio_asset_id": "asset_01",
        "options": [
          {
            "id": "o_a",
            "display_text": "○"
          },
          {
            "id": "o_b",
            "display_text": "□"
          },
          {
            "id": "o_c",
            "display_text": "△"
          }
        ]
      }
    },
    {
      "name": "invalid-answer-key",
      "definition": "PublicQuestion",
      "valid": false,
      "value": {
        "id": "q_01",
        "position": 1,
        "prompt_audio_asset_id": "asset_01",
        "options": [
          {
            "id": "o_a",
            "display_text": "○"
          },
          {
            "id": "o_b",
            "display_text": "□"
          },
          {
            "id": "o_c",
            "display_text": "△"
          }
        ],
        "correct_option_id": "o_a"
      }
    },
    {
      "name": "valid-finish",
      "definition": "FinishResponse",
      "valid": true,
      "value": {
        "session_id": "s_01",
        "status": "completed",
        "answered_count": 3,
        "first_answer_correct_count": 2,
        "first_answer_total": 3,
        "completed_at": "2026-09-07T09:03:20Z",
        "content_mode": "fixture"
      }
    },
    {
      "name": "invalid-incomplete-finish",
      "definition": "FinishResponse",
      "valid": false,
      "value": {
        "session_id": "s_01",
        "status": "completed",
        "answered_count": 2,
        "first_answer_correct_count": 2,
        "first_answer_total": 3,
        "completed_at": "2026-09-07T09:03:20Z",
        "content_mode": "fixture"
      }
    }
  ]
}
```

Do not publish `code_challenge`/`code_verifier` fixtures with real secrets. The schema's code alphabet matches the proposed unambiguous human code, and the cryptographic verifier length represents 32 random bytes encoded base64url. GDM-009 must test actual generation, hashing, expiry and redemption; passing a string pattern is not proof of authentication.
