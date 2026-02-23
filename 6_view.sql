/*
VIEW 파일
물리적인 테이블을 근거로 select문(조건문 포함)을 파일로 저장하여, 가상의 테이블(테이블이 아니야)로 사용
물리적인 테이블이 아니므로 메모리 소모가 거의 없다.
복잡하고 긴 쿼리문을 단순화 가능, 보안강화, 자료의 독립성 확보
실무에서 view파일을 많이 사용함.
클라이언트 컴퓨터에만 존재함.
형식
	create [or replace] view 뷰파일명 as select문
	alter view 뷰 파일명
	drop view 뷰 파일명
*/
SELECT jikwonno, jikwonname, jikwonpay FROM jikwon 
WHERE jikwonibsail < '2010-12-31';
-- CREATE OR REPLACE 덮어쓰기 가능
CREATE OR REPLACE VIEW v_a AS 
SELECT jikwonno, jikwonname, jikwonpay FROM jikwon 
WHERE jikwonibsail < '2010-12-31';
-- CREATE  덮어쓰기 불가능
CREATE VIEW v_a AS 
SELECT jikwonno, jikwonname, jikwonpay FROM jikwon 
WHERE jikwonibsail < '2010-12-31';

SHOW TABLES;
SELECT * FROM v_a;
-- view file 목록 확인
SHOW FULL TABLES IN test WHERE table_type LIKE 'VIEW';
SELECT SUM(jikwonpay) AS 연봉합 FROM v_a;

CREATE VIEW v_b AS SELECT * FROM jikwon
WHERE jikwonname LIKE '김%'  OR jikwonname LIKE '이%' OR jikwonname LIKE '박%';
SELECT * FROM v_b;
SELECT jikwonno, jikwonname, jikwonpay FROM v_b WHERE jikwonjik='사원';

# 원본 테이블 이름 변경해보기 = 물리적인 테이블 이름 바꿔보기
ALTER TABLE jikwon RENAME kbs;
SELECT * FROM v_b; -- err :참조한 테이블의 이름이 변경되어서.
ALTER TABLE kbs RENAME jikwon;
SELECT * FROM v_b;

CREATE VIEW v_c AS SELECT * FROM jikwon ORDER BY jikwonpay DESC;
SELECT * FROM v_c;
CREATE VIEW v_d AS SELECT jikwonno, jikwonname, jikwonpay * 10000 AS ypay FROM jikwon;
SELECT * FROM v_d;

-- view로 view만들기
CREATE VIEW v_e AS SELECT jikwonname, ypay FROM v_d WHERE ypay >= 50000000;
SELECT * FROM v_e;

# view파일 수정, 삭제 하기 : 뭐가 되고 뭐가 안되는지를 잘 확인해야함.
-- view 파일 update하기 -> 원본 파일의 내용도 갱신됨.
UPDATE v_e SET jikwonname='김치국' WHERE jikwonname='김부만';
SELECT * FROM v_e;
SELECT * FROM v_d;
SELECT * FROM jikwon;
-- 원본테이블에 없는 칼럼 수정하기 - err. 
-- 계산에 의해 만들어진 칼럼 수정불가
UPDATE v_d SET ypay=1111 WHERE jikwonname='홍길동';

-- view 파일 delete하기  -> 원본 파일의 내용도 갱신됨.
DELETE FROM v_d WHERE jikwonname='최미숙';
SELECT * FROM v_d;
SELECT * FROM jikwon;
--원본 테이블에 없지만 계산에 의해 추가된 열도 조건 참여 가능.
DELETE FROM v_d WHERE ypay=41000000;
SELECT * FROM v_d;
SELECT * FROM jikwon;

-- VIEW파일 insert하기 -> 원본 파일의 내용도 갱신
-- view의 insert는 원본 테이블의 not null값에 값을 안주면 err!
CREATE OR REPLACE VIEW v_e AS SELECT jikwonno, jikwonname, busernum, jikwonpay FROM jikwon;
INSERT INTO v_e VALUES(31, '김밥', 20, 5000);
SELECT * FROM v_e;
SELECT * FROM jikwon;
DESC jikwon;

CREATE OR REPLACE VIEW v_f AS SELECT jikwonno, jikwonname, busernum, jikwonpay, jikwonibsail 
FROM jikwon WHERE jikwonibsail < '2015-1-1';
SELECT * FROM v_f;
INSERT INTO v_f VALUES(32,'공기밥',10,6000,'2014-5-6');
SELECT * FROM v_f;
SELECT * FROM jikwon;

-- 주의! 
-- view파일의 조건에 안맞는 insert는 보이지 않음. 보이지 않지만 추가가 된 것. 원본 테이블에선 보임. 
INSERT INTO v_f VALUES(33,'주먹밥',10,7000,'2025-5-7');
SELECT * FROM v_f;
SELECT * FROM jikwon;


# group by 에 의한 view
-- group by 에 의한 view는 참조만 가능(insert, update, delect 불가능)
CREATE VIEW v_group AS SELECT jikwonjik, SUM(jikwonpay) AS hap, AVG(jikwonpay) AS ave
FROM jikwon GROUP BY jikwonjik;
SELECT * FROM v_group;


# view 파일 join 출력하기
CREATE OR REPLACE VIEW v_join AS 
SELECT jikwonno, jikwonname, busername, jikwonjik 
FROM jikwon INNER JOIN buser ON jikwon.busernum=buser.buserno
WHERE jikwon.busernum IN (10, 20);
SELECT * FROM  v_join;

UPDATE v_join SET jikwonname='손오공' WHERE jikwonname='박명화';
SELECT * FROM  v_join;
SELECT * FROM jikwon;
-- err: buser 테이블에 있는 busername은 바꿀 수 없다. 한테이블만 수정 가능
-- join에 의한 view는 한 개의 테이블만 수정에 참여해야함. 
UPDATE v_join SET jikwonname='사오정', busername='영업부' WHERE jikwonname='손오공';
-- err : 조인에 의한 삭제 불가(ANSI) , oracle은 가능
DELETE FROM v_join WHERE jikwonname='손오공';