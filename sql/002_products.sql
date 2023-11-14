-- +goose Up

CREATE TABLE IF NOT EXISTS products          (
    id BIGSERIAL PRIMARY KEY,
    title TEXT NOT NULL,
    image_url TEXT NOT NULL,
    amount INTEGER NOT NULL,
    price NUMERIC NOT NULL,
    created TIMESTAMP DEFAULT current_timestamp,
    updated TIMESTAMP DEFAULT current_timestamp
);

-- +goose Down

DROP TABLE products;