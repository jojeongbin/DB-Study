# a5 데이터베이스 삭제/생성/선택
DROP DATABASE IF EXISTS a5;
CREATE DATABASE a5;
USE a5;

# 부서(dept) 테이블 생성 및 홍보부서 기획부서 추가
CREATE TABLE dept (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    PRIMARY KEY(id),
    regDate DATETIME NOT NULL,
    `name` CHAR(100) NOT NULL UNIQUE
);

INSERT INTO dept
SET regDate = NOW(),
`name` = '홍보';

INSERT INTO dept
SET regDate = NOW(),
`name` = '기획';

SELECT *
FROM dept;

# 사원(emp) 테이블 생성 및 홍길동사원(홍보부서), 홍길순사원(홍보부서), 임꺽정사원(기획부서) 추가
CREATE TABLE emp (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    PRIMARY KEY(id),
    regDate DATETIME NOT NULL,
    `name` CHAR(100) NOT NULL,
    deptName CHAR(100) NOT NULL
);

INSERT INTO emp
SET regDate = NOW(),
`name` = '홍길동',
deptName = '홍보';

INSERT INTO emp
SET regDate = NOW(),
`name` = '홍길순',
deptName = '홍보';

INSERT INTO emp
SET regDate = NOW(),
`name` = '임꺽정',
deptName = '기획';

SELECT *
FROM emp;

# 홍보를 마케팅으로 변경
## 부서명 변경(홍보 => 마케팅)
SELECT *
FROM dept;

UPDATE dept
SET `name` = '마케팅'
WHERE `name` = '홍보';

SELECT *
FROM dept;

## 사원테이블에서 부서명 변경(홍보 => 마케팅)
SELECT *
FROM emp;

UPDATE emp
SET deptName = '마케팅'
WHERE deptName = '홍보';

SELECT *
FROM emp;

# 마케팅을 홍보로 변경
## 부서명 변경(마케팅 => 홍보)

SELECT *
FROM dept;

UPDATE dept
SET `name` = '홍보'
WHERE `name` = '마케팅';

SELECT *
FROM dept;

## 사원테이블에서 부서명 변경(마케팅 => 홍보)
SELECT *
FROM emp;

UPDATE emp
SET deptName = '홍보'
WHERE deptName = '마케팅';

SELECT *
FROM emp;

# 홍보를 마케팅으로 변경
## 구조를 변경하기로 결정(사원 테이블에서, 이제는 부서를 이름이 아닌 번호로 기억)
ALTER TABLE emp ADD COLUMN deptId INT UNSIGNED NOT NULL;

SELECT *
FROM emp;

UPDATE emp
SET deptId = 1
WHERE deptName = '홍보';

UPDATE emp
SET deptId = 2
WHERE deptName = '기획';

SELECT *
FROM emp;

ALTER TABLE emp DROP COLUMN deptName;

## 이제 더 이상 emp 테이블에 부서명이 없다.
SELECT *
FROM emp;

## 부서명 변경(홍보 => 마케팅)
SELECT *
FROM dept;

UPDATE dept
SET `name` = '마케팅'
WHERE `name` = '홍보';

SELECT *
FROM dept;

# 사장님께 드릴 인명록을 생성
SELECT *
FROM emp;

# 사장님께서 부서번호가 아니라 부서명을 알고 싶어하신다.
## 그래서 dept 테이블 조회법을 알려드리고 혼이 났다.
SELECT *
FROM dept
WHERE id = 1;

# 사장님께 드릴 인명록을 생성(v2, 부서명 포함, ON 없이)
## 이상한 데이터가 생성되어서 혼남
SELECT emp.*, dept.name AS `부서명`
FROM emp
INNER JOIN dept; /* 2개 테이블의 모든 데이터들의 조합으로 구성된 무지성병합테이블이 생성되고 거기서 내용을 가져온다. */

# 사장님께 드릴 인명록을 생성(v3, 부서명 포함, 올바른 조인 룰(ON) 적용)
## 보고용으로 좀 더 편하게 보여지도록 고쳐야 한다고 지적받음
SELECT emp.*, dept.id, dept.name AS `부서명`
FROM emp
INNER JOIN dept
ON emp.deptId = dept.id; /* 무지성병합테이블에서 이상한 데이터를 없앤다, 즉 이 조건을 만족하지 못하는 녀석은 필터링 한다. INNER JOIN 사용할 때 ON 은 필수 */

# 사장님께 드릴 인명록을 생성(v4, 사장님께서 보시기에 편한 칼럼명(AS))
SELECT emp.id AS `사원번호`,
emp.name AS `사원명`,
DATE(emp.regDate) AS `입사일`,
dept.name AS `부서명`
FROM emp
INNER JOIN dept
ON emp.deptId = dept.id
ORDER BY `부서명`, `사원명`;

# 사장님께 드릴 인명록을 생성(v5, 테이블 AS 적용)
SELECT E.id AS `사원번호`,
E.name AS `사원명`,
DATE(E.regDate) AS `입사일`,
D.name AS `부서명`
FROM emp AS E
INNER JOIN dept AS D
ON E.deptId = D.id
ORDER BY `부서명`, `사원명`;