-- ============================================================================
-- V1.0.0 - Create document_ms schema
-- ============================================================================
-- Based on: DocumentEntity, DocumentAccessTokenEntity
-- ============================================================================

CREATE SCHEMA IF NOT EXISTS document_ms;

COMMENT ON SCHEMA document_ms IS 'Document management service';

SET search_path TO document_ms;

-- ----------------------------------------------------------------------------
-- document table
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS document (
    id                  BIGSERIAL PRIMARY KEY,
    uuid                UUID NOT NULL UNIQUE,
    user_id             UUID NOT NULL,
    name                VARCHAR(255) NOT NULL,
    original_filename   VARCHAR(255),
    size                BIGINT,
    extension           VARCHAR(50),
    content_type        VARCHAR(255),
    bucket              VARCHAR(255),
    object_key          VARCHAR(255),
    visibility          VARCHAR(20),
    uploaded_by_id      UUID,
    uploaded_by_type    VARCHAR(20),
    created_at          TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at          TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    checksum            VARCHAR(255),
    description         TEXT,
    deleted             BOOLEAN DEFAULT FALSE,
    deleted_by          UUID,
    deleted_at          TIMESTAMP WITH TIME ZONE,
    version             BIGINT DEFAULT 0
);

CREATE INDEX IF NOT EXISTS idx_document_uuid ON document(uuid);
CREATE INDEX IF NOT EXISTS idx_document_user ON document(user_id);
CREATE INDEX IF NOT EXISTS idx_document_deleted ON document(deleted);
CREATE INDEX IF NOT EXISTS idx_document_created_at ON document(created_at);

-- ----------------------------------------------------------------------------
-- document_tags table (ElementCollection)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS document_tags (
    document_id     BIGINT NOT NULL,
    tag             VARCHAR(255) NOT NULL,
    
    PRIMARY KEY (document_id, tag),
    CONSTRAINT fk_document_tags_document FOREIGN KEY (document_id) REFERENCES document(id) ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS idx_document_tags_doc ON document_tags(document_id);

-- ----------------------------------------------------------------------------
-- document_access_token table
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS document_access_token (
    id                  BIGSERIAL PRIMARY KEY,
    document_uuid       UUID NOT NULL,
    token_hash          VARCHAR(255) NOT NULL UNIQUE,
    created_by          UUID,
    created_at          TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    expires_at          TIMESTAMP WITH TIME ZONE NOT NULL,
    revoked             BOOLEAN DEFAULT FALSE,
    revoked_by          UUID,
    revoked_at          TIMESTAMP WITH TIME ZONE,
    access_count        INTEGER DEFAULT 0,
    last_accessed_at    TIMESTAMP WITH TIME ZONE
);

CREATE INDEX IF NOT EXISTS idx_doc_access_token_doc ON document_access_token(document_uuid);
CREATE INDEX IF NOT EXISTS idx_doc_access_token_hash ON document_access_token(token_hash);
CREATE INDEX IF NOT EXISTS idx_doc_access_token_created_at ON document_access_token(created_at);

RESET search_path;
