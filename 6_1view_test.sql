/*
문1) 사번   이름    부서  직급  근무년수  고객확보
        1   홍길동  영업부 사원     6    O   or  X
조건 : 직급이 없으면 임시직, 전산부 자료는 제외
위의 결과를 위한 뷰파일 v_exam1을 작성

- 직원은 다 나와야 하니까 LEFT OUTER JOIN 사용
- 중복 제거 DISTINCT 사용.
- SELECT문장을 먼저 돌리고나오면 view를 붙여서 만들면됨.
*/
CREATE OR REPLACE VIEW v_exam1 AS 
SELECT DISTINCT jikwonno 사번, jikwonname 이름, busername 부서, nvl(jikwonjik,'임시직') 직급,
TIMESTAMPDIFF(YEAR,(jikwonibsail),NOW()) AS 근무년수,
case
nvl(gogekname, 'a') when 'a' then 'X' ELSE 'O' END AS 고객확보
FROM jikwon LEFT OUTER JOIN buser ON busernum=buserno
LEFT OUTER JOIN gogek ON jikwonno=gogekdamsano
WHERE busername <> '전산부' OR busername IS NULL;

SELECT * FROM v_exam1;


/*
문2) 부서명   인원수

       영업부     7
조건 : 직원수가 가장 많은 부서 출력
위의 결과를 위한 뷰파일 v_exam2을 작성
*/
CREATE OR REPLACE VIEW v_exam2 AS 
SELECT busername 부서명, COUNT(buserno) 인원수
FROM jikwon INNER JOIN buser ON busernum=buserno
GROUP BY buserno 
ORDER BY 인원수 DESC
LIMIT 1;

SELECT * FROM v_exam2;


/*
문3) 가장 많은 직원이 입사한 요일에 입사한 직원 출력
    직원명   요일     부서명   부서전화
    한국인  수요일   전산부   222-2222
위의 결과를 위한 뷰파일 v_exam3을 작성 
*/
CREATE OR REPLACE VIEW v_exam3 AS
SELECT jikwonname 직원명, 
case DATE_FORMAT(jikwonibsail, '%W') 
when 'Monday' then '월요일'
when 'Tuesday' then '화요일'
when 'Wednesday' then '수요일'
when 'Thursday' then '목요일'
when 'Friday' then '금요일'
when 'Saturday' then '토요일'
ELSE '일요일' END AS 요일,
busername 부서명, busertel 부서전화
FROM jikwon LEFT OUTER JOIN buser ON busernum=buserno
WHERE DATE_FORMAT(jikwonibsail, '%W') = (SELECT DATE_FORMAT(jikwonibsail, '%W') 
FROM jikwon
GROUP BY DATE_FORMAT(jikwonibsail, '%W') 
ORDER BY COUNT(jikwonno) DESC
LIMIT 1);

SELECT * FROM v_exam3;



-- ------------------ 0223 db test
SELECT  substr(jikwonibsail,1,4) 입사년도, COUNT(jikwonno) 인원수, 
AVG(IFNULL(jikwonpay, 0)) 연봉평균 FROM jikwon 
WHERE SUBSTR(jikwonibsail,1,4) BETWEEN 2015 AND 2020
GROUP BY SUBSTR(jikwonibsail,1,4);
SELECT * FROM jikwon ORDER BY jikwonibsail DESC ;

SELECT * FROM gogek;
SELECT jikwonname 직원명, jikwonpay 급여, count(gogekname) 고객수
FROM jikwon LEFT OUTER JOIN gogek ON jikwonno=gogekdamsano
WHERE jikwonpay > (SELECT AVG(jikwonpay) FROM jikwon)
GROUP BY jikwonno;

SELECT jikwonname 직원명, jikwonpay 급여
FROM jikwon LEFT OUTER JOIN gogek ON jikwonno=gogekdamsano
WHERE jikwonpay > (SELECT AVG(jikwonpay) FROM jikwon)

SELECT jikwonno, jikwonname, busername, jikwonjik FROM jikwon
LEFT OUTER JOIN buser ON busernum = buserno 
WHERE jikwonjik='과장';

SELECT * FROM jikwon 
WHERE jikwonpay>(SELECT AVG(jikwonpay) FROM jikwon);



