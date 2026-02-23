-- ☆subquery : 
-- query 내에 query 가 있는 형태 
-- (주로 안쪽 질의 결과를 바깥쪽 직의에서 참조)
-- 다른 테이블의 결과를 조건으로 쓰고 싶을 때 
-- 계산된 값을 이용하고 싶을때
-- 복잡한 조건을 단계적으로 나눠 처리고 싶을 때...

# where 안에 있는 subquery
-- 이미라 직원과 직급이 같은 직원 출력
# db에 두번 다녀옴
SELECT jikwonjik FROM jikwon WHERE jikwonname='이미라'; -- 대리
SELECT * FROM jikwon WHERE jikwonjik='대리';
# 한번에 실행 - 질의 속에 질의가 들어있는 형태
SELECT * FROM jikwon; 
WHERE jikwonjik=(SELECT jikwonjik FROM jikwon WHERE jikwonname='이미라');
/* WHERE jikwonjik=(SELECT jikwonjik FROM jikwon WHERE jikwonname='이미라')
	값은 WHERE jikwonjik='대리' 랑 같은 조건이 됨. */
	
-- 직급이 대리 중에서 가장 먼저 입사한	직원은?
# 잘못된 실행
SELECT * FROM jikwon 
WHERE jikwonibsail=
(SELECT MIN(jikwonibsail) FROM jikwon WHERE jikwonjik='대리');-- 2013-02-05
/*
SELECT * FROM jikwon WHERE jikwonibsail='2013-02-05' 만 받아오기때문에 
	입사년월일을 받아온거임. 
*/
# 조건을 꼭 확인!
SELECT * FROM jikwon 
WHERE jikwonjik = '대리' AND jikwonibsail =
(SELECT MIN(jikwonibsail) FROM jikwon WHERE jikwonjik='대리');	

# 다른 테이블에서 가져오기
--  인천에 근무하는 직원 출력
SELECT * FROM buser;
SELECT * FROM jikwon 
WHERE busernum = (SELECT buserno FROM buser WHERE buserloc ='인천');

# 넘어오는 값이 복수 일때, 값의 부정(not, <>)
--  인천이외에 근무하는 직원 출력(or의 연속사용은 in!)	
SELECT * FROM jikwon 
WHERE busernum IN (SELECT buserno FROM buser WHERE NOT buserloc ='인천');	
# ==	
SELECT * FROM jikwon 
WHERE busernum <> (SELECT buserno FROM buser WHERE buserloc ='인천');


-- 고객 중 차일호 와 나이가 같은 자료 출력
SELECT * FROM gogek
WHERE SUBSTR(gogekjumin,1,2)=
(SELECT SUBSTR(gogekjumin,1,2) FROM gogek WHERE gogekname='차일호')


-- 쿼리분은 동일한 결과를 여러 방법으로 수행 가능[그때그때 상황에 따라 사용]
-- 총무부에 근무하는 직원들이 관리하는 고객 출력
-- subqurey 사용
SELECT gogekno, gogekname, gogektel FROM gogek
WHERE gogekdamsano 
IN (SELECT jikwonno FROM jikwon 
	WHERE busernum=(SELECT buserno FROM buser WHERE busername='총무부'));


-- join 사용
SELECT gogekno, gogekname, gogektel FROM gogek
INNER JOIN jikwon ON jikwon.jikwonno = gogek.gogekdamsano
INNER JOIN buser ON jikwon.busernum = buser.buserno
WHERE busername='총무부';


/*
any, all 연산자 : null인 자료는 제외하고 작업한다.
subqurey와 함께함
- 규칙
	- < any : subquery의 반환값 중 최대값 보다 작은 ~ <= 도 가능
	- > any : subquery의 반환값 중 최소값 보다 큰 ~
	- < all : subquery의 반환값 중 최소값 보다 작은 ~
	- > all : subquery의 반환값 중 최대값 보다 큰 ~
*/

# '대리'의 최대값보다 작은 연봉을 받는 직원은?[최대값 보다 작은, MAX도 가능]
SELECT jikwonno, jikwonname, jikwonpay FROM jikwon
WHERE jikwonpay <ANY (SELECT jikwonpay FROM jikwon WHERE jikwonjik ='대리');

-- 30번 부서의 최고 연봉자 보다 연봉을 많이 받는 직원은?[최대값 보다 큰]
SELECT jikwonno, jikwonname, jikwonpay FROM jikwon
WHERE jikwonpay >ALL (SELECT jikwonpay FROM jikwon WHERE busernum =30);


-- 30번 부서의 최저 연봉자 보다 연봉을 많이 받는 직원은?[최저값 보다 큰, MIN도 가능]
SELECT jikwonno, jikwonname, jikwonpay FROM jikwon
WHERE jikwonpay >ANY (SELECT jikwonpay FROM jikwon WHERE busernum =30);


/*
exsits 연산자 : bool값 처리 true, false값 반환,데이터 값이 있다 없다를 반환하기만 함.
not exsits 
*/
#직원이 있는 부서 출력
SELECT busername, buserloc FROM buser bu
WHERE EXISTS (SELECT 'imsi' FROM jikwon 
			WHERE jikwon.busernum=bu.buserno); -- true 반환, 


#직원이 없는 부서 출력
SELECT busername, buserloc FROM buser bu
WHERE NOT EXISTS (SELECT 'imsi' FROM jikwon 
				WHERE jikwon.busernum=bu.buserno); -- fasle 반환

-- from 절에 사용하는 subquery
-- 자주 보기 어렵지만 존재함.
-- 전체 평균 연봉과 최대 연벙 사이의 연봉을 받는 직원 출력
SELECT jikwonno, jikwonname, jikwonpay 
FROM jikwon a,
		(SELECT AVG(jikwonpay) avgs, MAX(jikwonpay) maxs FROM jikwon) b
WHERE a.jikwonpay BETWEEN b.avgs AND b.maxs;


-- group by 의 having절에 포함된 subquery
-- 부서별 평균 연봉 중 30번 부서의 평균 연봉보다 큰 자료(부서) 출력
SELECT busernum, AVG(jikwonpay) FROM jikwon
GROUP BY busernum 
HAVING AVG(jikwonpay) > (SELECT AVG(jikwonpay) FROM jikwon WHERE busernum = 30);


/* (좀 어려워)
상관 subquery
- outer query의 각 행을inner query에서 참조하여 수행하는 서브쿼리
- 안쪽 질의에서 바깥쪽 질의를 참조하고,
	 다시 안쪽으로 결과를 바깥쪽 질의에서 참조하는 형태
*/
# 각 부서별 최대 연봉자는?
SELECT * FROM jikwon a
WHERE a.jikwonpay = 
		(SELECT MAX(b.jikwonpay) FROM jikwon b WHERE a.busernum=b.busernum);

-- 연봉 순위 3위 이내의 직원 출력(descending sort)
SELECT a.jikwonno , a.jikwonname, a.jikwonpay FROM jikwon a
WHERE 3 > (SELECT COUNT(*) FROM jikwon b WHERE b.jikwonpay > a.jikwonpay)
AND jikwonpay IS NOT NULL ORDER BY jikwonpay DESC;


-- subquery 를 이용한 TABLE 생성, insert , update, delete 수행
-- create + subquery
CREATE TABLE jiktab1 AS SELECT * FROM jikwon; -- jikwon과 동일 테이블 생성 , PK 제외, 괄호 있어도 되고 없어도 됨. 물리적으로 만들어짐.
DESC jiktab1;
DESC jikwon;
SELECT * FROM jiktab1;
CREATE TABLE jiktab2 AS SELECT * FROM jikwon WHERE 1=0 ; -- jikwon과 동일 구조 테이블 생성
DESC jiktab2;

-- insert + subquery
SELECT * FROM jiktab2;
INSERT INTO jiktab2 SELECT * FROM jikwon WHERE jikwonjik='과장'; -- insert에  subquery 사용
SELECT * FROM jiktab2;
INSERT INTO jiktab2 (jikwonno, jikwonname, busernum) 
	SELECT jikwonno, jikwonname, busernum FROM jikwon WHERE jikwonjik='대리'; -- 직급 defult가 사원
SELECT * FROM jiktab2;

-- update + subquery
SELECT * FROM jiktab1;
UPDATE jiktab1 SET jikwonjik=(SELECT jikwonjik FROM jikwon WHERE jikwonname='이순신')
WHERE jikwonno = 2;
SELECT * FROM jiktab1;

-- delete + subquery
DELETE FROM jiktab1 WHERE jikwonno IN (SELECT DISTINCT gogekdamsano FROM gogek);
SELECT * FROM jiktab1;