---
type: Asset Specification
title: Interface cue recipe
description: Interface cue recipe.
tags:
- rz-quran-kids
- godot-mvp
- assets
status: draft
generated:
  by: chatgpt/rzq-asset-starter-1.1
  at: '2026-09-07'
sources:
- resource: ../../mvp-docs/contracts/content.md
  title: Original MVP content contract; unchanged companion bundle
x_rzq:
  bundle_version: '1.1'
  review_state: unreviewed
  language: en
  ui_language: id
---

# Interface cue recipe

These are reproducible non-speech test/UI cues created for this handoff, not Kenney samples and not learning audio. Audition and approve use before enabling them in a child-facing build. The output format is uncompressed PCM WAV; no font, voice model, music recording or external sample is involved.

```python
from pathlib import Path
import array, math, sys, wave

out = Path("generated-ui-cues")
out.mkdir(exist_ok=True)
for name, frequency, duration in [
    ("ui_tap", 600, 0.08),
    ("ui_confirm", 800, 0.18),
    ("ui_complete", 1000, 0.28),
]:
    sample_rate = 48000
    count = round(sample_rate * duration)
    samples = array.array("h")
    for i in range(count):
        t = i / sample_rate
        fade_in = min(1.0, i / max(1, round(sample_rate * 0.004)))
        fade_out = min(1.0, (count - 1 - i) / max(1, round(sample_rate * 0.02)))
        envelope = fade_in * fade_out * math.exp(-3.0 * t / duration)
        sample = 0.08 * envelope * math.sin(2 * math.pi * frequency * t)
        samples.append(round(sample * 32767))
    if sys.byteorder != "little":
        samples.byteswap()
    with wave.open(str(out / (name + ".wav")), "wb") as wav:
        wav.setnchannels(1)
        wav.setsampwidth(2)
        wav.setframerate(sample_rate)
        wav.writeframes(samples.tobytes())
```

This generation recipe and the preview are original handoff material with generated provenance. Do not falsely attach a third-party CC0 license or performer attribution to them. A final release still follows the project’s review decisions.
