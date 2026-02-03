#!/bin/bash
# 添加新推文到 xiaobei-twitter
# 用法: ./add-tweet.sh "推文内容" "tag1,tag2"

CONTENT="$1"
TAGS="$2"
TWEETS_FILE="$(dirname "$0")/tweets.json"

if [ -z "$CONTENT" ]; then
    echo "用法: ./add-tweet.sh \"推文内容\" \"tag1,tag2\""
    exit 1
fi

# 生成 ID 和时间
ID=$(printf "%03d" $(($(jq length "$TWEETS_FILE") + 1)))
TIME=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

# 转换 tags 为 JSON 数组
if [ -n "$TAGS" ]; then
    TAGS_JSON=$(echo "$TAGS" | tr ',' '\n' | jq -R . | jq -s .)
else
    TAGS_JSON="[]"
fi

# 创建新推文 JSON
NEW_TWEET=$(jq -n \
    --arg id "$ID" \
    --arg time "$TIME" \
    --arg content "$CONTENT" \
    --argjson tags "$TAGS_JSON" \
    '{id: $id, time: $time, content: $content, tags: $tags}')

# 添加到文件
jq ". + [$NEW_TWEET]" "$TWEETS_FILE" > /tmp/tweets_new.json && mv /tmp/tweets_new.json "$TWEETS_FILE"

echo "✅ 推文已添加 (ID: $ID)"
echo "$NEW_TWEET" | jq .
