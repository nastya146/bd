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
