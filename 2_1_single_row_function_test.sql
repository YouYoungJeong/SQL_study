-- --------------------------------------------------------------------
#select 기초 연수 문제 (단일행 함수)
# 문1)
#5년 이상 근무하면 '감사합니다', 그 외는 '열심히' 라고 표현 
#( 2010 년 이후 직원만 참여 )
#특별수당(pay를 기준) : 10년 이상 5%, 나머지 3% (정수로 표시:반올림)
SELECT jikwonname AS 직원명,
TRUNCATE((DATEDIFF(NOW(),jikwonibsail))/365,0) AS 근무년수,
if(TRUNCATE((DATEDIFF(NOW(),jikwonibsail))/365,0) >=10 ,
'감사합니다','열심히') AS 표현,
if(TRUNCATE((DATEDIFF(NOW(),jikwonibsail))/365,0) >=10 ,
round(jikwonpay*0.05),round(jikwonpay*0.03)) AS 특별수당
FROM jikwon WHERE jikwonibsail >= '2010-01-01';   


# 근무년수 계산하는 방법 DATE_FORMAT, TIMESTAMPDIFF(YEAR, jikwonibsail, now())
SELECT DATE_FORMAT(NOW(),'%Y') - DATE_FORMAT(jikwonibsail,'%Y') AS 근무년수,
TIMESTAMPDIFF(YEAR, jikwonibsail, NOW()) AS 근무년수2
FROM jikwon;

     
# 문제2) 입사 후 8년 이상이면 왕고참, 5년 이상이면 고참, 
# 3년 이상이면 보통, 나머지는 일반으로 표현
# join금지
SELECT jikwonname AS 직원명, jikwonjik AS 직급,
DATE_FORMAT(jikwonibsail, '%Y.%c.%e') AS 입사년월일,
case when 8 <= DATE_FORMAT(NOW(),'%Y') - DATE_FORMAT(jikwonibsail,'%Y')then '왕고참' 
when 5 <= TIMESTAMPDIFF(YEAR, jikwonibsail, now()) then '고참' 
when 3 <= TRUNCATE((DATEDIFF(NOW(),jikwonibsail))/365,0) then '보통' 
ELSE '일반'
END AS 구분,
case busernum
when 10 then '총무부'
when 20 then '영업부'
when 30 then '전산부'
when 40 then '관리부' END AS 부서
FROM jikwon;

#문제3) 각 부서번호별로 실적에 따라 급여를 다르게 인상하려 한다.
# pay를 기준으로 10번은 10%, 30번은 20% 인상하고 나머지 부서는 동결한다.
# 8년 이상 장기근속을 O,X로 표시,  금액은 정수만 출력(반올림)
SELECT jikwonno AS 사번 ,jikwonname AS 직원명, busernum AS 부서, 
jikwonpay AS 연봉 ,
case busernum 
	when 10 then round(jikwonpay * 1.1)
	when 30 then round(jikwonpay * 1.2)
	ELSE jikwonpay END AS 인상연봉,
if( 8 <= TIMESTAMPDIFF(YEAR, jikwonibsail, now()) , 'O','X')AS 장기근속
FROM jikwon;





 