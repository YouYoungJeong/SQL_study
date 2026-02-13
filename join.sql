-- ★Join :  하나 이상의 테이블에서 원하는 자료 추출
-- 반드시 공총 칼럼이 필요
-- 조인은 반드시 두개씩 - 두개의 조인이 끝나면 그값으로 이어서 조인하는것.
# 사전 설정
INSERT INTO buser(buserno, busername) VALUES (50,'기획실')
ALTER TABLE jikwon MODIFY busernum INT NULL;
UPDATE jikwon SET busernum=NULL WHERE jikwonno=5;
SELECT * FROM buser;
SELECT * FROM jikwon;
DESC buser;
DESC jikwon;
DESC gogek;

# test.jikwon.jikwonname : test DB에 들어있는 jikwon테이블 안에 있는 jikwonname을 출력
SELECT test.jikwon.jikwonname FROM jikwon;
# 테이블에 별명 주기.
SELECT mytab.jikwonname FROM jikwon AS mytab;

-- CROSS JOIN 
-- 한쪽 테이블의 모든 행과 다른쪽 테이블의 모든 행을 연결(JOIN)하는 기능
-- 실제로 잘 쓰는 경우가 X

SELECT jikwonname, busername FROM jikwon, buser;
SELECT jikwonname, busername FROM jikwon CROSS join buser; -- 표준(ANSI)

# CROSS JOIN 중 SELF JION
SELECT a.jikwonname, b.jikwonname FROM jikwon a, jikwon b;

# 비표준사용 표준은 ANSI표시 함.
-- EQUI JION : 조인 조건식에  '='을 사용. 두 테이블은 '같다' 조건으로 JION
-- 대부분의 pk-fk 조인은 EQUI JOIN 이다.(inner join)

SELECT jikwonname, busername FROM jikwon, buser 
WHERE jikwon.busernum = buser.buserno ;

-- non EQUI JION : 조인 조건식에 '=' 이외의 관계연산자를 사용
# 사전 설정
CREATE TABLE paygrade(grade INT PRIMARY KEY, lpay INT, hpay INT);
INSERT INTO paygrade VALUES(1, 0, 1999);
INSERT INTO paygrade VALUES(2, 2000, 2999);
INSERT INTO paygrade VALUES(3, 3000, 3999);
INSERT INTO paygrade VALUES(4, 4000, 4999);
INSERT INTO paygrade VALUES(5, 5000, 9999);
SELECT * FROM paygrade;
# non EQUI JION 실행.
SELECT jiktab.jikwonname, jiktab.jikwonpay,paytab.grade
FROM jikwon AS jiktab, paygrade AS paytab
WHERE jiktab.jikwonpay >= paytab.lpay 
AND jiktab.jikwonpay <= paytab.hpay;

-- INNER JOIN :  두 테이블을 조인 할 때 , 
--  두 테이블에 모두 지정한 열의 데이터가 있는 경우만 추출
-- 다 EQUI JION

-- 중복되는 칼럼 이름이 없으면 안써도 됨. 오라클용
SELECT jikwonno, jikwonname, busername FROM jikwon, buser
WHERE busernum=buserno; 
# ==
SELECT jtab.jikwonno, jtab.jikwonname, btab.busername 
FROM jikwon AS jtab, buser AS btab
WHERE jtab.busernum=btab.buserno;

# WHERE 조건에  JOIN조건 + record 제한조건 주기 : 가독성이 떨어짐.(oracle)
SELECT jikwonno, jikwonname, busername FROM jikwon, buser
WHERE busernum=buserno AND jikwongen='남'; 

# ANSI(MariaDB, MySQL)
SELECT jikwonno, jikwonname, busername
FROM jikwon INNER JOIN buser # 먼저쓴게 left, 뒤가 right
ON busernum=buserno;

SELECT jikwonno, jikwonname, busername 
FROM jikwon INNER JOIN buser
ON busernum=buserno
WHERE jikwongen = '남';

SELECT jikwonno AS 직원번호, jikwonname AS 직원명, busername AS 부서명
FROM jikwon INNER JOIN buser 
ON busernum=buserno
WHERE jikwongen = '남' AND jikwonname LIKE '김%';


SELECT SUM(jikwonpay) AS hap, COUNT(*) AS COUNT
FROM jikwon INNER JOIN buser ON busernum = buserno 
WHERE jikwongen = '남';

-- OUTER JOIN :
-- 두 테이블을 조인 할 때 1개의 테이블에만 자료가 있어도 결과 추출
# Oracle용-------------------------- MariaDBX
# LEFT OUTER JOIN
SELECT jikwonno, jikwonname, busername 
FROM jikwon, buser
WHERE busername = buserno(+); # 대응 안된 부서에 null을 허용 할 거다.

# RIGHT OUTER JOIN
SELECT jikwonno, jikwonname, busername 
FROM jikwon, buser
WHERE busername(+) = buserno; 

# FULL OUTER JOIN : MariaDB는 지원X

# MariaDB 용---------------------------
# LEFT OUTER JOIN
SELECT jikwonno, jikwonname, busername 
FROM jikwon LEFT OUTER JOIN buser
ON busernum=buserno;

# RIGHT OUTER JOIN
SELECT jikwonno, jikwonname, busername 
FROM jikwon RIGHT OUTER JOIN buser
ON busernum=buserno;

# FULL OUTER JOIN(union을 이용)
SELECT jikwonno, jikwonname, busername 
FROM jikwon LEFT OUTER join buser 
ON busernum = buserno
UNION
SELECT jikwonno, jikwonname, busername 
FROM jikwon RIGHT OUTER join buser 
ON busernum = buserno;

-- 세 개의 테이블 조인 :
-- 두개를 먼저 조인후 그 결과와 나머지 테이블로 조인...
-- 칼럼명은 중복안되게 하는게 좋다.
# inner join
SELECT jikwonname, busername, gogekname
FROM jikwon, buser, gogek
WHERE busernum=buserno AND jikwonno=gogekdamsano;
# == : 부서와 고객은 다이렉트로 연결 X ,공통 내용이 X
SELECT jikwonname, busername, gogekname
FROM jikwon INNER join buser on busernum=buserno
inner join gogek ON jikwonno=gogekdamsano;


-- union : 
-- 구조가 일치하는 두개 이상의 테이블 자료 합쳐 출력, 
-- 원래의 테이블 계속 유지
-- 클라이언트 컴퓨터로 읽어올때만 합쳐서 보는것.
# 사전 설정
CREATE TABLE pum1(bun INT, pummok VARCHAR(20));
INSERT INTO pum1 VALUES(1,'귤');
INSERT INTO pum1 VALUES(2,'한라봉');
INSERT INTO pum1 VALUES(3,'바나나');
SELECT * FROM pum1;
CREATE TABLE pum2(num INT, sangpum VARCHAR(20));
INSERT INTO pum2 VALUES(10,'토마토');
INSERT INTO pum2 VALUES(20,'딸기');
INSERT INTO pum2 VALUES(30,'참외');
INSERT INTO pum2 VALUES(40,'수박');
SELECT * FROM pum2;

#union
SELECT bun AS 번호, pummok AS 품명 FROM pum1
UNION
SELECT num , sangpum FROM pum2;

# merge는 MariaDB에서 지원 X
