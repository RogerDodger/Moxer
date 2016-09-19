CREATE TABLE _db_version (
   "version" text
);

CREATE TABLE users (
   "name" text,
   "password" text
);

CREATE TABLE sets (
   "id" serial primary key,
   "name" text unique,
   "code" text,
   "code_gatherer" text,
   "code_old"  text,
   "code_mci" text,
   "released" date,
   "border" text,
   "type" text,
   "block" text,
   "booster" jsonb
);

CREATE INDEX ON sets (id);
CREATE INDEX ON sets (name);

CREATE TABLE cards (
   "id" serial primary key,
   "layout" text,
   "name" text unique,
   "names" text[],
   "mana_cost" text,
   "cmc" real,
   "colors" text[],
   "color_identity" text[],
   "type" text,
   "supertypes" text[],
   "types" text[],
   "subtypes" text[],
   "body" text,
   "power" text,
   "toughness" text,
   "loyalty" integer
);

CREATE INDEX ON cards (id);
CREATE INDEX ON cards (name);

CREATE TABLE rulings (
   "id" serial primary key,
   "card_id" integer references cards(id),
   "body" text not null,
   "created" date,
   unique("card_id", "body")
);

CREATE INDEX ON rulings (id);
CREATE INDEX ON rulings (card_id);

CREATE TABLE prints (
   "id" serial primary key,
   "card_id" integer references cards(id),
   "set_id" integer references sets(id),
   "multiverseid" integer,
   "variations" integer[],
   "uid" text unique,
   "rarity" text,
   "type" text,
   "body" text,
   "flavor" text,
   "artist" text,
   "number" text,
   "watermark" text,
   "border" text,
   "timeshifted" boolean not null default false,
   "reserved" boolean not null default false,
   "released" text,
   "starter" boolean not null default false,
   "mci_number" text,
   "source" text
);

CREATE INDEX ON prints (id);
CREATE INDEX ON prints (card_id);
CREATE INDEX ON prints (set_id);
CREATE INDEX ON prints (card_id, set_id);
