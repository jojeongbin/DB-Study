# 현재 세션에서 `ONLY_FULL_GROUP_BY` 모드 끄기
## 영구적으로 설정되는 것은 아닙니다.
SET SESSION sql_mode = (SELECT REPLACE(@@sql_mode, 'ONLY_FULL_GROUP_BY', ''));
SET sql_mode = (SELECT REPLACE(@@sql_mode, 'ONLY_FULL_GROUP_BY', ''));

# a6 DB 삭제/생성/선택
DROP DATABASE IF EXISTS a6;
CREATE DATABASE a6;
USE a6;

# 부서(홍보, 기획)
CREATE TABLE dept (
    id INT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    regDate DATETIME NOT NULL,
    `name` CHAR(100) NOT NULL UNIQUE
);

INSERT INTO dept
SET regDate = NOW(),
`name` = '홍보';

INSERT INTO dept
SET regDate = NOW(),
`name` = '기획';

# 사원(홍길동/홍보/5000만원, 홍길순/홍보/6000만원, 임꺽정/기획/4000만원)
CREATE TABLE emp (
    id INT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    regDate DATETIME NOT NULL,
    `name` CHAR(100) NOT NULL,
    deptId INT UNSIGNED NOT NULL,
    salary INT UNSIGNED NOT NULL
);

INSERT INTO emp
SET regDate = NOW(),
`name` = '홍길동',
deptId = 1,
salary = 5000;

INSERT INTO emp
SET regDate = NOW(),
`name` = '홍길순',
deptId = 1,
salary = 6000;

INSERT INTO emp
SET regDate = NOW(),
`name` = '임꺽정',
deptId = 2,
salary = 4000;

# 1단계 : 각 부서별 최고연봉자의 연봉을 구한다.
SELECT E.deptId AS id,
MAX(E.salary) AS maxSalary
FROM emp AS E
GROUP BY E.deptId

# 2단계 : 사원테이블과 부서테이블(서브쿼리)을 조인한다.
SELECT E.id,
E.name,
E.salary,
D.id AS deptId,
D.maxSalary
FROM emp AS E
INNER JOIN (
    SELECT E.deptId AS id,
    MAX(E.salary) AS maxSalary
    FROM emp AS E
    GROUP BY E.deptId
) AS D
ON E.deptId = D.id;

# 3단계 : 사원테이블과 부서테이블(서브쿼리)을 조인할 때 사원의 연봉과 부서의 최고연봉이 일치해야한 다는 조건을 추가해서, 최고연봉자가 아닌 사람들이 자연스럽게 필터링 되도록 한다.
SELECT E.id,
E.name,
E.salary,
D.id AS deptId,
D.maxSalary
FROM emp AS E
INNER JOIN (
    SELECT E.deptId AS id,
    MAX(E.salary) AS maxSalary
    FROM emp AS E
    GROUP BY E.deptId
) AS D
ON E.deptId = D.id
AND E.salary = D.maxSalary; # 추가됨, 핵심

# 4단계 : 추가 JOIN 을 통해서 부서명을 얻는다.
SELECT D2.name AS `부서명`,
E.name AS `사원명`,
DATE(E.regDate) AS `입사일`,
CONCAT(FORMAT(E.salary, 0), '만원') AS `연봉`
FROM emp AS E
INNER JOIN (
    SELECT E.deptId AS id,
    MAX(E.salary) AS maxSalary
    FROM emp AS E
    GROUP BY E.deptId
) AS D
ON E.deptId = D.id
AND E.salary = D.maxSalary
INNER JOIN dept AS D2 # 추가 조인
ON E.deptId = D2.id;