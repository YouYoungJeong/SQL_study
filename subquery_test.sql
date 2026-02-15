
#문1) 2010년 이후에 입사한 남자 중 급여를 가장 많이 받는 직원은?
SELECT jikwonname, jikwonibsail, jikwonpay, jikwongen  FROM jikwon
	WHERE jikwongen='남' AND jikwonibsail > '2010-01-01'
	AND jikwonpay=
		(SELECT MAX(jikwonpay) FROM jikwon 
			WHERE jikwonibsail > '2010-01-01' 
			AND jikwongen = '남');


#문2)  평균급여보다 급여를 많이 받는 직원은?
SELECT jikwonname , jikwonpay FROM jikwon
	WHERE jikwonpay > (SELECT AVG(jikwonpay) FROM jikwon);
 

#문3) '이미라' 직원의 입사 이후에 입사한 직원은?
SELECT jikwonname, jikwonibsail FROM jikwon 
	WHERE jikwonibsail > (SELECT jikwonibsail FROM jikwon WHERE jikwonname='이미라')
	ORDER BY jikwonibsail;
 

#문4) 2010 ~ 2015년 사이에 입사한 총무부(10),영업부(20),전산부(30) 직원 중 급여가 가장 적은 사람은?
#(직급이 NULL인 자료는 작업에서 제외)
SELECT jikwonname, busernum, jikwonpay  FROM jikwon
	WHERE jikwonibsail BETWEEN '2010-01-01' AND '2015-12-31'
	AND not busernum = 40 AND jikwonjik IS not NULL
	AND jikwonpay IN (SELECT MIN(jikwonpay) FROM jikwon 
			WHERE jikwonibsail BETWEEN '2010-01-01' AND '2015-12-31'
			GROUP BY busernum)
	GROUP BY busernum
;


#문5) 한송이, 이순신과 직급이 같은 사람은 누구인가?
SELECT jikwonname, jikwonjik FROM jikwon 
	WHERE jikwonjik IN (SELECT jikwonjik FROM jikwon WHERE jikwonname IN ('한송이','이순신'))
	ORDER BY jikwonjik;
 


#문6) 과장 중에서 최대급여, 최소급여를 받는 사람은?
SELECT jikwonname, jikwonpay, jikwonjik FROM jikwon
	WHERE jikwonjik='과장' 
	AND jikwonpay = (SELECT MIN(jikwonpay) FROM jikwon
							WHERE jikwonjik='과장')
	OR jikwonpay = (SELECT MAX(jikwonpay) FROM jikwon
							WHERE jikwonjik='과장');


#문7) 10번 부서의 최소급여보다 많은 사람은?
SELECT jikwonname, jikwonpay, busernum FROM jikwon
	WHERE jikwonpay > (SELECT MIN(jikwonpay) FROM jikwon WHERE busernum = 10);


 
#문8) 30번 부서의 평균급여보다 급여가 많은 '대리' 는 몇명인가?
SELECT jikwonname, jikwonpay, busernum, jikwonjik FROM jikwon
	WHERE jikwonjik ='대리' 
	AND jikwonpay > (SELECT AVG(jikwonpay) FROM jikwon WHERE busernum = 30);

 


#문9) 고객을 확보하고 있는 직원들의 이름, 직급, 부서명을 입사일 별로 출력하라.
SELECT jikwonname AS 직원이름, jikwonjik AS 직급, busername AS 부서명, jikwonibsail AS 입사일
	from jikwon inner join buser on busernum=buserno
	INNER JOIN gogek ON gogekdamsano=jikwonno
	WHERE jikwonno IN (SELECT gogekdamsano FROM gogek GROUP BY gogekdamsano)
	ORDER BY jikwonibsail;
	
	
	
	
/* 문10) 이순신과 같은 부서에 근무하는 직원과 해당 직원이 관리하는 고객 출력
(고객은 나이가 30 이하면 '청년', 50 이하면 '중년', 그 외는 '노년'으로 표시하고, 고객 연장자 부터 출력)
출력 ==>  직원명    부서명     부서전화     직급      고객명    고객전화    고객구분

          한송이    총무부     123-1111    사원      백송이    333-3333    청년   */	

SELECT jikwonname AS 직원명, busername AS 부서명, busertel AS 부서전화,
	jikwonjik AS 직급, gogekname AS 고객명, gogektel AS 고객전화,
	case when TIMESTAMPDIFF(YEAR,(SUBSTR(gogekjumin,1,6)),NOW()) <= 30 THEN '청년'
	when TIMESTAMPDIFF(YEAR,(SUBSTR(gogekjumin,1,6)),NOW()) <= 50 THEN '중년'
	ELSE '노년' END AS 고객구분
	from jikwon inner join buser on busernum=buserno
	INNER JOIN gogek ON gogekdamsano=jikwonno
	WHERE busernum = (SELECT busernum FROM jikwon WHERE jikwonname='이순신')
	;