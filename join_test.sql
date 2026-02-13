#JOIN 연습1 --------------
/*
문1) 직급이 '사원' 인 직원이 관리하는 고객자료 출력
출력 ==>  사번   직원명   직급      고객명    고객전화    고객성별
          3     한국인   사원       우주인    123-4567       남
*/

SELECT jikwonno AS 사번, jikwonname AS 직원명, jikwonjik AS 직급,
gogekname AS 고객명, gogektel AS 고객전화, 
if(gogekjumin LIKE'%-1%', '남', '여') AS 성별
from jikwon INNER join gogek
ON jikwonno = gogekdamsano 
WHERE jikwonjik='사원';

# 성별 나누기 방법
#case SUBSTR(gogekjumin,8,1) when 1 then '남' when 2 then '여' END AS 고객성별
#case when SUBSTR(gogekjumin,8,1) in(1, 3) then '남' 
#		when SUBSTR(gogekjumin,8,1) in(2, 4) then '여' 
# MOD()

END AS 고객성별
/* 문2) 직원별 고객 확보 수  -- GROUP BY 사용
    - 모든 직원 참여 */
SELECT jikwonname AS 직원명,jikwonno ,COUNT(gogekname) AS 담당고객수
FROM jikwon LEFT OUTER  JOIN gogek
ON jikwonno = gogekdamsano
GROUP by jikwonno; -- 동명이인 처리 name보다 no(PK, unique)로


/*문3) 고객이 담당직원의 자료를 보고 싶을 때 즉, 고객명을 입력하면,  
		담당직원 자료 출력  

        :    ~ WHERE GOGEK_NAME='강나루'
출력 ==>  직원명       직급
         한국인       사원 
*/

SELECT jikwonname, jikwonjik 
FROM jikwon INNER JOIN gogek
ON jikwonno=gogekdamsano
WHERE gogekname='강나루';


/*
문4) 직원명을 입력하면 관리고객 자료 출력
       : ~ WHERE JIKWON_NAME='이순신'
출력 ==> 고객명   고객전화          주민번호           나이
         강나루   123-4567    700512-1234567      38
*/
-- date_format(substr(gogekjumin,1,6),'%y%m%d')

SELECT gogekname AS 고객명, gogektel AS 고객전화 , gogekjumin AS 주민번호,
TIMESTAMPDIFF(YEAR, STR_TO_DATE(LEFT(gogekjumin,6),'%y%m%d'), NOW()) AS 나이
FROM jikwon INNER JOIN gogek
ON jikwonno=gogekdamsano 
WHERE jikwonname='한송이';

#JOIN 연습2 ---------------
#문1) 총무부에서 관리하는 고객수 출력 (고객 30살 이상만 작업에 참여)
-- 부서별 담당 고객 이름 확인용
SELECT busername, 
TIMESTAMPDIFF(YEAR, STR_TO_DATE(LEFT(gogekjumin,6),'%y%m%d'), NOW()) AS 고객나이
FROM jikwon INNER join buser on busernum=buserno
inner join gogek ON jikwonno=gogekdamsano
order BY busername 

-- 답
SELECT busername AS 부서명, COUNT(gogekno) AS 담당고객수
FROM jikwon INNER JOIN buser on busernum=buserno
				INNER JOIN gogek ON jikwonno=gogekdamsano 
WHERE TIMESTAMPDIFF(YEAR, STR_TO_DATE(LEFT(gogekjumin,6),'%y%m%d'), NOW()) >= 30
GROUP BY busername HAVING busername='총무부'
# OR
SELECT busername AS 부서명,COUNT(gogekno) AS 담당고객수
FROM jikwon INNER JOIN buser on busernum=buserno
				INNER JOIN gogek ON jikwonno=gogekdamsano 
WHERE TIMESTAMPDIFF(YEAR, STR_TO_DATE(LEFT(gogekjumin,6),'%y%m%d'), NOW()) >= 30
AND busername='총무부'


문2) 부서명별 고객 인원수 (부서가 없으면 "무소속")
SELECT nvl(busername, '무소속') AS 부서명, COUNT(gogekno) AS 고객수
FROM jikwon LEFT OUTER JOIN buser on busernum=buserno
				INNER JOIN gogek ON jikwonno=gogekdamsano
GROUP BY busername;


 
/*문3) 고객이 담당직원의 자료를 보고 싶을 때 즉, 고객명을 입력하면  담당직원 자료 출력  
        :    ~ WHERE GOGEK_NAME='강나루'
출력 ==>  직원명    직급   부서명  부서전화    성별*/
SELECT jikwonname AS 직원명, jikwonjik AS 직급, busername AS 부서명, busertel AS 부서전화, 
		 jikwongen AS 성별
FROM jikwon INNER JOIN buser ON busernum=buserno
				INNER JOIN gogek ON jikwonno=gogekdamsano
WHERE gogekname = '강나루' 


/*문4) 부서와 직원명을 입력하면 관리고객 자료 출력
        ~ WHERE BUSER_NAME='영업부' AND JIKWON_NAME='이순신'
출력 ==>  고객명    고객전화      성별
            강나루   123-4567       남*/
SELECT gogekname AS 고객명, gogektel AS 고객전화,
case SUBSTR(gogekjumin,8,1) when 1 then '남' when 2 then '여' END AS 성별
FROM jikwon INNER JOIN buser ON busernum=buserno
				INNER JOIN gogek ON jikwonno=gogekdamsano
WHERE busername ='영업부' AND jikwonname='이순신'
SELECT * FROM gogek;

