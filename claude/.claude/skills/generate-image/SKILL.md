---
name: generate-image
description: Generate brand-consistent marketing images with the OpenAI image generation API and save them to marketing/pending/ for review before publishing. Use when the user invokes /generate-image or asks to create Flagify marketing/social visuals.
---

# /generate-image — OpenAI image generator

Generate marketing images and save them to `marketing/pending/` for review before publishing.

## Setup

Requires `OPENAI_API_KEY` environment variable to be set.

## How to use

The user provides a `{prompt}` describing the image they want. You will:

1. **Study the existing brand** by reading approved images
2. **Generate the image** using the OpenAI image generation API via curl
3. **Save it** to `marketing/pending/` with a descriptive kebab-case filename
4. **Show it** to the user for review

## Execution Steps

### Step 0 — Study existing brand (CRITICAL)

Before generating anything, you MUST read existing approved images to understand the visual language.

**Read the brand reference file first:**
```
Read marketing/BRAND_VISUAL.md
```

If `BRAND_VISUAL.md` does not exist, build it by doing the following:

1. Read 4-5 images from `marketing/` (the approved, published ones — NOT from `pending/`)
2. Analyze them visually and extract:
   - **Color palette:** Exact colors used (backgrounds, accents, highlights)
   - **Mood & tone:** Dark/light, moody/clean, minimal/busy
   - **Composition patterns:** Where subjects sit, text placement zones, negative space usage
   - **Visual motifs:** Recurring elements (toggles, code snippets, dashboards, glowing effects)
   - **Photography style:** Real photos, 3D renders, flat design, mixed?
   - **Typography style:** Bold sans-serif headlines, monospace subtitles, etc.
   - **Brand elements:** Flagify logo placement, UI screenshots, toggle switches
3. Write findings to `marketing/BRAND_VISUAL.md` for future use

**This is a guide, not a cage.** The brand reference informs the generation but does not restrict creativity. New images should feel like they belong in the same family, not be copies.

### Step 1 — Determine parameters

From the `{prompt}`, decide:
- **Filename:** Convert the prompt concept to a short kebab-case name (e.g., `vibe-coding-dark-toggle.png`)
- **Size:** Default `1024x1024`. Use `1792x1024` for landscape/feed posts, `1024x1792` for portrait/stories. Ask if unclear.
- **Quality:** Default `standard`. Use `hd` only if the user asks for high detail.

### Step 2 — Enhance the prompt with brand context

Before sending to DALL-E, enhance the user's prompt using what you learned from the brand study:

1. **Inject brand colors and mood** from `BRAND_VISUAL.md` into the prompt
2. **Add composition guidance** consistent with existing assets (e.g., "leave top 20% for headline overlay")
3. **Include recurring visual motifs** where appropriate (glowing toggles, dark environments, code elements)
4. **NEVER include text/words/letters in the generated image** — text overlays are added separately later
5. **Respect the brand but explore** — if the user asks for something different, honor their creative direction while keeping it in the same visual family

Example enhancement:
- User says: "developer at desk with feature flags"
- Enhanced: "A developer working at a modern desk setup in a dark room with blue ambient lighting, multiple monitors showing code and a dashboard with a glowing blue toggle switch, moody tech aesthetic, cinematic lighting, shallow depth of field, dark background with subtle blue and orange neon accents, no text or words anywhere in the image"

### Step 3 — Generate via API

Run this curl command (substitute values):

```bash
curl -s https://api.openai.com/v1/images/generations \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $OPENAI_API_KEY" \
  -d '{
    "model": "dall-e-3",
    "prompt": "<ENHANCED_PROMPT>",
    "n": 1,
    "size": "<SIZE>",
    "quality": "<QUALITY>",
    "response_format": "url"
  }'
```

Parse the response to get the image URL from `data[0].url`.

### Step 4 — Download to pending

```bash
curl -s "<IMAGE_URL>" -o marketing/pending/<FILENAME>
```

### Step 5 — Show the image

Use the Read tool to display the image to the user:
```
Read marketing/pending/<FILENAME>
```

### Step 6 — Confirm

Tell the user:
- Image saved to `marketing/pending/<FILENAME>`
- How it relates to the existing brand (what's consistent, what's new)
- They can review it and use `/publish-image` to publish approved images to social media
- If they want variations, just ask

## Updating the Brand Reference

If the user approves an image that introduces a NEW visual element not yet in the brand guide (new color, new style, new motif), update `marketing/BRAND_VISUAL.md` to include it. The brand evolves with each approved image.

## Multiple Images

If the user asks for multiple images, generate them one at a time, showing each for review before proceeding to the next.

## Error Handling

- If `OPENAI_API_KEY` is not set, tell the user to set it: `export OPENAI_API_KEY=sk-...`
- If the API returns an error, show the error message and suggest prompt adjustments
- If the API rejects the prompt (content policy), suggest a modified version
