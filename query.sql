-- вывести в порядке убывания средней оценки: id квартир, их среднюю оценку и количество оценок

SELECT apartament_id, AVG(отзывы.оценка) AS средняя_оценка, COUNT(apartament_id)
FROM project.отзывы
GROUP BY apartament_id
ORDER BY средняя_оценка DESC;

-- вывести id домов и среднюю оценку квартир в них

SELECT квартиры.house_id, AVG(отзывы.оценка) AS средняя_оценка
FROM project.квартиры as квартиры
JOIN project.отзывы ON квартиры.apartament_id = отзывы.apartament_id
GROUP BY квартиры.house_id;

-- вывести максимальну и минимальную стоимость недвижимости в каждой категории

SELECT статус, max(цена) as максимальная_стоимость, min(цена) as минимальная_стоимость
FROM project.квартиры
GROUP BY статус;

-- вывести id недвижимости, которая имеет максимальную стоимость в каждой категории

SELECT apartament_id, статус, цена
FROM (SELECT 
	apartament_id,
	статус,
	цена,
	ROW_NUMBER() OVER(PARTITION BY статус ORDER BY цена DESC) as rn
	FROM project.квартиры)
WHERE rn = 1;

-- вывести для каждого района среднюю, максимальную и минимальную оценку на квартиру и количество отзывов, относящихся к квартирам этого района.

SELECT район, avg(оценка), max(оценка), min(оценка), count(apartament_id)
FROM project.квартиры as квартиры
JOIN project.отзывы   USING(apartament_id) JOIN project.дома USING(house_id)
GROUP BY район;

-- вывести для каждого района среднюю, максимальную и минимальную стоимость на квартиру и их количество в этом районе

SELECT район, avg(цена), max(цена), min(цена), count(apartament_id)
FROM project.квартиры as квартиры
JOIN project.дома USING(house_id)
WHERE цена != 'Nan'
GROUP BY район;

-- вывести для каждого района, в котором количество продающихся квартир больше трех, среднюю стоимость квартиры

SELECT район, avg(цена) as средняя_цена
FROM project.квартиры as квартиры
join project.дома using(house_id)
where цена != 'Nan'
group by район
having count(apartament_id) > 3;

-- вывести сколько раз каждую квартиру добавили в избранное в порядке убывани количества добавления.

SELECT apartament_id, count(apartament_id)
FROM project.избранное
GROUP BY apartament_id
ORDER BY count(apartament_id) DESC;

-- вывести сумму денежных операций пользователя user_id = 1, совершенных в январе 2022 года

select sum(money) 
from project.операции
where user_id = 1 and data_transition between '2022-01-01' and '2022-02-01';

-- вывести топ 5 пользователей по числу оставленных отзывов

select user_id, count(user_id)
from project.отзывы
group by user_id
order by count(user_id) DESC
limit 5;



