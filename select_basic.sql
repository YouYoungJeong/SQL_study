-- 실습용 datatable 생성------------------------------------------------- 
# 데이터 연결의 시작은 sangdata로 할것.
create table sangdata(code int primary KEY,
sang varchar(20),
su INT,
dan int);
insert into sangdata values(1,'장갑',3,10000);
insert into sangdata values(2,'벙어리장갑',2,12000);
insert into sangdata values(3,'가죽장갑',10,50000);
insert into sangdata values(4,'가죽점퍼',5,650000);
SELECT * FROM sangdata;
DESC sangdata;

create table buser(
buserno int primary key, 
busername varchar(10) not null,
buserloc varchar(10),
busertel varchar(15));

insert into buser values(10,'총무부','서울','02-100-1111');
insert into buser values(20,'영업부','서울','02-100-2222');
insert into buser values(30,'전산부','서울','02-100-3333');
insert into buser values(40,'관리부','인천','032-200-4444');
SELECT * FROM buser;
DESC buser;

/* 
busernum int not null : FK  = buser테이블 buserno
공통 칼럼을 만들어주면 꼭 FK를 주지 않아도 됨. case로 부서명 출력 가능
FK를 다 넣어주면 너무 제약적
CONSTRAINT : 제약조건은 다 뒤로 뺄 수 있으나 not null, default는 잘 안씀
*/
create table jikwon(
jikwonno int primary key,
jikwonname varchar(10) not NULL, 
busernum int not null,
jikwonjik varchar(10) default '사원', 
jikwonpay int,
jikwonibsail date,
jikwongen varchar(4),
jikwonrating char(3),
CONSTRAINT ck_jikwongen check(jikwongen='남' or jikwongen='여'));

insert into jikwon values(1,'홍길동',10,'이사',9900,'2008-09-01','남','a');
insert into jikwon values(2,'한송이',20,'부장',8800,'2010-01-03','여','b');
insert into jikwon values(3,'이순신',20,'과장',7900,'2010-03-03','남','b');
insert into jikwon values(4,'이미라',30,'대리',4500,'2014-01-04','여','b');
insert into jikwon values(5,'이순라',20,'사원',3000,'2017-08-05','여','b');
insert into jikwon values(6,'김이화',20,'사원',2950,'2019-08-05','여','c');
insert into jikwon values(7,'김부만',40,'부장',8600,'2009-01-05','남','a');
insert into jikwon values(8,'김기만',20,'과장',7800,'2011-01-03','남','a');
insert into jikwon values(9,'채송화',30,'대리',5000,'2013-03-02','여','a');
insert into jikwon values(10,'박치기',10,'사원',3700,'2016-11-02','남','a');
insert into jikwon values(11,'김부해',30,'사원',3900,'2016-03-06','남','a');
insert into jikwon values(12,'박별나',40,'과장',7200,'2011-03-05','여','b');
insert into jikwon values(13,'박명화',10,'대리',4900,'2013-05-11','남','a');
insert into jikwon values(14,'박궁화',40,'사원',3400,'2016-01-15','여','b');
insert into jikwon values(15,'채미리',20,'사원',4000,'2016-11-03','여','a');
insert into jikwon values(16,'이유가',20,'사원',3000,'2016-02-01','여','c');
insert into jikwon values(17,'한국인',10,'부장',8000,'2006-01-13','남','c');
insert into jikwon values(18,'이순기',30,'과장',7800,'2011-11-03','남','a');
insert into jikwon values(19,'이유라',30,'대리',5500,'2014-03-04','여','a');
insert into jikwon values(20,'김유라',20,'사원',2900,'2019-12-05','여','b');
insert into jikwon values(21,'장비',20,'사원',2950,'2019-08-05','남','b');
insert into jikwon values(22,'김기욱',40,'대리',5850,'2013-02-05','남','a');
insert into jikwon values(23,'김기만',30,'과장',6600,'2015-01-09','남','a');
insert into jikwon values(24,'유비',20,'대리',4500,'2014-03-02','남','b');
insert into jikwon values(25,'박혁기',10,'사원',3800,'2016-11-02','남','a');
insert into jikwon values(26,'김나라',10,'사원',3500,'2016-06-06','남','b');
insert into jikwon values(27,'박하나',20,'과장',5900,'2012-06-05','여','c');
insert into jikwon values(28,'박명화',20,'대리',5200,'2013-06-01','여','a');
insert into jikwon values(29,'박가희',10,'사원',4100,'2016-08-05','여','a');
insert into jikwon values(30,'최미숙',30,'사원',4000,'2015-08-03','여','b');

SELECT * FROM jikwon;
DESC jikwon;

/*gogekdamsano : FK
고객 담당하는 직원 번호 jikwon테이블의 jikwonno을 참조하고 있음.
직접 FK를 걸었기 때문에 결속력이 강함.
-> 담당 직원이 없으며 고객이 없다는 뜻.
*/
create table gogek(
gogekno int primary key,
gogekname varchar(10) not null,
gogektel varchar(20),
gogekjumin char(14),
gogekdamsano int,
CONSTRAINT FK_gogekdamsano foreign key(gogekdamsano) references jikwon(jikwonno));

insert into gogek values(1,'이나라','02-535-2580','850612-1156777',5);
insert into gogek values(2,'김혜순','02-375-6946','700101-1054777',3);
insert into gogek values(3,'최부자','02-692-8926','890305-1065777',3);
insert into gogek values(4,'김해자','032-393-6277','770412-2028777',13);
insert into gogek values(5,'차일호','02-294-2946','790509-1062777',2);
insert into gogek values(6,'박상운','032-631-1204','790623-1023777',6);
insert into gogek values(7,'이분','02-546-2372','880323-2558777',2);
insert into gogek values(8,'신영래','031-948-0283','790908-1063777',5);
insert into gogek values(9,'장도리','02-496-1204','870206-2063777',4);
insert into gogek values(10,'강나루','032-341-2867','780301-1070777',12);
insert into gogek values(11,'이영희','02-195-1764','810103-2070777',3);
insert into gogek values(12,'이소리','02-296-1066','810609-2046777',9);
insert into gogek values(13,'배용중','02-691-7692','820920-1052777',1);
insert into gogek values(14,'김현주','031-167-1884','800128-2062777',11);
insert into gogek values(15,'송운하','02-887-9344','830301-2013777',2);

SELECT * FROM gogek;
DESC gogek;
-- ---------------------------------------------------------------
-- select의 형식 : DB 서버로 부터 클라이언트로 자료를 읽는 명령
/*
* : 모든 칼럼 읽기, 칼럼명을 직접 다써주는걸 권장(<-속도가 더 빠름)

칼럼의 순서는 물러올때 얼마든지 바꿀 수 있기 때문에 순서 선택가능
AS : 별명을 줄 수 있다. 
	-> python에서 별명으로 받으면 별명으로 처리해야함.
	-> DB 서버에서 SELECT로 RAM(주기억 장치)으로 받아오기 때문에 
		받으면 별명으로 받아져서 그렇다.
DB서버는 항상 연결 되어 있지 X 불러올때 작동
FROM DUAL : 가상 테이블 형성(DB로 보내지 X)
연산에 의해 칼럼 생성가능-> DB 서버에 없어. RAM에서 생성가능 
	DB에 없는 새로운 결과 값을 만들어 나갈 수 있다.
ORDER BY - 연산에 의해 만들어진 칼럼도 참여 가능
sort(정렬)
	ASC  : 오름차순(생략가능)
	DESC : 내림차순
DISTINCT : 중복 배제, 중복배제는 하나의 칼럼만 쓴다. 선택버튼 만들 때 좋다.
				web으로 넘어가면 선택할 수 있는건 다 선택하는게 좋다.
연산자 순서
	() > 산술연산자(*,/, > +,=) > 관계(비교)연산자 > is null, like, in > between, not > and > or
between : And와 같은 조건에 사용
not between(연산 속도가 떨어짐-비추) : OR와 같은 조건으로 사용
-- 연산 조건을 줄 때 긍정적 형태의 조건이  속도가 빨라짐.

문자열 산술연산자 사용 : ascii 코드로 표현되기 때문에 문자도 대소 비교가 가능

like 조건 연산 : %(0개 이상의 문자열), _(한개 문자)
	이% -> 첫글자:이 %:그 이후 아무글자(갯수 제한X(0~**))
	%라 -> 첫글자:아무글자(갯수 제한X(0~**)), 마지막 글자 : 라
	이__ -> 첫글자 : 이, _:아무거나 한글자, _:아무거나 한글자
	
# NULL값 찾기 is null -> 대상 = NULL로는 찾을 수 없다.
*/
SELECT * FROM jikwon; # 전체 테이블 칼럼 읽기
# 원하는 칼럼만 읽기 (selection), 
SELECT jikwonno,jikwonname FROM jikwon; 
SELECT jikwonno,jikwonname,jikwongen,busernum FROM jikwon;
SELECT jikwonno AS 직원번호,jikwonname AS 직원명  FROM jikwon; #  AS 별명

# 가상 테이블 형성, 수식도 TABLE명이 된다.
SELECT 10, '안녕', 12 / 3 FROM DUAL;
SELECT 10, '안녕', 12 / 3 as 결과 FROM DUAL;

# 연산에 의해 칼럼 생성가능(tax 칼럼 생성하기)
SELECT jikwonno,jikwonpay , jikwonpay * 0.05 as tax FROM jikwon;
# concat 문자열 더하기 함수
SELECT jikwonname, CONCAT(jikwonname,'님') AS jikwonetc FROM jikwon; 

-- 정렬(sort) : 오름차순 ASC 생략가능, 내림차순 DESC 
# order by  : 그룹끼리 모임!
SELECT * from jikwon ORDER BY jikwonpay ASC;
SELECT * from jikwon ORDER BY jikwonpay DESC;
SELECT * from jikwon ORDER BY jikwonjik ASC; # 사전순
# 직급별ASC -> 부서별 DESC-> 성별 ASC -> 직원페이ASC 순으로정렬
SELECT * from jikwon ORDER BY jikwonjik ASC, busernum DESC, jikwongen ASC, jikwonpay; 
SELECT jikwonname, jikwonpay, jikwonpay / 100 AS pay FROM jikwon ORDER BY pay DESC;

# DISTINCT : 중복 배제 - 
SELECT DISTINCT jikwonjik FROM jikwon;
SELECT DISTINCT jikwonjik, jikwonname FROM jikwon; # <- 의미가 없다. 

-- 연산자
# 원하는 레코드만 읽기 (projection) where
SELECT * FROM jikwon WHERE jikwonjik='대리';
SELECT * FROM jikwon WHERE jikwonno=3;
SELECT * FROM jikwon WHERE jikwonibsail='2010-03-03';
SELECT * FROM jikwon WHERE jikwonno=5 OR jikwonno = 7;
SELECT * FROM jikwon WHERE jikwonjik='사원' 
AND jikwongen = '여' AND jikwonpay <= 3000;
SELECT * FROM jikwon WHERE jikwonjik='사원' AND 
(jikwongen = '여' OR jikwonibsail >= '2017-01-01');
SELECT * FROM jikwon WHERE jikwonno >= 5 AND jikwonno <= 10;
# BETWEEN
SELECT * FROM jikwon WHERE jikwonno  BETWEEN 5 AND 10;
SELECT * FROM jikwon WHERE jikwonibsail  BETWEEN '2017-1-1' AND '2019-12-31';
# OR , not between(연산 속도가 떨어짐-비추)
-- 연산 조건을 줄 때 긍정적 형태의 조건이  속도가 빨라짐.
SELECT * FROM jikwon WHERE jikwonno < 5 or jikwonno > 20;-- 5미만 20초과
SELECT * FROM jikwon WHERE jikwonno  not BETWEEN 5 AND 20; -- ''
SELECT * FROM jikwon WHERE jikwonno  BETWEEN 5 AND 20; -- 5에서 20 사이
# 산술 연산자가 관계 연산자보다 먼저 둘이 같다.
SELECT * FROM jikwon WHERE jikwonpay >5000;
SELECT * FROM jikwon WHERE jikwonpay >3000+2000;

# 문자열 산술연산자 사용 : 박 이후의 사람들
SELECT * FROM jikwon WHERE jikwonname >='박';
SELECT ASCII('a'), ASCII('A'), ASCII('가'), ASCII('나') FROM DUAL;
SELECT * FROM jikwon WHERE jikwonname BETWEEN '김' AND '이';

-- in 멤버 조건 연산
SELECT * FROM jikwon WHERE jikwonjik='대리' OR jikwonjik='과장'OR jikwonjik='부장';
SELECT * FROM jikwon WHERE jikwonjik IN ('대리', '과장', '부장');
SELECT * FROM jikwon WHERE jikwonno IN (3, 12, 29);


-- like 조건 연산 : %(0개 이상의 문자열), _(한개 문자)
-- 이% -> 첫글자:이 %:그 이후 아무글자(갯수 제한X(0~**))
-- %라 -> 첫글자:아무글자(갯수 제한X(0~**)), 마지막 글자 : 라
-- 이__ -> 첫글자 : 이, _:아무거나 한글자, _:아무거나 한글자
SELECT * FROM jikwon WHERE jikwonname LIKE '이%';
SELECT * FROM jikwon WHERE jikwonname LIKE '이순%';
SELECT * FROM jikwon WHERE jikwonname LIKE '%라';
SELECT * FROM jikwon WHERE jikwonname LIKE '이%라'; # 서로 다르다(%)
SELECT * FROM jikwon WHERE jikwonname LIKE '이_라'; # 서로 다르다(_: 세글자가 MAX)
SELECT * FROM jikwon WHERE jikwonname LIKE ' 이__';
SELECT * FROM jikwon WHERE jikwonname LIKE '__';
SELECT * FROM jikwon WHERE jikwonpay LIKE '3___';
SELECT * FROM jikwon WHERE jikwonpay LIKE '3%';
SELECT * FROM gogek WHERE gogekjumin LIKE'_______1%';
SELECT * FROM gogek WHERE gogekjumin LIKE'%-1%';

# NULL값 공부하려고 수정
UPDATE jikwon SET jikwonjik=NULL WHERE jikwonno=5;
SELECT * FROM jikwon;
# NULL값 찾기 is null
SELECT * FROM jikwon WHERE jikwonjik='NULL'; -- X
SELECT * FROM jikwon WHERE jikwonjik IS NULL;


# LIMIT 3 : 앞에서부터 3명만 나와
SELECT * FROM jikwon LIMIT 3;
# DESC  LIMIT 3 : 뒤에서 부터 3명만 나와
SELECT * FROM jikwon ORDER BY jikwonno DESC  LIMIT 3;

#LIMIT 5,3 : LIMIT 시작행,갯수 - index로 나와서 0부터 시작
SELECT * FROM jikwon LIMIT 5,3;

# 배운거 정리
SELECT jikwonno AS 직원번호, jikwonname AS 직원명, jikwonjik AS 직급, 
jikwonpay AS 연봉, jikwonpay /12 AS 보너스, jikwonibsail AS 입사일 FROM jikwon
WHERE jikwonjik IN('과장','부장','사원')
AND jikwonpay >= 4000 AND jikwonibsail BETWEEN '2015-1-1' AND '2019-12-31'
ORDER BY jikwonjik, jikwonpay DESC LIMIT 3;

-- ---------------------------------------------------------------------------
-- 내장함수 : 데이터 조작의 효율성 증진이 목적, 함수 필요에 의해 써주면 도움이 많이 됨, 
--					모르는 간 찾아가면서 사용 하면 됨.
--					데이터 베이스 안에서 연산 작업하는것보다 가져와서 
--				 	python으로 연산하는것도 괜찮다. 서버안에서 하면 과부화 위험.
--					사용하는 도구 마다 함수가 없을 수 도 있다.
-- 단일 행 함수 : 각 행에 대해 작업한다. 행 단위 처리
-- 문자 함수(정리하기)
#LOWER(문자열): 소문자, UPPER(문자열): 대문자
SELECT LOWER('Hello'), UPPER('Hello') FROM DUAL;
# 문자열 추출 SUBSTR(문자열,몇번째,몇자(없으면 뒤로 쭉))
SELECT SUBSTR('hello world',3), SUBSTR('hello world',3,3), 
SUBSTR('hello world',-3,3) FROM DUAL;
# LENGTH(문자열): 길이 , INSTR(문자열, 해당문자열) : 몇번째 있는지 확인
SELECT LENGTH('hello world'), INSTR('hello world','e') FROM DUAL;
# REPLACE : 치환('문자열','바꿀대상','바꿀문자')
SELECT REPLACE('010.111.1234','.','-') FROM DUAL;

-- jikwon 테이블에서 이름이 '이'가 포함된 직원이 있으면 '이'부터 두글자 출력하기
SELECT jikwonname, SUBSTR(jikwonname, INSTR(jikwonname,'이'),2) 
FROM jikwon WHERE jikwonname LIKE '%이%';

-- 숫자 함수(정리하기)
# ROUND(실수, 반올림 자리수) 
SELECT ROUND(45.678, 2), ROUND(45.678), ROUND(45.678, 0),
ROUND(45.678,-1) FROM DUAL;
SELECT jikwonname, jikwonpay, jikwonpay*0.25 AS tax, 
ROUND(jikwonpay*0.25, 0) FROM jikwon;
# TRUNCATE(실수,자르는 자리수)
SELECT TRUNCATE(45.678,0),TRUNCATE(45.678,1),TRUNCATE(45.678,-1) FROM DUAL;
#MOD(숫자, 나눌수): 나머지 
SELECT MOD(15, 2), 15/2 FROM DUAL;
# GREATEST : 가장 큰수, LEAST : 가장 작은수
SELECT GREATEST (23, 25, 5, 1, 12), LEAST(23, 25, 5, 1, 12) FROM DUAL;


-- 날짜 함수(정리하기)
# now() 연산에 참여함.SYSDATE랑 약간 달라 timestep를 반환하는 값
SELECT NOW(), NOW()+2, SYSDATE(),CURDATE() FROM DUAL;
# now()는 하나의 query 안에서 동일값을 유지함
SELECT NOW(), SLEEP(3), NOW();
# SYSDATE()는 실행 시점 값 출력, 호출 했을 때의 당시
SELECT SYSDATE(), NOW(), SLEEP(3), NOW(), SYSDATE();
# ADDDATE(날짜,연산숫자) : 날짜 더하고 빼기, SUBDATE(날짜,뺄날자)
SELECT ADDDATE('2020-08-01',3), ADDDATE('2020-08-01',-3), SUBDATE('2020-08-01',3);
# DATE_ADD(날짜,INTERVAL 연산 숫자  시간)
SELECT DATE_ADD(NOW(),INTERVAL 1 MINUTE), DATE_ADD(NOW(),INTERVAL 5 DAY),
DATE_ADD(NOW(),INTERVAL 5 MONTH) FROM DUAL;
#DATEDIFF(날짜, 날짜): 날짜 차이
SELECT DATEDIFF(NOW(),'2025-05-05');


-- 형변환 함수
#DATE_FORMAT(NOW(), '%Y%m%d') : 서식변경 , 모양바뀜-> '%Y%m%d'형태 많음.
SELECT NOW(), DATE_FORMAT(NOW(), '%Y%m%d'), DATE_FORMAT(NOW(), '%Y년%m월%d일'); 
# 직원 입사 요일 확인
SELECT jikwonname, jikwonibsail,DATE_FORMAT(jikwonibsail, '%W') 
FROM jikwon WHERE busernum=10;
# 문자열을 날짜로
SELECT STR_TO_DATE('2026-02-12','%Y-%m-%d');
SELECT STR_TO_DATE('2026-02-12 13-1-16','%Y-%m-%d %H-%i-%S');
SELECT STR_TO_DATE('2026-02-12 13:1:16','%Y-%m-%d %H:%i:%S');

-- 기타 함수
-- RANK() : 순위 결정 
-- DENSE_RANK() : 동점자 처리가 다름.
# ace
SELECT jikwonno, jikwonname, jikwonpay,RANK() OVER(ORDER BY jikwonpay) AS RO, 
DENSE_RANK() OVER(ORDER BY jikwonpay) AS DRO FROM jikwon;
#desc
SELECT jikwonno, jikwonname, jikwonpay,RANK() OVER(ORDER BY jikwonpay desc) AS RO, 
DENSE_RANK() OVER(ORDER BY jikwonpay desc) AS DRO FROM jikwon;

-- nvl(value1, value2) :
# value1이 null이 아니면 value1 ,value1이 null이면 value2를 취함.
SELECT jikwonname, jikwonjik , nvl(jikwonjik, '임시직') FROM jikwon;
-- nvl2(value1, value2, value3) 
# :# value1이 null이 아니면 value2 , null이면 value3를 취함.
SELECT jikwonname, jikwonjik , nvl2(jikwonjik,'정규직','임시직') FROM jikwon;

-- NULLIF(VALUE1, VALUE2) : 두개의 값이 일치하면 null, 아니면 value1 취함
SELECT jikwonname, jikwonjik, NULLIF(jikwonjik,'대리') FROM jikwon;

-- 조건표현식
# 형식1)
-- case 표현식 when 비교값1 then 결과값1 
-- when 비교값2 then 결과값2 ..[else 결과값 n] end as 별명 
-- 칼럼의 끝이 end, else 생략 가능
SELECT case 10/5 
when 5 then '안녕' 
when 2 then '반가워' 
ELSE '잘가' END AS 결과 FROM DUAL;

SELECT jikwonname, jikwonpay, jikwonjik,
case jikwonjik 
when '이사' then jikwonpay * 0.05
when '부장' then jikwonpay * 0.04
when '과장' then jikwonpay * 0.03
ElSE jikwonpay * 0.02  end donation from jikwon;

# 형식2)
-- case when 조건1 then 결과값1 
-- when 조건2 then 결과값2 ..[else 결과값 n] end as 별명 
SELECT jikwonname, 
case 
when jikwongen='남' then '남성' 
when jikwongen = '여' then '여성' END AS gender FROM jikwon;

SELECT jikwonname,jikwonpay,
case
when jikwonpay >= 7000 then '우수 연봉'
when jikwonpay >= 5000 then '보통 연봉'
ELSE '저조' END AS result , jikwongen 
FROM jikwon WHERE jikwonjik IN('대리', '과장');

-- if(조건) 참값, 거짓 값 as 별명
# TRUNCATE로 조건 구하기
SELECT jikwonname, jikwonpay,
TRUNCATE(jikwonpay/1000, 0) >=5 FROM jikwon;

SELECT jikwonname, jikwonpay, jikwonjik, 
if(TRUNCATE(jikwonpay/1000, 0) >=5, 'good', 'normal') AS result
FROM jikwon;

SELECT TIMESTAMPDIFF(unit,datetime_expr1,datetime_expr2)


-- 집계함수(복수행 함수) : 
-- 전체 자료를 그룹별로 구문해 통계 결과룰 얻기 위한 함수
/* null값 취급 방법: null은 작업에서 제외함!! 
	- avg, count 들이 문제, 
	- 합은 상관 없어
*/
# 집계 함수 - sum() : 합
# NULL값 주기
DESC jikwon;
UPDATE jikwon SET jikwonpay=NULL WHERE jikwonno=5;
SELECT * FROM jikwon;

SELECT sum(jikwonpay) as hap , avg(jikwonpay) as 평균 FROM jikwon;
SELECT max(jikwonpay) AS 최대값, min(jikwonpay) AS 최소값 FROM jikwon;
SELECT AVG(jikwonpay), AVG(nvl(jikwonpay,0)) FROM jikwon;
SELECT SUM(jikwonpay)/29, SUM(jikwonpay)/30 FROM jikwon;
SELECT SUM(jikwonpay), AVG(jikwonpay) FROM jikwon;
# count(*) : 가장 일반적
SELECT COUNT(jikwonno), COUNT(jikwonpay) FROM jikwon;
SELECT COUNT(*) AS 인원수 FROM jikwon;
# 표준편차, 분산
SELECT STDDEV(jikwonpay), VAR_SAMP(jikwonpay) FROM jikwon;
SELECT COUNT(*) AS 인원수,VAR_SAMP(jikwonpay) FROM jikwon WHERE busernum=10;
SELECT COUNT(*) AS 인원수,VAR_SAMP(jikwonpay) FROM jikwon WHERE busernum=20; 

-- 직원 테이블에서 과장은 몇명인가
SELECT COUNT(*) AS 인원수 FROM jikwon WHERE jikwonjik='과장';
 -- 2010 년 이전에 입사한 남직원은 몇명인가
SELECT COUNT(*) AS 남직원 FROM jikwon WHERE jikwonibsail<'2010-1-1' AND jikwongen='남';
--2015년 이후 입사한 여직원의 연봉합, 연봉평균, 인원수는?
SELECT SUM(jikwonpay) as 연봉합, AVG(jikwonpay) AS 연봉평균,COUNT(*) AS 인원수 
FROM jikwon WHERE jikwonibsail > '2015-1-1' AND jikwongen='여';


-- ☆group : 소계를 구하는 함수
/*group by절: 그룸 칼럼에 대해 order by 할 수 없다. 이미 order by 진행중이기 떄문
					단, 출력 결과는 order by(정렬) 가능
	select 그룹칼럼명, 계산함수, ## 그룹칼럼명을 안 넣어주면 구분 불가
	from 테이블명
	where 조건 
	group by 그룹칼럼명..
	having 조건
DB서버는 한번에 방문해서 작업 하는게 좋음.
클라이언트에서 작업 할 수 있으면 좋다
*/
-- 성별, 연봉평균, 인원수 출력(GROUP BY)
SELECT jikwongen, AVG(jikwonpay) AS 연봉평균, COUNT(*)  AS 직원수
FROM jikwon GROUP BY jikwongen; 
-- 부서별 연봉합
SELECT busernum, SUM(jikwonpay) AS 연봉합 FROM jikwon
GROUP BY busernum;

-- 부서별 연봉합: 연봉합이 35000이상(HAVING 사용)
SELECT busernum, SUM(jikwonpay) AS 연봉합 FROM jikwon
GROUP BY busernum HAVING SUM(jikwonpay) >= 35000;
-- 부서별 연봉합: 여성만 -> 골라내는거 먼저하기
SELECT busernum, SUM(jikwonpay) AS 연봉합 FROM jikwon 
HERE jikwongen='여'GROUP BY busernum ;
-- 부서별 연봉합: 연봉합이 15000인 여성만 (별명으로 조건 참여)
SELECT busernum, SUM(jikwonpay) AS paytotal FROM jikwon 
WHERE jikwongen='여'GROUP BY busernum HAVING paytotal >= 15000;

-- 주의 :group by 전에 order by X,
# SELECT busernum, SUM(jikwonpay) FROM jikwon order by busernum GROUP BY busernum; 
SELECT busernum, SUM(jikwonpay) FROM jikwon  
GROUP BY busernum ORDER BY SUM(jikwonpay) DESC; 