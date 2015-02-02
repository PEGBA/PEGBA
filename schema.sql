CREATE TABLE shirts(
	id INTEGER PRIMARY KEY,
	color TEXT,
	quantity INTEGER,
	img_url TEXT,
	price INTEGER
);

CREATE TABLE buyers(
	id INTEGER PRIMARY KEY,
	name TEXT,
	email TEXT,
	quantity INTEGER,
	color TEXT,
	shirtID INTEGER
);