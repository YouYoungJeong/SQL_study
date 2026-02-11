/*
실행하고 싶은 행 드래그 해서 ctrl+f9
위에서부터 하나하나 실행 하고 마지막 drop 까지 하면 깨끗!
*/

-- 테이블 생성(CREATE)
# CREATE TABLE 테이블명

CREATE TABLE dept(NO INT PRIMARY KEY, NAME VARCHAR(10),
tel VARCHAR(15), inwon INT, addr TEXT) CHARSET=UTF8; 
DESC dept;

-- 자료 추가(INSERT)
# insert into 테이블명(칼럼명,...) values(입력자료 칼럼순으로 ,...)
/*
 자료를 추가 할 때 칼럼명과 밸류값의 위치만 같으면 됨(1:1 맵핑)
 칼럼명은 전체를 순차적으로 주는 경우에 생략 가능
 
 python에서 받아올때 SQL문을 문자열("")로 받아 오기 때문에
 숫자는 그냥 쓰거나 작은따옴표('')로 사용 하는것이 규칙
 문자는 작은따옴표('') 사용해야함.
 
 
 PRIMARY KEY(유일키) : 중복을 허용하지 않는다.
 							  테이블에 PK는 꼭 줘야함.
*/
INSERT INTO dept(NO,NAME,tel,inwon,addr) VALUES(1,'인사과','111-1111','3','삼성동12');
INSERT INTO dept VALUES(2,'영업과','111-2222','5','서초동12');
INSERT INTO dept(NO,NAME) VALUES(3,'자재과');
INSERT INTO dept(NO,addr,tel,NAME) VALUES(4,'역삼2동33','111-5555','자재2과');


/* Err 가 Python인지 SQL인지 구분 할 줄 알아야 함! */
INSERT INTO dept(NO, NAME) VALUES(2,'자재과'); -- ERR : PK가 중복
INSERT INTO dept(NAME, tel) VALUES('판매2과', '1111-6666'); -- ERR : No:PK생략 불가
INSERT INTO dept VALUES(5,'판매과'); # ERR : 입력 자료와 칼럼갯수 불일치
INSERT INTO dept(NO,name) VALUES(5, '판매과부서는 사람들이 좋아하는 일하기 좋은 우수한 부서임');
-- Err : 자리수 넘침 (생성한 조건(name=varchar(10)) 보다 너무 데이터가 길어 ) 


-- 자료 수정(UPDATE)
# update 테이블명 set 수정칼럼명=수정값,... where 조건 <= 수정 대상 칼럼을 지정
# where조건이 중요!
# 자료 수정 주의할 점 : PK 칼럼(column)의 자료는 수정 대상에서 제외
UPDATE dept SET tel='123-4567' WHERE NO=2;
UPDATE dept SET addr='압구정동 33', inwon=7, tel='777-8888' WHERE NO=3;


-- 자료 삭제 (DELETE, TRUNCATE)
# delete from 테이블명 where 조건 <- 전체 또는 부분적 레코드 삭제 가능
# truncate table 테이블명 <- where 조건을 사용 하지 X, 전체 레코드 삭제 가능
/* 
	DELETE문에 where 조건을 안 쓰면 전체 다 삭제하므로 백업이 중요!
	DELETE FROM dept <-- where조건이 없어서 레코드  모두 지움 
	TRUNCATE <- 많은 양의  레코드를 한번에 다 지움, DELETE보다 속도가 빠름, 잘 사용 X
*/
DELETE FROM dept WHERE NAME='자재2과';
TRUNCATE * TABLE dept;


-- 자료 확인 하기
SELECT * from dept;
SELECT * from dept WHERE NO=1;

-- 테이블 삭제(DROP)
# 테이블 자체(구조, 자료)가 제거됨
DROP TABLE dept;

-- --------------
-- [무결정 제약 조건]
-- 테이블 생성시 잘못된 자료 입력을 막고자 다양한 입력 제한 조건을 줄 수 있다.
-- mariaDB는 조건 없으면 NULL을 허용
-- 1) 기본키 제약 조건 : Primary key(pk) 사용, 중복 레코드 입력 방지
CREATE table aa(bun INT PRIMARY KEY, irum CHAR(10)); -- bun : NOT NULL, UNIQUE
# 정보 확인용 암기 X
SELECT * FROM information_schema.table_constraints WHERE TABLE_NAME='aa'

# name은 중복 가능
INSERT INTO aa VALUES(1, 'Tom');
INSERT INTO aa VALUES(2, 'Tom');

#ERR : Duplicate entry '2' for key 'PRIMARY
INSERT INTO aa VALUES(2, 'Tom');
#ERR : Field 'bun' doesn't have a default valueuery - bun은 NOT NULL이다!
INSERT INTO aa(irum) VALUES('Tom');

INSERT INTO aa(bun) VALUES('3'); -- NULL을 허용함
SELECT * FROM aa;
DROP TABLE aa;

-- CONSTRAINT 조건 주기: 칼럼명 쭉쓰고 제약조건을 뒤에 써 줄 떄 사용
# CONSTRAINT pk이름 지정(명시적) PRIMARY KEY(bun);
# CONSTRAINT 을 안쓰면 알아서 pk이름을 만들어줌
CREATE table aa(bun INT, irum CHAR(10), CONSTRAINT aa_bun_pk PRIMARY KEY(bun));
INSERT INTO aa VALUES(2, 'Tom');
SELECT * FROM aa;
DROP TABLE aa;

/* 
	제약조건을 만드는 이유 : master data를 DB에 등록하기 위함
	web에서 입력을 받아 
	javaScript로 입력자료 오류검사1차 하고
	python에서 입력자료 오류검사를 2차 하고 
	check를 넣어 마지막 검사하고 insert.
	-> 프로는 무조건 해야함.
*/
-- 2) check 제약 : 입력 자료의 특정 칼럼값 조건 검사
CREATE TABLE aa(bun INT, nai INT CHECK(nai >= 20));
INSERT INTO aa VALUES(1, 23);
# ERR: 조건값에서 벗어남.
INSERT INTO aa VALUES(2, 13);
SELECT * FROM aa;
DROP TABLE aa;


-- 3) unique 제약: 특정 칼럼값 중복 불허
# NOT NULL :  Null을 허용 하지 X
CREATE TABLE aa(bun INT, irum CHAR(10) NOT NULL UNIQUE);
INSERT INTO aa VALUES(1, 'tom');
INSERT INTO aa VALUES(2, 'john');
#ERR : 중복 불가!
INSERT INTO aa VALUES(3, 'john');
SELECT * FROM aa;
DROP TABLE aa;

-- 4) FOREIGN KEY(fk), 외부키, 참조키 제약:특정 칼럼이 다른 테이블의 칼럼을 참조
/* 	☆fk 대상은 pk다
		: fk는 유니크 해야 하기 때문에 참조 대상이 pk임!
 		칼럼명은 달라도 되지만 타입은 같아야함
*/
CREATE TABLE jikwon(bun INT PRIMARY KEY , irum VARCHAR(10) NOT NULL,
 buser char(10) NOT NULL);
INSERT INTO jikwon VALUES(1,'한송이', '인사과');
INSERT INTO jikwon VALUES(2,'이기자', '인사과');
INSERT INTO jikwon VALUES(3,'한송이', '판매과');
SELECT * FROM jikwon;

CREATE TABLE gajok(CODE INT PRIMARY KEY, NAME VARCHAR(10) NOT NULL, 
birth DATETIME, jikwonbun INT ,FOREIGN KEY(jikwonbun) REFERENCES jikwon(bun));

INSERT INTO gajok VALUES(10,'한가해', '2015-05-12' , 3);
INSERT INTO gajok VALUES(20,'공기밥', '2011-12-12' , 2);
INSERT INTO gajok VALUES(30,'심심해', '2010-05-12' , 3);
#ERR: 참조할 대상이 없어서 에러
INSERT INTO gajok VALUES(30,'공기밥', '2013-12-12' , 5);
SELECT * FROM gajok;

-- fk가 참조하고 있는 delete하기
DELETE FROM jikwon WHERE bun=1;

# ERR : 참조 하고 있는 자료(가족)가 있으므로 삭제 불가
DELETE FROM jikwon WHERE bun=2;

# 참조키 삭제 후 삭제
DELETE FROM gajok WHERE jikwonbun=2; -- 참조키 (pk가 2번) 가족자료 삭제
DELETE FROM jikwon WHERE bun=2; -- 참조 가족이 없으므로 2번 직원 삭제 가능
SELECT * FROM jikwon;
-- 참고
# CREATE TABLE gajok(CODE INT PRIMARY KEY ,...) ON DELETE CASCADE 
# 직원자료를 삭제하면 관련있는 가족 자료도 함께 삭제 가능
# 위험한 작업, 실무에서 사용 X

# FK가 있는 테이블 먼저 drop
DROP TABLE gajok;
DROP TABLE jikwon;

-- --------------------------------------------------
-- default : 특정칼럼에 초기치 부여. null 예방
/*
	PRIMARY KEY AUTO_INCREMENT = AUTO_INCREMENT PRIMARY KEY 
	pk 번호(bun) 자동증가, 오라클엔 없음.
	필요한 사람들이 다 다른 DB프로그램 사용시 넣지말고 python에서 달아
	게시판, 방명록 만들때 사용.
*/
CREATE TABLE aa(bun INT PRIMARY KEY AUTO_INCREMENT, 
juso CHAR(20) DEFAULT '강남구 역삼동');
INSERT INTO aa VALUES(1,'서초구 서초2동');
INSERT INTO aa(juso) VALUES('서초구 서초3동');
INSERT INTO aa(juso) VALUES('서초구 서초4동');
INSERT INTO aa(bun) VALUES(5);
INSERT INTO aa(bun) VALUES(6);
SELECT * FROM aa

DROP TABLE aa;


-- -------------------------------------------------------
# DB_RDEMS(66번) 문제 TEST
CREATE TABLE pro(procode INT PRIMARY KEY, proname VARCHAR(10), 
labnumber int CHECK(100<= labnumber <=500)); 
SELECT * FROM pro;

CREATE TABLE subname(subcode INT AUTO_INCREMENT PRIMARY KEY, 
subname VARCHAR(20) UNIQUE, bookname VARCHAR(20), 
mainpro INT ,FOREIGN KEY(mainpro) REFERENCES pro(procode));
SELECT * FROM subname; 


CREATE TABLE student(studnum INT PRIMARY KEY, studname VARCHAR(10), 
studsubject INT ,FOREIGN KEY(studsubject) REFERENCES subname(subcode),
gradenum INT DEFAULT(1) CHECK(1<= gradenum <= 4) );
SELECT * FROM student;

DROP TABLE student;
DROP TABLE subname;
DROP TABLE pro;