CREATE OR REPLACE VIEW project.v_активные_объекты AS
SELECT t3.адресс, t3.район, t3.класс_дома, t3.средняя_оценка, t1.площадь, t1.комнаты, t1.статус, t1.цена, 
		t2.ФИО as владелец, t2.номер_телефона
FROM project.квартиры as t1 join project.пользователи as t2 on owner_id = user_id 
	join project.дома as t3 using(house_id) 
WHERE статус != 'продана';
