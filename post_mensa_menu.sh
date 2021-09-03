#!/bin/bash
set -euo pipefail

kw=$(date +%V)
dow=$(date +%u)

mensa_url='https://www.sw-ka.de/de/essen/?view=ok&STYLE=popup_plain&c=adenauerring&p=1&kw='$kw
mri_url='https://casinocatering.de/speiseplan/'

food_mensa=$(xsltproc --html --novalid mensa.xslt <(curl "${mensa_url}"))
food_mri=$(xsltproc --html --novalid --param dow $dow mri.xslt <(curl "${mri_url}"))

message='{"id":"'"${MM_POST_ID}"'", "is_pinned":true, "message":"'Mensa\\n\\n"${food_mensa}"\\n\\nMri\\n\\n"${food_mri}"'"}'
echo $message | curl -X PUT -H "Authorization: Bearer ${BOT_TOKEN}" -H 'Content-Type: application/json' -d @- ${MM_URL}/api/v4/posts/${MM_POST_ID}
