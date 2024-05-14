-- Триггер для обновления статуса квартиры при успешной продаже/сдаче в аренду:

CREATE OR REPLACE FUNCTION project.update_apartment_status()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.сумма = (select цена from project.квартиры as к where к.apartment_id = NEW.apartment_id)
  THEN UPDATE project.квартиры 
    SET статус = 'продана', цена = 'Nan', дата_изменения = current_date
    WHERE apartment_id = NEW.apartment_id;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER apartment_status_update
AFTER INSERT ON project.операции
FOR EACH ROW
EXECUTE PROCEDURE project.update_apartment_status();

-- примеры
select * from project.операции;
select * from project.квартиры;
select
INSERT INTO project.операции (pair_id, apartment_id, user_id, сумма)
VALUES (16, 2, 1, 120000);

INSERT INTO project.операции (pair_id, apartment_id, user_id, сумма)
VALUES (17, 1, 2, 150000);

-- Триггер для обновления истории при изменении данных в таблице квартиры:

CREATE OR REPLACE FUNCTION project.update_history()
RETURNS TRIGGER AS $$
BEGIN 
	INSERT INTO project.история (history_id, apartment_id, owner_id, цена, дата_изменения, статус)
 	VALUES ((select max(history_id) + 1 from project.история), OLD.apartment_id, OLD.owner_id, OLD.цена, OLD.дата_изменения, OLD.статус);
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER history_update
AFTER UPDATE ON project.квартиры
FOR EACH ROW
EXECUTE PROCEDURE project.update_history();
--
select * from project.история;
select * from project.квартиры;
select * from project.дома;
select * from project.add_apartment_with_check(13 ,'ул. Гагарина, д. 25', 20, 1, 1000000, 'аренда жилая');

UPDATE project.квартиры
SET цена = 1002000
where apartment_id = 18;
--

-- Триггер для обновления средней оценки дому при добавлении отзыва:

CREATE OR REPLACE FUNCTION project.update_rate()
RETURNS TRIGGER AS $$
BEGIN 
	UPDATE project.дома
	SET средняя_оценка = (select avg(оценка) from project.отзывы where apartment_id = NEW.apartment_id);
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER history_update
AFTER INSERT ON project.отзывы
FOR EACH ROW
EXECUTE PROCEDURE project.update_rate();
--
select * from project.отзывы;
select * from project.квартиры;
select * from project.дома;
select * from project.add_apartment_with_check(13 ,'ул. Гагарина, д. 25', 20, 1, 1000000, 'аренда жилая');

select * from project.отзывы where apartment_id = 2;
INSERT INTO project.отзывы(comment_id, user_id, apartment_id, оценка)
VALUES (31, 10, 2, 4);
--
