DROP TABLE IF EXISTS faculties CASCADE;
DROP TABLE IF EXISTS programs CASCADE;
DROP TABLE IF EXISTS courses CASCADE;
DROP TABLE IF EXISTS courses_programs CASCADE;
DROP TABLE IF EXISTS instructors CASCADE;
DROP TABLE IF EXISTS pre_requisites CASCADE;

CREATE TABLE faculties(
    faculty_id VARCHAR(4) PRIMARY KEY,
    faculty_name VARCHAR(100) NOT NULL,
    faculty_description TEXT NOT NULL
);

CREATE TABLE programs (
  program_id CHAR(4) PRIMARY KEY,
  faculty_id VARCHAR(4) NOT NULL,
  program_name VARCHAR(50) NOT NULL,
  program_location VARCHAR(50) NOT NULL,
  program_description TEXT NOT NULL,
  FOREIGN KEY (faculty_id)
    REFERENCES faculties (faculty_id)
);

CREATE TABLE instructors (
  instructor_id INT PRIMARY KEY,
  email VARCHAR (50) NOT NULL,
  instructor_name VARCHAR (50),
  office_location VARCHAR (50),
  telephone CHAR (20),
  degree VARCHAR(5)
);

CREATE TABLE courses (
  course_id INT PRIMARY KEY,
  code CHAR ( 8 ) NOT NULL,
  year INT NOT NULL,
  semester INT NOT NULL,
  section VARCHAR (10) NOT NULL,
  title VARCHAR ( 100 ) NOT NULL,
  credits INT NOT NULL,
  modality VARCHAR ( 50 ) NOT NULL,
  modality_type VARCHAR(20) NOT NULL,
  instructor_id INT NOT NULL,
  class_venue VARCHAR(100),
  communication_tool  VARCHAR(25),
  course_platform VARCHAR(25),
  field_trips VARCHAR(3) check(field_trips in ('Yes','No')),
  resources_required TEXT NOT NULL,
  resources_recommended TEXT NOT NULL,
  resources_other TEXT NOT NULL,
  description TEXT NOT NULL,
  outline_url TEXT NOT NULL,
  UNIQUE (code, year, semester, section),
  FOREIGN KEY (instructor_id)
    REFERENCES instructors (instructor_id)
);
  
CREATE TABLE courses_programs (
  course_id INT NOT NULL,
  program_id CHAR(4) NOT NULL,
  FOREIGN KEY (program_id)
    REFERENCES programs (program_id),
  FOREIGN KEY (course_id)
    REFERENCES courses (course_id)
);

CREATE TABLE pre_requisites(
  course_id INT NOT NULL,
  prereq_id VARCHAR(8) NOT NULL,
  PRIMARY Key(prereq_id,course_id),
  FOREIGN Key(course_id)
   REFERENCES courses (course_id)
);

--importing data
COPY faculties
FROM '/home/mikhail/Downloads/faculties.csv'
DELIMITER ','
CSV HEADER;

COPY programs
FROM '/home/mikhail/Downloads/programs.csv'
DELIMITER ','
CSV HEADER;

COPY instructors
FROM '/home/mikhail/Downloads/instructors.csv'
DELIMITER ','
CSV HEADER;

COPY courses
FROM '/home/mikhail/Downloads/courses.csv'
DELIMITER ','
CSV HEADER;

COPY courses_programs
FROM '/home/mikhail/Downloads/courses_programs.csv'
DELIMITER ','
CSV HEADER;

COPY pre_requisites
FROM '/home/mikhail/Downloads/pre_reqs.csv'
DELIMITER ','
CSV HEADER;

--Queries
--What faculties at UB end in S?
SELECT faculty_id, faculty_name
FROM faculties
WHERE faculty_id
LIKE '%S';

--What programs are offered in Belize City?
SELECT program_id, program_name, program_location
FROM programs
WHERE program_location = 'Belize City';

--What courses does Mrs. Vernelle Sylvester teach?
SELECT course_id, code, year, semester, section, title, instructor_id, instructor_name
FROM courses
JOIN instructors
ON instructor_id=instructor_id
WHERE instructor_name = 'Vernelle Sylvester'
GROUP BY course_id, instructor_id;

--Which instructors have a Masters Degree?
SELECT instructor_id, instructor_name, degree
FROM instructors
WHERE degree = 'M.Sc.';

-- What are the prerequisites for Programming 2 ?
SELECT title, prereq_id 
FROM courses
JOIN pre_reqs
ON course_id = course_id
WHERE course_id = 3;

--List the code, year, semester, section and title for all courses.
SELECT code, year, semester, section, title
FROM courses;

--List the program_name and code, year, semester section and title for all courses in the AINT program.
SELECT program_id, program_name, code, year, semester, section, title
FROM programs
JOIN courses_programs
ON program_id = program_id
JOIN courses
ON course_id = course_id 
WHERE program_id = 'AINT';


-- List the faculty_name and code, year, semester section and title for all courses offered by FST.
SELECT faculty_id, faculty_name, year, semester, section, title
FROM faculties
JOIN programs
ON faculty_id = faculty_id
JOIN courses_programs
ON program_id = program_id
JOIN courses
ON course_id = course_id
WHERE faculty_id = 'FST';
