-- 在 Supabase SQL Editor 中运行这些命令

-- 点赞表
CREATE TABLE likes (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  tweet_id TEXT NOT NULL,
  visitor_id TEXT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 评论表
CREATE TABLE comments (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  tweet_id TEXT NOT NULL,
  author_name TEXT NOT NULL DEFAULT '游客',
  content TEXT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 创建索引
CREATE INDEX idx_likes_tweet_id ON likes(tweet_id);
CREATE INDEX idx_comments_tweet_id ON comments(tweet_id);

-- 允许匿名访问 (RLS 策略)
ALTER TABLE likes ENABLE ROW LEVEL SECURITY;
ALTER TABLE comments ENABLE ROW LEVEL SECURITY;

-- 允许所有人读取
CREATE POLICY "Allow public read likes" ON likes FOR SELECT USING (true);
CREATE POLICY "Allow public read comments" ON comments FOR SELECT USING (true);

-- 允许所有人插入
CREATE POLICY "Allow public insert likes" ON likes FOR INSERT WITH CHECK (true);
CREATE POLICY "Allow public insert comments" ON comments FOR INSERT WITH CHECK (true);

-- 允许删除自己的点赞
CREATE POLICY "Allow delete own likes" ON likes FOR DELETE USING (true);
