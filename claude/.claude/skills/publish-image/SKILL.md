---
name: publish-image
description: Publish approved marketing images from marketing/pending/ to LinkedIn and Instagram via Buffer, using Imgur for public image hosting. Use when the user invokes /publish-image or asks to queue approved Flagify social posts.
---

# /publish-image — Publish Pending Images to Social Media

Publish approved images from `marketing/pending/` to LinkedIn and Instagram via Buffer.

## How to use

The user invokes `/publish-image` with optional `{options}`:
- `/publish-image` — List all pending images for review
- `/publish-image all` — Publish all pending images
- `/publish-image filename.png` — Publish a specific image
- `/publish-image filename.png "Custom caption here"` — Publish with custom text

## Execution Steps

### Step 1 — List pending images

Glob `marketing/pending/*.{png,jpg,jpeg,webp}` and show the user what's available.

If no argument is provided, use the Read tool to display each image and ask which ones to publish.

### Step 2 — For each image to publish

#### 2a. Upload to Imgur

```bash
curl -s -X POST https://api.imgur.com/3/image \
  -H "Authorization: Client-ID 546c25a59c58ad7" \
  -F "image=@marketing/pending/<FILENAME>"
```

Parse `data.link` from the response to get the public URL.

#### 2b. Generate captions (if not provided)

Use the /biz skill principles to create:
- **LinkedIn caption:** Professional, pain-led hook, CTA to flagify.dev, 3-5 hashtags at end
- **Instagram caption:** Shorter, punchier, dev culture tone, CTA to "link in bio", 3-5 hashtags

Show the captions to the user for approval before posting.

#### 2c. Check Buffer limit

Before creating posts, call `mcp__buffer__list_posts` with status `scheduled` to check current count.
- Plan limit is 10 scheduled posts per channel
- If at limit, STOP and tell the user. Do NOT attempt to create the post.

#### 2d. Post to Buffer

Create posts on both channels using `mcp__buffer__create_post`:

**LinkedIn** (channel `69d4917f031bfa423cd908a9`):
- `schedulingType`: "automatic"
- `mode`: "addToQueue"
- Attach image via `assets.images` with the Imgur URL
- Include alt text in `metadata.altText`

**Instagram** (channel `69d4915c031bfa423cd90815`):
- `schedulingType`: "automatic"
- `mode`: "addToQueue"
- Attach image via `assets.images` with the Imgur URL (REQUIRED for Instagram)
- Set `metadata.instagram.type`: "post" and `shouldShareToFeed`: true
- For portrait/story images, use `metadata.instagram.type`: "story"

#### 2e. Move to published

After successful posting, move the image out of pending:

```bash
mv marketing/pending/<FILENAME> marketing/published/<FILENAME>
```

Create `marketing/published/` if it doesn't exist.

### Step 3 — Update marketing.md

Append the new post details to `marketing/marketing.md` including:
- Image filename and Imgur URL
- LinkedIn and Instagram captions
- Scheduled dates from Buffer response
- Status

### Step 4 — Summary

Show the user a table of what was published, to which channels, and scheduled dates.

## Important Rules

- **NEVER publish without showing the image and caption to the user first** (unless they said "all")
- **STOP immediately if Buffer limit is reached** — do not retry or force
- **All captions in English** — the audience is global developers
- **CTA links:** LinkedIn uses `flagify.dev`, Instagram uses "link in bio"
- **Brand voice:** Bold, direct, pain-first, developer-focused
