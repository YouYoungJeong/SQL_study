/*(중요)
트랜잭션 : DB의 상태를 변경시키는 논리적인 작업 단위
트랜잭션의 4가지 특징 : ACID
	원자성 (Atomicity), 일관성 (Consistency), 고립성 (Isolation), 지속성 (Durability)
(Insert, Update, Delete)시 트랜잭션 시작함
commit, rollback으로 트랜잭션 종료함
서버종료, 타임아웃 들이 발생해도 트랜잭션이 종료함
orcle은 autocommit 'OFF'
autocommit off로 돌려놓으면 반드시 다 사용하고 on으로 돌려놔야함.
*/

SHOW VARIABLES LIKE 'autocommit%'; -- autocommit 설정 확인 'ON'
SET autocommit = TRUE; -- autocommit 설정
SET autocommit = FALSE; -- autocommit 해제

-- 트랜잭션 연습
CREATE TABLE jiktab3 AS SELECT * FROM jikwon;
SELECT * FROM jiktab3;  -- 연습용 테이블

# 프롬프트에서 같이 작업
# 연습 1 (commit, rollback)
SET autocommit = FALSE;

-- rollback
DELETE FROM jiktab3 WHERE jikwonno=2; -- 트랜잭션 시작 -> 아직 안끝남. : 프롬포트는 그대로
SELECT * FROM jiktab3;
ROLLBACK; -- 트랜잭션 종료(DB서버와 관련없이 해당 컴에서만 진행)
SELECT * FROM jiktab3;

-- commit
DELETE FROM jiktab3 WHERE jikwonno=2;
COMMIT; -- 트랜잭션 종료(DB서버에 현재 컴(클라이언트)의 내용을 근거로 원본 DB서버 갱신) : 프롬포트도 2번 삭제됨.
SELECT * FROM jiktab3;

SET autocommit = TRUE;


# 연습 2(savepoint(저장점)를 이용해 부분적인 트랜잭션 처리 가능)
SET autocommit = FALSE;
-- savepoint
SELECT * FROM jiktab3 WHERE jikwonno=4;
UPDATE jiktab3 SET jikwonpay=7777 WHERE jikwonno=4; # 트랜잭션 시작-> 아직 안끝남
SELECT * FROM jiktab3 WHERE jikwonno=4;
SAVEPOINT a;
UPDATE jiktab3 SET jikwonpay=8888 WHERE jikwonno=5;
SELECT * FROM jiktab3 WHERE jikwonno=5;
ROLLBACK TO SAVEPOINT a; -- savepoint이후만 돌아감. 부분작업취소-> 트랜잭션 아직 안끝남.
SELECT * FROM jiktab3 WHERE jikwonno <= 6;
ROLLBACK; --  rollback만 사용하면 전체 작업 취소. 트랜잭션이 끝남
SELECT * FROM jiktab3 WHERE jikwonno <= 6;
UPDATE jiktab3 SET jikwonpay=9999 WHERE jikwonno=5; -- 트랜잭션시작
COMMIT; -- 트랜잭션종료
SET autocommit = TRUE;
SHOW VARIABLES LIKE 'autocommit%';

/*
교착상태(DeadLock)
두개 이상의 트랜젝션이 서로 상대방이 가진 락(Lock)을 기다리면서 영원히 진행하지 못하는 상태
해결책은 트랜젝션을 수행완료 또는 취소하면 된다.
일관성(Consistency) 유지가 중요	 
*/
SET autocommit = FALSE;
SELECT * FROM jiktab3 WHERE jikwonno = 7;
UPDATE jiktab3 SET jikwonpay = 1234 WHERE jikwonno = 7; -- 트랜젝션 시작
SELECT * FROM jiktab3 WHERE jikwonno = 7;
# 프롬포트(또다른 상황의 사용자)에서 delete from jiktab3 where jikwonno=7; 를진행 -> 프롬포트가 안움직임.
# 데드락 - ERROR 1205 (HY000): Lock wait timeout exceeded; try restarting transaction
COMMIT; -- 트랜잭션을 종료하니까 프롬포트에서 멈춘에러가 끝남.
SET autocommit = TRUE;
SHOW VARIABLES LIKE 'autocommit%';