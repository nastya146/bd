CREATE SCHEMA IF NOT EXISTS project;

DROP TABLE IF EXISTS project.пользователи CASCADE;
CREATE TABLE  IF NOT EXISTS project.пользователи (
  "user_id" int,
  "ФИО" varchar(200) NOT NULL,
  "дата_регистрации" date,
  "дата_рождения" date CHECK(date_part('year', age(current_date, дата_рождения)) > 18),
  "Номер телефона" int UNIQUE NOT NULL,
  "почта" varchar(200) UNIQUE,
  PRIMARY KEY (user_id)
);

DROP TABLE IF EXISTS project.дома CASCADE;
CREATE TABLE IF NOT EXISTS project.дома (
  "house_id" int,
  "адресс" varchar(200) NOT NULL,
  "район" varchar(200),
  "этажность" int,
  "класс_дома" varchar(20),
  "средняя_оценка" numeric(3, 1) CHECK(оценка >= 0 AND оценка <= 5),
  PRIMARY KEY ("house_id")
);

DROP TABLE IF EXISTS project.квартиры CASCADE;
CREATE TABLE IF NOT EXISTS project.квартиры  (
  "apartament_id" int,
  "house_id" int REFERENCES project.дома(house_id),
  "rooms" int CHECK(rooms >= 1 AND rooms <= 30),
  "площадь" float,
  "owner_id" int REFERENCES project.пользователи(user_id),
  "цена" float,
  "дата_изменения" date,
  "статус" varchar(20),
  PRIMARY KEY ("apartament_id")
);

DROP TABLE IF EXISTS project.история CASCADE;
CREATE TABLE IF NOT EXISTS project.история (
  history_id int,
  apartament_id int,
  owner_id int,
  цена float,
  дата_изменения date,
  статус varchar(20),
  PRIMARY KEY (history_id)
);

DROP TABLE IF EXISTS project.отзывы CASCADE;
CREATE TABLE IF NOT EXISTS project.отзывы (
  "comment_id" int,
  "user_id" int REFERENCES project.пользователи(user_id),
  "apartament_id" int REFERENCES project.квартиры(apartament_id),
  "оценка" int NOT NULL,
  "дата" date,
  "коментарий" text,
  PRIMARY KEY ("comment_id")
);

DROP TABLE IF EXISTS project.избранное CASCADE;
CREATE TABLE IF NOT EXISTS project.избранное (
  "pair_id" int,
  "apartament_id" int REFERENCES project.квартиры(apartament_id),
  "user_id" int REFERENCES project.пользователи(user_id),
  PRIMARY KEY ("pair_id")
);

CREATE TABLE  IF NOT EXISTS project.операции (
  "pair_id" int,
  "apartament_id" int REFERENCES project.квартиры(apartament_id),
  "user_id" int REFERENCES project.пользователи(user_id),
  data_transition date,
  "money" int, 
  PRIMARY KEY ("pair_id")
);


