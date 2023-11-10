-- +goose Up

CREATE TABLE IF NOT EXISTS products          (
    id BIGSERIAL PRIMARY KEY,
    title TEXT NOT NULL,
    image_url TEXT NOT NULL,
    price BIGINT NOT NULL,
    created TIMESTAMP DEFAULT current_timestamp,
    updated TIMESTAMP DEFAULT current_timestamp
);

-- +goose Down

DROP TABLE products;