-- migrate:up

CREATE TABLE users (
  id         BIGINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'ユーザーID',
  name       VARCHAR(100)    NOT NULL                COMMENT 'ユーザー名',
  email      VARCHAR(255)    NOT NULL                COMMENT 'メールアドレス',
  created_at DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '作成日時',
  updated_at DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新日時',
  PRIMARY KEY (id),
  UNIQUE KEY uk_users_email (email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='ユーザー';

CREATE TABLE posts (
  id         BIGINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '投稿ID',
  user_id    BIGINT UNSIGNED NOT NULL                COMMENT '投稿者のユーザーID',
  title      VARCHAR(255)    NOT NULL                COMMENT 'タイトル',
  body       TEXT            NOT NULL                COMMENT '本文',
  created_at DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '作成日時',
  updated_at DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新日時',
  PRIMARY KEY (id),
  INDEX idx_posts_user_id (user_id),
  CONSTRAINT fk_posts_user_id FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='投稿';

CREATE TABLE comments (
  id         BIGINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'コメントID',
  post_id    BIGINT UNSIGNED NOT NULL                COMMENT '対象の投稿ID',
  user_id    BIGINT UNSIGNED NOT NULL                COMMENT 'コメント投稿者のユーザーID',
  body       TEXT            NOT NULL                COMMENT 'コメント本文',
  created_at DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '作成日時',
  PRIMARY KEY (id),
  INDEX idx_comments_post_id (post_id),
  INDEX idx_comments_user_id (user_id),
  CONSTRAINT fk_comments_post_id FOREIGN KEY (post_id) REFERENCES posts (id) ON DELETE CASCADE,
  CONSTRAINT fk_comments_user_id FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='コメント';

-- migrate:down

DROP TABLE IF EXISTS comments;
DROP TABLE IF EXISTS posts;
DROP TABLE IF EXISTS users;
