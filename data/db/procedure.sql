CREATE OR REPLACE FUNCTION analytics_avg(client_name varchar, op_name varchar,run_id bigint) RETURNS setof int AS $$
DECLARE
	total int;
	num_offset int := 0;
	num_limit int;
	array_values int[];
	array_item float;
BEGIN
	num_offset := 0;
	SELECT COUNT(*) INTO total FROM analyzer WHERE name = client_name AND operation = op_name AND run = run_id;
	num_limit := total / 25;
 	FOR i IN 0..24 LOOP
 		SELECT avg(delay) INTO array_item FROM (
 			SELECT delay FROM analyzer WHERE name = client_name AND operation = op_name AND run = run_id
 					ORDER BY id
 				LIMIT num_limit OFFSET num_offset) as res ;
 		array_values[i] = array_item::bigint / 1000000;
 		num_offset := num_offset + num_limit;
	END LOOP;
	return QUERY SELECT unnest(array_values);
END;
$$ LANGUAGE plpgsql;

DROP FUNCTION analytics_avg(client_name varchar, op_name varchar,run_id bigint)

CREATE INDEX analyzer_search ON analyzer(name,operation,run);
