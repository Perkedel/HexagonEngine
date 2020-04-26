BEGIN TRANSACTION;
CREATE TABLE IF NOT EXISTS "PlaceSequence" (
	"value"	INTEGER,
	"name"	TEXT,
	"randomSequence"	INTEGER
);
INSERT INTO "PlaceSequence" ("value","name","randomSequence") VALUES (1,'book',3),
 (2,'dumble',4),
 (3,'window',8),
 (5,'laptop',1);
COMMIT;
