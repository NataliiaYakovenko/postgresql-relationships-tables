CREATE DATABASE university;


CREATE TABLE students(
    id_stud SERIAL PRIMARY KEY,
    name VARCHAR(64) CHECK(name != '') NOT NULL,
    surname VARCHAR(64) CHECK(surname != '') NOT NULL,
    birthday DATE CHECK(birthday <= current_date) NOT NULL
);
INSERT INTO students(name,surname,birthday)
VALUES('Tom','Tomson','2000-12-01'),
      ('Nadin','Harton','2000-08-24'),
      ('Jerry','Brown','2001-01-09');



CREATE TABLE courses (
    id_course SERIAL PRIMARY KEY,
    title VARCHAR(64) CHECK(title != '') NOT NULL UNIQUE,
    description TEXT CHECK(description != '') NOT NULL,
    hours INTEGER CHECK(hours > 0 AND hours <= 1000)
);
INSERT INTO courses(title,description,hours)
VALUES ('Computer Networks', 'TCP/IP, routing, protocols', 480),
       ('Cisco Basics', 'Router configuration, network security', 460),
       ('Wi-Fi and Wireless Networks', 'Setup, configuration, diagnostics', 500);



CREATE TABLE exams(
    id_stud INT REFERENCES students(id_stud),
    id_course INT REFERENCES courses(id_course),
    mark NUMERIC(3, 2) CHECK(mark >= 0) NOT NULL,
    PRIMARY KEY (id_stud, id_course)
);
INSERT INTO exams(id_stud,id_course,mark)
VALUES(1, 2, 7.89),
      (1, 3, 6.55),
      (2, 1, 8.00),
      (2, 2, 7.45),
      (3, 1, 9.20),
      (3, 3, 7.68);



