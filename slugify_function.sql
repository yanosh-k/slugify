DROP FUNCTION IF EXISTS `BG_SLUGIFY`;
DELIMITER ;;

CREATE FUNCTION `SLUGIFY`(dirty_string VARCHAR(255))
	RETURNS VARCHAR(255)
	DETERMINISTIC
BEGIN
	
	DECLARE allowed_chars, new_string VARCHAR(255);
	DECLARE found_equiv, current_char VARCHAR(5);
	DECLARE counter, string_length, temp_table_rows INT(10);
	DECLARE is_allowed TINYINT(1);
	
	SET new_string = '';
	SET dirty_string = REPLACE(TRIM(REPLACE(dirty_string, '.', '-')), ' ', '-');
	SET allowed_chars = 'abcdefghijklmnopqrstuvwxyz0123456789-';
	SET string_length = CHAR_LENGTH(dirty_string);
	SET counter = 1;
	
	WHILE LOCATE('--', dirty_string) > 0 DO
		SET dirty_string = REPLACE(dirty_string, '--', '-');
	END WHILE;

	CREATE TEMPORARY TABLE IF NOT EXISTS slug_temp_table (bul_letter VARCHAR(5) NOT NULL, eng_equiv VARCHAR(5) NOT NULL);
	SELECT COUNT(*) INTO temp_table_rows FROM slug_temp_table;
	IF temp_table_rows = 0 THEN
		INSERT INTO slug_temp_table (bul_letter, eng_equiv) VALUES ('а', 'a'), ('б', 'b'), ('в', 'v'), ('г', 'g'), ('д', 'd'), ('е', 'e'), ('ж', 'j'), ('з', 'z'), ('и', 'i'), ('й', 'j'), ('к', 'k'), ('л', 'l'), ('м', 'm'), ('н', 'n'), ('о', 'o'), ('п', 'p'), ('р', 'r'), ('с', 's'), ('т', 't'), ('у', 'u'), ('ф', 'f'), ('х', 'h'), ('ц', 'c'), ('ч', 'ch'), ('ш', 'sh'), ('щ', 'sht'), ('ъ', 'y'), ('ь', 'i'), ('ю', 'u'), ('я', 'ja');
	END IF;
	
	
	WHILE counter <= string_length DO
		SET current_char = SUBSTRING(dirty_string, counter, 1);
		SET is_allowed = LOCATE(current_char, allowed_chars);
		IF is_allowed > 0 THEN
			SET new_string = CONCAT(new_string, LOWER(current_char));
		ELSE
			SELECT slug_temp_table.eng_equiv INTO found_equiv FROM slug_temp_table WHERE slug_temp_table.bul_letter = current_char;
			IF CHAR_LENGTH(found_equiv) > 0 THEN
				SET new_string = CONCAT(new_string, found_equiv);
			END IF;
		END IF;
		
		SET found_equiv = '';
		SET counter = counter + 1;
	END WHILE;
	
	RETURN new_string;

END;;
DELIMITER ;