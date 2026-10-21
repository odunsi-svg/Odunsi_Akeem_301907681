
BEGIN;

CREATE TABLE telephone_numbers (
    phone_number VARCHAR(20) PRIMARY KEY,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT phone_number_format
        CHECK (phone_number ~ '^[0-9]{10,15}$')
);

CREATE TABLE import_batches (
    batch_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    filename VARCHAR(255) NOT NULL,
    imported_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    total_rows INTEGER NOT NULL DEFAULT 0 CHECK (total_rows >= 0),
    accepted_rows INTEGER NOT NULL DEFAULT 0 CHECK (accepted_rows >= 0),
    rejected_rows INTEGER NOT NULL DEFAULT 0 CHECK (rejected_rows >= 0),
    status VARCHAR(20) NOT NULL DEFAULT 'PENDING',
    CONSTRAINT valid_batch_status
        CHECK (status IN ('PENDING', 'COMPLETED', 'FAILED')),
    CONSTRAINT valid_batch_counts
        CHECK (accepted_rows + rejected_rows <= total_rows)
);

CREATE TABLE cell_sites (
    cell_site_id VARCHAR(30) PRIMARY KEY,
    site_label VARCHAR(100),
    latitude NUMERIC(9,6) CHECK (latitude BETWEEN -90 AND 90),
    longitude NUMERIC(9,6) CHECK (longitude BETWEEN -180 AND 180)
);

CREATE TABLE call_events (
    event_id VARCHAR(40) PRIMARY KEY,
    batch_id BIGINT NOT NULL REFERENCES import_batches(batch_id),
    originating_number VARCHAR(20) NOT NULL
        REFERENCES telephone_numbers(phone_number),
    receiving_number VARCHAR(20) NOT NULL
        REFERENCES telephone_numbers(phone_number),
    call_started_at TIMESTAMPTZ NOT NULL,
    duration_seconds INTEGER NOT NULL CHECK (duration_seconds >= 0),
    originating_cell_site_id VARCHAR(30)
        REFERENCES cell_sites(cell_site_id),
    receiving_cell_site_id VARCHAR(30)
        REFERENCES cell_sites(cell_site_id)
);

CREATE TABLE import_rejections (
    rejection_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    batch_id BIGINT NOT NULL REFERENCES import_batches(batch_id),
    source_row_number INTEGER NOT NULL CHECK (source_row_number > 0),
    raw_record JSONB,
    rejection_reason TEXT NOT NULL,
    rejected_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (batch_id, source_row_number)
);

COMMIT;
  