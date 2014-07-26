CREATE TABLE mdm_performance (
	"id"	integer not null GENERATED ALWAYS AS IDENTITY  (START WITH 1 INCREMENT BY 1),
	"name" varchar(100) not null,
	"run" varchar(100) not null,
	"operation" varchar(100) not null,
	"delay" integer not null,
	"date" timestamp not null,
	PRIMARY KEY("id"));
