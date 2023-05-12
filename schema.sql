CREATE TABLESPACE vpndbspace LOCATION '/var/lib/postgresql/data/dbs';

CREATE SCHEMA vpn_schema;

CREATE TYPE currency AS ENUM (
  'ETH',
  'USDC',
  'USDT'
);
TABLESPACE vpndbspace;

CREATE TABLE vpn_schema.accounts (
  id bigserial PRIMARY KEY NOT NULL,
  login varchar UNIQUE NOT NULL,
  password varchar NOT NULL
)
TABLESPACE vpndbspace;

CREATE TABLE vpn_schema.cookies (
  account_id bigint NOT NULL,
  cookie text NOT NULL,
  PRIMARY KEY (account_id, cookie),
  CONSTRAINT fk_account_id FOREIGN KEY (account_id) REFERENCES accounts (id)
)
TABLESPACE vpndbspace;

CREATE TABLE vpn_schema.balances (
  account_id bigint NOT NULL ,
  currency currency NOT NULL,
  amount text NOT NULL,
  address text NOT NULL,
  privkey text NOT NULL,
  PRIMARY KEY (account_id, currency),
  CONSTRAINT fk_account_id FOREIGN KEY (account_id) REFERENCES accounts (id)
)
TABLESPACE vpndbspace;

CREATE TABLE vpn_schema.virtual_machines (
  id bigserial PRIMARY KEY NOT NULL,
  account_id bigint NOT NULL,
  ipv4 bigint UNIQUE DEFAULT NULL,
  "user" text NOT NULL,
  password text NOT NULL,
  expiration timestamp NOT NULL,
  city varchar NOT NULL,
  country varchar NOT NULL,
  CONSTRAINT fk_account_id FOREIGN KEY (account_id) REFERENCES accounts (id)
)
TABLESPACE vpndbspace;

CREATE INDEX virtual_machines_account_id_idx ON vpn_schema.virtual_machines (account_id) TABLESPACE vpndbspace;