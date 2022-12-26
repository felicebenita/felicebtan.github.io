/* == Question 1.A == */

/* Technique 1 - Using Subquery */
SELECT * FROM student WHERE student_id NOT IN (SELECT student_id FROM classroom);

/* Technique 2 - Using Left Join */
SELECT student_id, name, age FROM student
LEFT JOIN classroom USING (student_id)
WHERE classroom.student_id IS NULL;


/* == Question 1.B == */

/* Display only students that have classroom */
SELECT s.*, c.classroom_id FROM student s JOIN classroom c ON s.student_id = c.student_id;

/* Display all students (both have classroom and have no classroom) */
SELECT s.*, CASE COALESCE(c.classroom_id, '') WHEN '' THEN 'no classroom' ELSE c.classroom_id END AS classrom_id
FROM student s
LEFT JOIN classroom c ON s.student_id = c.student_id;


/* == Question 1.C == */

SELECT student_group, COUNT(student_id) 'total_student' FROM
(
	SELECT *, CASE WHEN age > 15 THEN 'high school' WHEN age < 16 THEN 'middle school' ELSE 'unspecified' END AS student_group
	FROM student
) AS s
GROUP BY student_group;


/* == Question 1.D == */

SELECT * FROM student WHERE age = (SELECT MAX(age) FROM student);


/* == Question 1.E == */

/* This method can be used if the student_id is auto increment, so the rows below always have the larger id (and are the later data), so comparison can be made based on student_id to calculate the cumulative_age. */
SELECT *, (SELECT COALESCE(SUM(age),0) FROM student s1 WHERE s1.student_id <= s.student_id) 'cumulative_age' FROM student s;


/* If student_id is not auto-increment, it can be done by sorting the data based on the data order determinant column, for example: entry_date, and doing a comparison based on entry_date to calculate the cumulative_age. */
/* Example : */
SELECT *,
	(SELECT COALESCE(SUM(age),0) FROM student_copy s1 WHERE s1.entry_date <= s.entry_date ORDER BY s1.entry_date) 'cumulative_age'
FROM student_copy s
ORDER BY s.entry_date;


/* Example Table : */

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for student_copy
-- ----------------------------
DROP TABLE IF EXISTS `student_copy`;
CREATE TABLE `student_copy`  (
  `student_id` int(11) NULL DEFAULT NULL,
  `name` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL,
  `age` int(11) NULL DEFAULT NULL,
  `entry_date` datetime(0) NULL DEFAULT NULL
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of student_copy
-- ----------------------------
INSERT INTO `student_copy` VALUES (3, 'john', 15, '2022-04-20 13:46:57');
INSERT INTO `student_copy` VALUES (2, 'marqueez', 16, '2022-04-21 13:46:57');
INSERT INTO `student_copy` VALUES (1, 'chip', 14, '2022-04-24 13:46:57');
INSERT INTO `student_copy` VALUES (4, 'marley', 14, '2022-04-23 13:46:57');

SET FOREIGN_KEY_CHECKS = 1;



