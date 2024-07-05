CREATE DATABASE kampus;
USE kampus;
CREATE TABLE teachers (
    id INT AUTO_INCREMENT,
    NAME VARCHAR(100),
    SUBJECT VARCHAR(50),
    PRIMARY KEY(id)
);

INSERT INTO teachers (NAME, SUBJECT) VALUES ('Pak Anton', 'Matematika');
INSERT INTO teachers (NAME, SUBJECT) VALUES ('Bu Dina', 'Bahasa Indonesia');
INSERT INTO teachers (NAME, SUBJECT) VALUES ('Pak Eko', 'Biologi');

CREATE TABLE classes (
    id INT AUTO_INCREMENT,
    NAME VARCHAR(50),
    teacher_id INT,
    PRIMARY KEY(id),
    FOREIGN KEY (teacher_id) REFERENCES teachers(id)
);

INSERT INTO classes (NAME, teacher_id) VALUES ('Kelas 10A', 1);
INSERT INTO classes (NAME, teacher_id) VALUES ('Kelas 11B', 2);
INSERT INTO classes (NAME, teacher_id) VALUES ('Kelas 12C', 3);

CREATE TABLE students (
    id INT AUTO_INCREMENT,
    NAME VARCHAR(100),
    age INT,
    class_id INT,
    PRIMARY KEY(id),
    FOREIGN KEY (class_id) REFERENCES classes(id)
);

INSERT INTO students (NAME, age, class_id) VALUES ('Budi', 16, 1);
INSERT INTO students (NAME, age, class_id) VALUES ('Ani', 17, 2);
INSERT INTO students (NAME, age, class_id) VALUES ('Candra', 18, 3);

#1. Tampilkan daftar siswa beserta kelas dan guru yang mengajar kelas tersebut.
SELECT s.Name AS student, s.age, c.Name AS Class, t.Name AS Teacher 
FROM students s INNER JOIN classes c ON s.class_id=c.id
INNER JOIN teachers t ON c.teacher_id=t.id;

#2. Tampilkan daftar kelas yang diajar oleh guru yang sama.
SELECT c.Name AS Class, t.Name AS Teacher 
FROM classes c INNER JOIN teachers t ON c.teacher_id=t.id
WHERE t.name = "Bu Dina";

#3. buat query view untuk siswa, kelas, dan guru yang mengajar
CREATE VIEW view_students AS
SELECT * FROM students;
CREATE VIEW view_classes AS
SELECT * FROM classes;
CREATE VIEW view_teachers AS
SELECT * FROM teachers;

SELECT * FROM view_students;
SELECT * FROM view_classes;
SELECT * FROM view_teachers;

#4. buat query yang sama tapi menggunakan store_procedure
DELIMITER $$
CREATE PROCEDURE select_all_students()
BEGIN
	SELECT * FROM students;
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE select_all_teachers()
BEGIN
	SELECT * FROM teachers;
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE select_all_classes()
BEGIN
	SELECT * FROM classes;
END $$
DELIMITER ;

CALL select_all_students();
CALL select_all_teachers();
CALL select_all_classes();

#5. buat query input, yang akan memberikan warning error jika ada data yang sama pernah masuk
DELIMITER $$

CREATE PROCEDURE add_student (
    IN s_name VARCHAR(100),
    IN s_age INT,
    IN s_class INT
)
BEGIN
    IF EXISTS (SELECT * FROM students WHERE NAME = s_name) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Duplicate entry for name';
    ELSE
        INSERT INTO students (NAME, age, class_id)
        VALUES (s_name, s_age, s_class);
    END IF;

    COMMIT;
END $$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE add_class (
    IN c_name VARCHAR(100),
    IN c_teacher INT
)
BEGIN
    IF EXISTS (SELECT * FROM classes WHERE NAME = c_name) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Duplicate entry for class';
    ELSE
        INSERT INTO classes (NAME, teacher_id)
        VALUES (c_name, c_teacher);
    END IF;

    COMMIT;
END $$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE add_teacher (
    IN t_name VARCHAR(100),
    IN t_subject VARCHAR(100) 
)
BEGIN
    IF EXISTS (SELECT * FROM teachers WHERE NAME = t_name) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Duplicate entry for teacher';
    ELSE
        INSERT INTO teachers (NAME, SUBJECT)
        VALUES (t_name, t_subject);
    END IF;

    COMMIT;
END $$

DELIMITER ;

CALL add_student('Yaya', 10, 1);
CALL add_class('Kelas 10B', 2);
CALL add_teacher('Pak Ahmad', 'Teknik');

#semua QUERY dikumpulkan pada git melalui github/gitlab kalian
