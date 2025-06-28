--З’єднання таблиць:
--1Відобразити імена та прізвища студентів та назви курсів, що ними вивчаються.
SELECT s.name, surname, c.title
FROM students AS s
             INNER JOIN exams AS e ON s.id_stud = e.id_stud
             INNER JOIN courses AS c ON e.id_course = c.id_course;


--2Створити представлення по запиту 1.
CREATE VIEW students_to_courses AS
SELECT s.name, surname, c.title
FROM students AS s
             INNER JOIN exams AS e ON s.id_stud = e.id_stud
             INNER JOIN courses AS c ON e.id_course = c.id_course;


--3Відобразити бали студента Петра Петренка з дисципліни «Computer Networks».
INSERT INTO students(name,surname,birthday)
VALUES('Petro','Petrenko', '2002-04-22');

INSERT INTO exams(id_stud, id_course, mark)
VALUES(4, 1, 3.79);

SELECT e.mark, c.title
FROM exams AS e 
            INNER JOIN students AS s ON e.id_stud = s.id_stud
            INNER JOIN courses AS c ON e.id_course = c.id_course
WHERE s.id_stud  = 4 AND c.id_course = 1;


--4Відобразити студентів, які мають бали нижче 3.5.
UPDATE exams
SET mark = 3.5
WHERE id_stud = 2

UPDATE exams
SET mark = 3.9
WHERE id_stud = 2 AND id_course = 1;

SELECT s.name, surname, e.mark
FROM students AS s JOIN exams AS e ON s.id_stud = e.id_stud
WHERE mark < 3.5;


--5Відобразити студентів, які прослухали дисципліну «Computer Networks»
-- та мають за неї оцінку.
SELECT s.name, surname, c.title, e.mark
FROM students AS s INNER JOIN exams AS e ON s.id_stud = e.id_stud
                   INNER JOIN courses AS c ON e.id_course = c.id_course               
WHERE c.title = 'Computer Networks';                  


--6Відобразити середній бал та кількість курсів, які відвідав кожен студент.
SELECT s.id_stud, name, surname, COUNT(e.id_course) AS count_course, AVG(e.mark) AS avg_mark
FROM students AS s INNER JOIN exams AS e ON s.id_stud = e.id_stud
GROUP BY s.id_stud, s.name, s.surname;   


--7Відобразити студентів, які мають середній бал вище 4.0.
SELECT s.name, surname, AVG(e.mark) 
FROM students AS s INNER JOIN exams AS e ON s.id_stud = e.id_stud
GROUP BY s.name, s.surname
HAVING AVG(e.mark) > 4;


--*8Відобразити дисципліни, які ще не прослухав жоден студент.
INSERT INTO courses(title,description,hours)
VALUES ('Algorithms and Data Structures', 'Programming in Java, lists, trees', 400);

SELECT c.id_course, c.title
FROM courses AS c LEFT JOIN exams AS e ON c.id_course = e.id_course
WHERE e.id_course IS NULL;  



--(Підзапити:)
--9 Отримати список студентів, 
--у яких день народження збігається із днем народження Петра Петренка.
UPDATE students
SET birthday = '2001-01-22'
WHERE id_stud = 3;

SELECT name, surname, birthday
FROM students
WHERE EXTRACT(DAY FROM birthday) = 22;



--10 Відобразити студентів, які мають середній бал вище, ніж Петро Петренко.
SELECT s.id_stud, name, surname, AVG(e.mark) 
FROM students AS s INNER JOIN exams AS e ON s.id_stud = e.id_stud
GROUP BY s.id_stud, s.name, s.surname
HAVING AVG(e.mark) > (SELECT AVG(mark) 
                      FROM exams 
                      WHERE id_stud = 4
);


--11 Отримати список предметів, у яких кількість годин більше, ніж у "Cisco Basics".
SELECT title, hours
FROM courses
WHERE hours > (SELECT hours
              FROM courses
              WHERE title = 'Cisco Basics');


            
--  12 Отримати список
--студент | предмет | оцінка
--де оцінка має бути більшою за будь-яку оцінку Петра Петренка.
SELECT s.name || ' ' ||s.surname AS Fullname, c.title, e.mark
FROM students AS s INNER JOIN exams AS e ON s.id_stud = e.id_stud 
                   INNER JOIN courses AS c ON e.id_course = c.id_course      
WHERE e.mark > ANY (SELECT mark
                FROM exams
                WHERE id_stud = 4)
ORDER BY e.mark DESC;  


--(Умовні вирази:)
--13 Вивести
--студент | предмет | оцінка
--щоб оцінка виводилася у літерному вигляді "відмінно", "добре" або "задовільно".
SELECT s.name || ' ' ||s.surname AS Fullname, c.title, e.mark,
CASE 
     WHEN e.mark > 0 AND e.mark <= 4 THEN 'satisfactory'
     WHEN e.mark > 4 AND e.mark <= 7 THEN 'good'
     WHEN e.mark > 7 AND e.mark <= 10 THEN 'excellent'
     ELSE 'invalid'
     END AS grade
FROM students AS s INNER JOIN exams AS e ON s.id_stud = e.id_stud 
                   INNER JOIN courses AS c ON e.id_course = c.id_course;      
