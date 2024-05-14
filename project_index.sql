-- квартиры
-- idx_цена_квартиры - Индекс на столбце цена для ускорения поиска по цене
-- idx_статус - Индекс на столбце статус для ускорения поиска квартир, доступных для покупки

CREATE INDEX idx_цена_квартиры ON project.квартиры (цена);
CREATE INDEX idx_статус ON project.квартиры (статус);

-- дома
-- idx_адрес Индекс на столбце адрес для ускорения поиска домов по адресу

CREATE INDEX idx_адрес ON project.дома (адрес);


-- операции
-- idx_apartment_id - Индекс на столбце apartment_id для ускорения поиска операций, связанных с конкретной квартирой
-- idx_user_id - Индекс на столбце user_id для ускорения поиска операций, совершенных определенным пользователем
DROP INDEX project.idx_operations_user_id;
CREATE INDEX idx_op_apartment_id ON project.операции (apartment_id);
CREATE INDEX idx_op_user_id ON project.операции (user_id);


-- отзывы
-- idx_apartment_id - Индекс на столбце apartment_id для ускорения поиска отзывов о конкретной квартире
-- idx_user_id - Индекс на столбце user_id для ускорения поиска отзывов, оставленных определенным пользователем

CREATE INDEX idx_review_apartment_id ON project.отзывы (apartment_id);
CREATE INDEX idx_review_user_id ON project.отзывы (user_id);


-- избраное
-- idx_user_id - Индекс на столбце user_id для ускорения поиска избранных квартир определенного пользователя
-- idx_apartment_id - Индекс на столбце apartment_id для ускорения поиска пользователей, добавивших определенную квартиру в избранное

CREATE INDEX idx_fav_user_id ON project.избранное (user_id);
CREATE INDEX idx_fav_apartment_id ON project.избранное (apartment_id);