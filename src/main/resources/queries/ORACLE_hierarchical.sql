/*************************SAMPLE 1*********************/

SELECT LEVEL,S1.*
FROM emp S1,
(
   SELECT
   LEVEL 
   FROM
   DUAL
   CONNECT BY LEVEL BETWEEN 1 AND 2
 ) ; 
 
 /*************************END SAMPLE 1*********************/
 /**********************************************************/
 
 
 /*************************SAMPLE 2*********************/
    select lpad(first_name,level*4) first_name, emp_id, manager_id
    from emp
    START WITH manager_id IS NULL
    CONNECT BY PRIOR EMP_ID = manager_id;
 /*************************END SAMPLE 2*********************/
 /**********************************************************/
	
	
	
	/*************************SAMPLE 3*********************/
	
	SELECT emp_id, last_name, manager_id
   FROM emp
   CONNECT BY PRIOR emp_id = manager_id;
    /*************************END SAMPLE 3*********************/
 /**********************************************************/
 
 
 
 /*************************SAMPLE 4*********************/
   
    SELECT emp_id, last_name, manager_id, LEVEL
   FROM emp
   CONNECT BY PRIOR emp_id = manager_id;
   
    /*************************END SAMPLE 4*********************/
 /**********************************************************/