-- 0) Проверка наличия дома в базе данных 
CREATE OR REPLACE FUNCTION check_house(новый_адрес varchar(200))
RETURNS BOOLEAN
LANGUAGE plpgsql
AS $$
BEGIN
  IF EXISTS (SELECT * FROM project.дома WHERE дома.адрес = новый_адрес) THEN
    RETURN TRUE;
  ELSE
    RETURN FALSE;
  END IF;
END;
$$;

-- 1) Добавление нового дома в базу данных (процедура)

CREATE PROCEDURE project.add_house (
    н_адрес varchar(200),
    н_район varchar(200),
    н_этажность INT,
    н_класс_дома varchar(20)
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO project.дома (house_id, адрес, район, этажность, класс_дома)
    VALUES ((select max(house_id) + 1 from project.дома), н_адрес, н_район, н_этажность, н_класс_дома);
END;
$$;

call project.add_house('ул. Бардина 48а', 'Юго-западный', 10, 'элитный');
select * from project.дома where адрес = 'ул. Бардина 48а';

-- 2) Добавление новой квартиры в базу данных

CREATE OR REPLACE FUNCTION project.add_apartment_with_check(
    н_user_id int,
    н_адрес VARCHAR(200),
    н_площадь float,
    н_комнаты int,
    н_цена float,
    н_статус varchar(20)
)
RETURNS TEXT
LANGUAGE plpgsql
AS $$
BEGIN
    IF EXISTS (SELECT * FROM project.дома WHERE адрес = н_адрес) THEN
        INSERT INTO project.квартиры (apartment_id, house_id, комнаты, площадь, owner_id, цена, дата_изменения, статус)
        VALUES ((select max(apartment_id) + 1 from project.квартиры), (select house_id from project.дома WHERE адрес = н_адрес), н_комнаты, н_площадь, н_user_id, н_цена, current_date, н_статус);
        RETURN 'Квартира успешно добавлена';
    ELSE
        RETURN 'Дом с таким адресом не найден. Добавьте дом перед добавлением квартиры.';
    END IF;
END;
$$;

SELECT * 
FROM project.add_apartment_with_check(1, CAST('ул. Пушкина, д. 15' AS varchar(200)), CAST(500 as float), 6, CAST(7000000 as float), CAST('продажа жилая' as varchar(20)));
SELECT * 
FROM project.add_apartment_with_check(1, CAST('ул. Птушкина, д. 15' AS varchar(200)), CAST(500 as float), 6, CAST(7000000 as float), CAST('продажа жилая' as varchar(20)));

-- 3) recommended_apartments - возвращает список рекомендуемых квартир для пользователя на основе его избранных квартир (похожие по цене, площади и количеству комнат).

DROP FUNCTION project.get_recommended_apartments(integer);
CREATE OR REPLACE FUNCTION project.get_recommended_apartments (
    user_id INT
)
RETURNS TABLE (
    apartment_id INT,
    комнаты INT,
    площадь FLOAT,
    цена FLOAT,
    статус VARCHAR(20)
)
LANGUAGE plpgsql
AS $$
BEGIN
  RETURN QUERY
    WITH избранное_пользователя AS (SELECT и.apartment_id as apartment_id FROM project.избранное и WHERE и.user_id = get_recommended_apartments.user_id)
    SELECT к.apartment_id, к.комнаты, к.площадь, к.цена, к.статус
    FROM project.квартиры к
    WHERE к.apartment_id NOT IN (SELECT п.apartment_id FROM избранное_пользователя as п)
    AND EXISTS (
        SELECT *
        FROM избранное_пользователя as ип JOIN project.квартиры as ик USING(apartment_id)
        WHERE ABS(к.цена - ик.цена) < 100000
        AND ABS(к.площадь - ик.площадь) < 10
        AND к.комнаты = ик.комнаты
		AND к.статус = ик.статус
    );
END;
$$;

select * from project.get_recommended_apartments(1);
