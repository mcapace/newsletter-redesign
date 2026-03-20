#!/bin/bash
# =============================================================
# Deutsch Spirits — Upload Assets to Braze Media Library
# Then update HTML email blasts with returned CDN URLs
# =============================================================

BRAZE_API_KEY="cb7f2d57-ff8b-4f9d-8adc-a5a60801877c"
BRAZE_ENDPOINT="https://rest.iad-07.braze.com"

# Google Drive direct download URL pattern
# https://drive.google.com/uc?export=download&id=FILE_ID
gdrive_url() {
  echo "https://drive.google.com/uc?export=download&id=$1"
}

# Upload a single asset to Braze and return the CDN URL
# Usage: upload_to_braze "DISPLAY_NAME" "GOOGLE_DRIVE_FILE_ID"
upload_to_braze() {
  local name="$1"
  local file_id="$2"
  local source_url
  source_url=$(gdrive_url "$file_id")

  echo "  Uploading: $name"

  local response
  response=$(curl -s -X POST "${BRAZE_ENDPOINT}/media_library/create" \
    --header "Authorization: Bearer ${BRAZE_API_KEY}" \
    --header "Content-Type: application/json" \
    --data "{\"asset_url\": \"${source_url}\", \"name\": \"${name}\"}")

  # Extract the CDN URL from the response
  local cdn_url
  cdn_url=$(echo "$response" | python3 -c "
import sys, json
try:
    data = json.load(sys.stdin)
    if 'new_assets' in data and len(data['new_assets']) > 0:
        print(data['new_assets'][0]['url'])
    else:
        print('ERROR: ' + json.dumps(data))
except Exception as e:
    print('ERROR: ' + str(e))
" 2>/dev/null)

  echo "    → $cdn_url"
  echo "$cdn_url"
}

# Track URLs in an associative array
declare -A URLS

echo "============================================="
echo "  Uploading Bib & Tucker Assets"
echo "============================================="

# --- BIB & TUCKER ---
URLS[bt_hero]=$(upload_to_braze "BT — Hero Banner" "1y0zZCdcr7Gc8_bE36tUjQY7LZS5J_CAN")
URLS[bt_bottle]=$(upload_to_braze "BT — 6-Year Bottle" "12yLL6deYCbZtY6yI3Y26CJX92UP_aYQy")
URLS[bt_double_char]=$(upload_to_braze "BT — Double Char Bourbon" "1kda88Si9oklNV7IPTc7ZsTX7ay2GwPwx")
URLS[bt_gold_roast]=$(upload_to_braze "BT — Gold Roast" "1e_rsOBqvzzM61tYzMoJz90_IFvK5iQWr")
URLS[bt_gold_roast_pour]=$(upload_to_braze "BT — Gold Roast Pouring" "1DOhlQSwdtulWqSt9FoVC8v3-g0gQ8KmZ")
URLS[bt_newsletter_hero]=$(upload_to_braze "BT — Newsletter Hero" "1wR_doc6faDf5lwey1vwVGYo7_WylN77-")
URLS[bt_article]=$(upload_to_braze "BT — Article Image" "1qx4n6mGJBjHM7auv7Vm6ZCtoRJf7eh1a")
URLS[bt_poster]=$(upload_to_braze "BT — Poster / Lifestyle" "10CCsADEUMCjC2aYD5x9x_w1PxrHcjZV8")
URLS[bt_apprentice]=$(upload_to_braze "BT — Apprentice Blender" "1jHUdupdkPMqjsMieKo8r_r6tGJ_AauOP")
URLS[bt_steak]=$(upload_to_braze "BT — Double Char & Steak" "15LBCca2P6x1SKtsI4bUO7Uz_x75shwQw")
URLS[bt_bibhero]=$(upload_to_braze "BT — Bib Hero" "1bXNl2-T0AvDwqTbEU2ioNvFckk_5hk3U")
URLS[bt_espresso]=$(upload_to_braze "BT — Gold Roast Espresso Martini" "1JPimLBCCbvqmnevsbmHNKI5VrMlAVErt")
URLS[bt_cortado_drink]=$(upload_to_braze "BT — Cortado Drink" "1lE-cVXAX7YK1789LG2PXnmIf3WTxV358")
URLS[bt_whisky_weekend]=$(upload_to_braze "BT — Whisky Weekend" "1zviO4oVCLoYDwObBmTpZc_QyuIInqsXk")
URLS[bt_tennessee_ten]=$(upload_to_braze "BT — Tennessee Ten" "1P45kuCzdJdU0et9NCiJIvZ5JiUBPgUCY")
URLS[bt_gold_martini]=$(upload_to_braze "BT — Gold Roast Martini" "1rxFmY51E0g9TIC2VoJ9ROXS8FiLcjwI5")
URLS[bt_steam_engine]=$(upload_to_braze "BT — Steam Engine Recipe" "1kY8R45VIP1a-IGuMdiwxXM-501smMlXq")
URLS[bt_old_fashioned_drink]=$(upload_to_braze "BT — Steam Engine Old Fashioned" "1EqXoAuZAoZDyufm_cQKnJ8scjvV2tYAl")
URLS[bt_gold_highball]=$(upload_to_braze "BT — Gold Roast Highball" "1C40JOtZ0GAo1fs8iS0uR-cDdd5Tbq8Kj")
URLS[bt_pecan_old_fashioned]=$(upload_to_braze "BT — Tennessee Pecan Old Fashioned" "1BU_-zO_7qGj73y4at5eHUwbNISF-q0cu")

echo ""
echo "============================================="
echo "  Uploading Redemption Assets"
echo "============================================="

# --- REDEMPTION ---
URLS[rd_3bottles]=$(upload_to_braze "RD — 3 Bottles Lineup" "1_xOdZ3r57PRcq-7yYWmzLQI1leHDicgi")
URLS[rd_logo]=$(upload_to_braze "RD — Logo" "1rU_dCn9FCvVuRLb5sC1U839fn6mMbN9M")
URLS[rd_bonded_bourbon]=$(upload_to_braze "RD — Bonded Bourbon" "1V4bhl1v0ng1TgOu6GSB4r2WaRUq5Aak-")
URLS[rd_bottle_drink_logo]=$(upload_to_braze "RD — Bottle Drink Logo" "1D07nMoqmdMnXxfee3R8ARuE1lYMnK6dF")
URLS[rd_bottle_and_drink]=$(upload_to_braze "RD — Bottle and Drink" "10QG_y5Px7mIURi86mVa9UUUSoNwdgBJ5")
URLS[rd_bottled_in_bond]=$(upload_to_braze "RD — Bottled in Bond" "1EGlFyOZJ_Q-nfq_05nt958vkIBac4liD")
URLS[rd_cocktails]=$(upload_to_braze "RD — Cocktails" "13sX3wfuSiQPPLKtVKMJ3JS8YYyPCg_DQ")
URLS[rd_content1]=$(upload_to_braze "RD — Content 1" "1c_7CGizAo-ZpURd5Bwm_dS5Uh2FyV7K1")
URLS[rd_hero]=$(upload_to_braze "RD — Hero" "12Ap5y9OmjmgYpBW19dl9iBTWp9PKsDWA")
URLS[rd_mixology]=$(upload_to_braze "RD — Mixology" "1VBeSTasjyViH9NhHooEQ9IKC-2a1uLjM")
URLS[rd_red_label]=$(upload_to_braze "RD — Red Label" "1cMmC0uo5ohPaOjUsTM-1XDvWFkNoPBc_")

echo ""
echo "============================================="
echo "  All uploads complete!"
echo "============================================="
echo ""

# =============================================
# MAP URLS INTO EMAIL HTML FILES
# =============================================
echo "Mapping CDN URLs into email templates..."

# --- BLAST 01: BT Ecomm Collection (3-SKU grid) ---
if [[ "${URLS[bt_bottle]}" != ERROR* ]]; then
  sed -i.bak "s|https://placehold.co/220x65/1a120b/d4a853?text=BIB+%26+TUCKER|${URLS[bt_hero]}|g" blast-01-bt-ecomm-collection.html
  sed -i.bak "s|https://placehold.co/140x360/fffdf8/2e2318?text=6-Year|${URLS[bt_bottle]}|g" blast-01-bt-ecomm-collection.html
  sed -i.bak "s|https://placehold.co/140x360/fffdf8/2e2318?text=Double+Char|${URLS[bt_double_char]}|g" blast-01-bt-ecomm-collection.html
  sed -i.bak "s|https://placehold.co/140x360/fffdf8/2e2318?text=Gold+Roast|${URLS[bt_gold_roast]}|g" blast-01-bt-ecomm-collection.html
  echo "  ✓ blast-01 updated"
fi

# --- BLAST 02: BT Ecomm Hero ---
if [[ "${URLS[bt_bibhero]}" != ERROR* ]]; then
  sed -i.bak "s|https://placehold.co/180x50/1a120b/d4a853?text=BIB+%26+TUCKER|${URLS[bt_hero]}|g" blast-02-bt-ecomm-hero.html
  sed -i.bak "s|https://placehold.co/200x500/3a2d20/d4a853?text=6-Year+Bottle|${URLS[bt_bibhero]}|g" blast-02-bt-ecomm-hero.html
  sed -i.bak "s|https://placehold.co/90x225/fffdf8/2e2318?text=Double+Char|${URLS[bt_double_char]}|g" blast-02-bt-ecomm-hero.html
  sed -i.bak "s|https://placehold.co/90x225/fffdf8/2e2318?text=Gold+Roast|${URLS[bt_gold_roast]}|g" blast-02-bt-ecomm-hero.html
  echo "  ✓ blast-02 updated"
fi

# --- BLAST 03: BT Brand Craft ---
if [[ "${URLS[bt_apprentice]}" != ERROR* ]]; then
  sed -i.bak "s|https://placehold.co/160x45/1a120b/d4a853?text=BIB+%26+TUCKER|${URLS[bt_hero]}|g" blast-03-bt-brand-craft.html
  sed -i.bak "s|https://placehold.co/640x340/3d2e1e/d4a853?text=Oak+Grain+%7C+Barrel+Texture|${URLS[bt_apprentice]}|g" blast-03-bt-brand-craft.html
  echo "  ✓ blast-03 updated"
fi

# --- BLAST 04: BT Brand Design ---
if [[ "${URLS[bt_poster]}" != ERROR* ]]; then
  sed -i.bak "s|https://placehold.co/130x38/0f0c08/d4a853?text=BIB+%26+TUCKER|${URLS[bt_hero]}|g" blast-04-bt-brand-design.html
  sed -i.bak "s|https://placehold.co/260x580/0f0c08/d4a853?text=Hero+Bottle+%E2%80%94+Dark|${URLS[bt_poster]}|g" blast-04-bt-brand-design.html
  sed -i.bak "s|https://placehold.co/300x190/1a120b/d4a853?text=%26+Label+Detail|${URLS[bt_newsletter_hero]}|g" blast-04-bt-brand-design.html
  echo "  ✓ blast-04 updated"
fi

# --- BLAST 05: BT Brand Ritual ---
if [[ "${URLS[bt_steak]}" != ERROR* ]]; then
  sed -i.bak "s|https://placehold.co/150x42/1a120b/d4a853?text=BIB+%26+TUCKER|${URLS[bt_hero]}|g" blast-05-bt-brand-ritual.html
  sed -i.bak "s|https://placehold.co/640x420/3d2e1e/d4a853?text=Fireside+%E2%80%94+Lifestyle|${URLS[bt_steak]}|g" blast-05-bt-brand-ritual.html
  echo "  ✓ blast-05 updated"
fi

# --- BLAST 06: Redemption Ecomm ---
if [[ "${URLS[rd_3bottles]}" != ERROR* ]]; then
  sed -i.bak "s|https://placehold.co/220x55/0d0d0d/c49b44?text=REDEMPTION|${URLS[rd_logo]}|g" blast-06-redemption-ecomm.html
  sed -i.bak "s|https://placehold.co/110x275/ffffff/0d0d0d?text=Rye|${URLS[rd_red_label]}|g" blast-06-redemption-ecomm.html
  sed -i.bak "s|https://placehold.co/110x275/ffffff/0d0d0d?text=Bourbon|${URLS[rd_bonded_bourbon]}|g" blast-06-redemption-ecomm.html
  sed -i.bak "s|https://placehold.co/110x275/ffffff/0d0d0d?text=High+Rye|${URLS[rd_bottled_in_bond]}|g" blast-06-redemption-ecomm.html
  sed -i.bak "s|https://placehold.co/110x275/ffffff/0d0d0d?text=Wheated|${URLS[rd_bottle_and_drink]}|g" blast-06-redemption-ecomm.html
  echo "  ✓ blast-06 updated"
fi

# --- BLAST 07: Redemption Brand ---
if [[ "${URLS[rd_hero]}" != ERROR* ]]; then
  sed -i.bak "s|https://placehold.co/170x42/0d0d0d/c49b44?text=REDEMPTION|${URLS[rd_logo]}|g" blast-07-redemption-brand.html
  sed -i.bak "s|https://placehold.co/480x580/1a1a1a/c49b44?text=Dramatic+Bottle+%E2%80%94+Dark|${URLS[rd_hero]}|g" blast-07-redemption-brand.html
  sed -i.bak "s|https://placehold.co/480x320/1a1a1a/c49b44?text=Manhattan+%E2%80%94+Dark+Mood|${URLS[rd_cocktails]}|g" blast-07-redemption-brand.html
  echo "  ✓ blast-07 updated"
fi

# Clean up backup files
rm -f *.bak

echo ""
echo "============================================="
echo "  Done! All templates updated with Braze CDN URLs."
echo "============================================="
echo ""
echo "Uploaded assets summary:"
for key in "${!URLS[@]}"; do
  echo "  $key → ${URLS[$key]}"
done
