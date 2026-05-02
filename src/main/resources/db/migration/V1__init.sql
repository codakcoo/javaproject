-- 기존에 테이블이 없을 때만 생성합니다 (IF NOT EXISTS 필수)
CREATE TABLE IF NOT EXISTS member (
    member_id   VARCHAR(20)  NOT NULL PRIMARY KEY,
    password    VARCHAR(100) NOT NULL,
    name        VARCHAR(50)  NOT NULL,
    email       VARCHAR(100),
    role        VARCHAR(10)  DEFAULT 'USER',
    created_at  DATETIME     DEFAULT NOW()
);
