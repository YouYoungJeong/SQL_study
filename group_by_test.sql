#문1) 직급별 급여의 평균 (NULL인 직급 제외)
SELECT jikwonjik AS 직급, AVG(jikwonpay) AS 급여평균 
FROM jikwon
WHERE jikwonjik IS NOT null
GROUP BY jikwonjik;


#문2) 부장,과장에 대해 직급별 급여의 총합
SELECT jikwonjik  AS 직급 , AVG(jikwonpay) AS 급여평균 
FROM jikwon WHERE jikwonjik IN ('부장','과장')  
GROUP BY jikwonjik;

SELECT jikwonjik  AS 직급 , AVG(jikwonpay) AS 급여평균 
FROM jikwon WHERE jikwonjik ='부장'OR jikwonjik ='과장'  
GROUP BY jikwonjik;


#문3) 2015년 이전에 입사한 자료 중 년도별 직원수 출력
SELECT DATE_FORMAT(jikwonibsail,'%Y') as 입사년도, COUNT(*) AS 직원수 
FROM jikwon
GROUP BY 입사년도 HAVING 입사년도 <= 2015;
#==
SELECT YEAR(jikwonibsail) as 입사년도, COUNT(*) AS 직원수 
FROM jikwon
GROUP BY 입사년도 HAVING 입사년도 <= 2015;


#문4) 직급별 성별 인원수, 급여합 출력 (NULL인 직급은 임시직으로 표현)
SELECT nvl(jikwonjik, '임시직') AS 직급, jikwongen AS 성별 , 
COUNT(*) AS 인원수 , SUM(jikwonpay) AS 급여합 
FROM jikwon
GROUP BY jikwonjik, jikwongen;


#문5) 부서번호 10,20에 대한 부서별 급여 합 출력
SELECT busernum AS 부서번호 , SUM(jikwonpay) AS 급여합 
FROM jikwon WHERE busernum IN (10, 20) 
GROUP BY busernum;


#문6) 급여의 총합이 7000 이상인 직급 출력(NULL인 직급은 임시직으로 표현)
SELECT nvl(jikwonjik, '임시직') AS 직급, SUM(jikwonpay) AS 급여합 
FROM jikwon
GROUP BY jikwonjik HAVING 급여합>=7000;


문7) 직급별 인원수, 급여합계를 구하되 인원수가 3명 이상인 직급만 출력
        (NULL인 직급은 임시직으로 표현)
       
SELECT nvl(jikwonjik, '임시직') AS 직급, COUNT(*) AS 직원수, 
SUM(jikwonpay) AS 급여합
FROM jikwon 
GROUP BY jikwonjik HAVING 직원수 >= 3;   
        
        
        