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
WHERE jikwonjik = '대리' AND jikwonibsail=
(SELECT MIN(jikwonibsail) FROM jikwon WHERE jikwonjik='대리');	

# 다른 테이블에서 가져오기
--  인천에 근무하는 직원 출력
SELECT * FROM buser;
SELECT * FROM jikwon 
WHERE busernum=(SELECT buserno FROM buser WHERE buserloc ='인천');

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