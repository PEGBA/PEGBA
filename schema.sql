CREATE TABLE shirts (
	id INTEGER PRIMARY KEY,
	color TEXT,
	quantity INTEGER,
	img_url TEXT,
	price INTEGER,
	owner TEXT
);

CREATE TABLE buyers (
	id INTEGER PRIMARY KEY,
	name TEXT,
	email TEXT,
	quantity INTEGER,
	color TEXT,
	shirt_id INTEGER references shirts
);

CREATE TABLE purchases (
	id INTEGER PRIMARY KEY,
	shirt_id INTEGER,
	buyer_id INTEGER,
	quantity INTEGER
);

CREATE TABLE admin(
	id INTEGER PRIMARY KEY,
	username TEXT,
	password TEXT
);

