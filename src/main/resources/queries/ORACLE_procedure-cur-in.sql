

CREATE OR REPLACE PROCEDURE al_chg_piano_gprs_rate_zone
    IS
--variable declaration
  c_NameTable                        CONSTANT VARCHAR2(30)     := 'PLACE_PIANO_GPRS';
  v_Job                                VARCHAR2(32767);         
  v_Step                               VARCHAR2(32767);         
  v_Message                            VARCHAR2(32767);         
  v_DtStart                            DATE       := SYSDATE; --SYSDATE for ORACLE is equivalent to CURRENT_DATE in TD
  v_DtStartFase                        DATE;               
  v_row_updated                        BINARY_INTEGER := 0;     
  v_row_insert                         BINARY_INTEGER := 0;     
  v_data_dist_zone                     DATE;                    
  v_data_att                           DATE;
  v_data                               DATE;
  
  
  -- varray declaration
  TYPE var_array_ IS VARRAY (2) OF employees%rowtype; -- row type
  TYPE t IS VARRAY (2) OF    employees%rowtype; -- row type
  v_query_str VARCHAR2(1000);
  v_num_of_employees NUMBER;
  
  -- array initialization
  exp_var var_array_ := new var_array_();
   arr t := new t();
  
  --Cursor Declaration 
  CURSOR cur_place_piano_gprs_rate IS
        SELECT 
               a.rowid
             , a.sim_id
             , NVL(e.new_piano_gprs, a.piano_gprs_id_old) piano
             , a.data_atti_via_zone
          FROM cambi_piano_gprs a
             , (SELECT 
                       b.sim_id
                      ,MAX(c.gprs_tariffplan_id) new_piano_gprs
                  FROM bscs_gprs_profiles c,
                       bscs_gprs_subscriber d,
                       tmp_dis_prod_rate_zone b
                 WHERE c.bundle_id = d.bundle_id
                   AND d.sim_id = b.sim_id
                   AND b.tipo_id = 1001
                 GROUP BY b.sim_id
                ) e -- Derived Table
             , tmp_dis_prod_rate_zone f
         WHERE a.sim_id = f.sim_id
           AND f.tipo_id = 1001
           AND a.sim_id = e.sim_id(+) --Left Outer Join
           AND a.piano_gprs_id = '0'
           AND a.data_dist_time_zone IS NULL;

BEGIN
   
   --VARRAY Function Handling
	arr.extend(2);
    select * into arr(2) from bar;
    dbms_output.put_line(arr(2).xx || '/' ||  arr(2).yy);
   
   v_Job := 'Pkg_Act_Deact.Al_Cambi_Piano_Gprs_Rate - ';

   v_DtStartFase := SYSDATE;
   v_Step        := '- Procedure Starting';
   v_Message    := 'Running ';

   Log_Debug(  v_Job || v_Step
             , v_Message
             , Pkg_Log.c_Debug_Level_Admin
             , v_DtStartFase
             , 'I'
             , NULL
             , NULL
             , c_name_tabel
             , 'T'
             );

   v_DtStartFase := SYSDATE;
   v_Message    := ' GPRS Reactivated';

SELECT LEAST(a.al_time_data,b.al_time_data)
       INTO v_data
  FROM
      (SELECT al_time_data
         FROM dw_agg_parameter
        WHERE tabel_zz = 'AGG_CHANGES_SIM') a,
      (SELECT al_time_data
         FROM dw_agg_parameter
        WHERE tabel_zz = 'AGG_CHANGES_GPRS_SUBSCRIBER') b;

    FOR rec_cambi_piano_gprs_rotate IN cur_place_piano_gprs_rate
      LOOP

      v_data_dist_zone  :=  GREATEST(rec_cambi_piano_gprs_rotate.data_atti_via_zone,v_data);
      v_data_att :=v_data_dist_zone +1 /86400;

        UPDATE CAMBI_PIANO_GPRS
           SET data_dist_time_zone = v_data_dist_zone
         WHERE rowid = rec_cambi_piano_gprs_rotate.rowid;

      v_row_updated := v_row_updated + 1;

      INSERT
        INTO CAMBI_PIANO_GPRS
                               (change_piano_gprs_id
                              , sim_id
                              , data_atti_via_zone
                              , piano_gprs_id
                              , piano_gprs_id_old
                              , data_dist_time_zone
                              )
                       VALUES (
                                SEQ_CHG_PIANO_GPRS.NEXTVAL
                              , rec_cambi_piano_gprs_rotate.sim_id
                              , v_data_att
                              , rec_cambi_piano_gprs_rotate.piano --_gprs_id_old
                              , '0'
                              , NULL
                             );

       v_row_insert := v_row_insert + 1;

    END LOOP;

   v_Step        := ' - UPDATE';
   
   -- exp_var.PRIOR(1); -- NULL
   -- exp_var.PRIOR(2); -- The element before #2
   -- exp_var.NEXT(2); -- The element after #2
   -- exp_var.NEXT(5); -- NULL
	
	dbms_output.put_line(exp_var_assgn(1).x);
    dbms_output.put_line(exp_var_assgn(2).s);
	
	v_query_str := 'SELECT COUNT(*) FROM emp_' 
                 || p_loc
                 || ' WHERE job = :bind_job';                           
  EXECUTE IMMEDIATE v_query_str
    INTO v_num_of_employees
    USING p_job;
	
EXCEPTION
   WHEN OTHERS
   THEN
         Log_Debug(  v_Job || v_Step
                  , 'Error: ' || SUBSTR(SQLCODE||'-'||SQLERRM, 1, 1000) || ' during: ' || v_Message
                  , Pkg_Log.c_Debug_Level_Admin
                  , v_DtStart
                  , 'E'
                  , NULL
                  , NULL
                  , c_name_tabel
                  , 'T'
                  );

END al_chg_piano_gprs_rate_zone;


