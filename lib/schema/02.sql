-- 2 up
CREATE TABLE users (
   id serial primary key,
   name text,
   password text
);

CREATE INDEX ON users (id);

CREATE TABLE drafts (
   id serial primary key,
   host_id integer references users(id),
   name text,
   sets text[],
   cube text,
   nplayers integer not null,
   npacks integer not null,
   ncards integer not null
);

CREATE INDEX ON drafts (id);
CREATE INDEX ON drafts (host_id);

CREATE TABLE drafters (
   id serial primary key,
   user_id integer not null references users(id),
   draft_id integer not null references drafts(id)
);

CREATE INDEX ON drafters (id);
CREATE INDEX ON drafters (user_id);
CREATE INDEX ON drafters (draft_id);

CREATE TABLE packs (
   id serial primary key,
   no integer not null,
   drafter_id integer references drafters(id)
);

CREATE INDEX ON packs (id);
CREATE INDEX ON packs (drafter_id);

CREATE TABLE picks (
   id serial primary key,
   print_id integer not null references prints(id),
   pack_id integer not null references packs(id),
   drafter_id integer references drafters(id),
   packno integer,
   pickno integer not null,
   unique (drafter_id, packno, pickno)
);

CREATE INDEX ON picks (id);
CREATE INDEX ON picks (drafter_id);
CREATE INDEX ON picks (print_id);

-- 2 down
DROP TABLE picks;
DROP TABLE packs;
DROP TABLE drafters;
DROP TABLE drafts;
DROP TABLE users;
