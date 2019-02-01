CREATE OR REPLACE PROCEDURE sp_varargs01(VARCHAR(128), VARCHAR(128))
  RETURNS INTEGER
  LANGUAGE NZPLSQL
  AS 
  BEGIN_PROC
	DECLARE
          tDocumentation   VARCHAR := 'Created by run_deltas.sh on Tue Apr 17 11:29:25 BST 2018';
         -- tDistributionKeyRecords    RECORD;
         -- tDistributionMethodRecord  RECORD;
          tTargetDB                  VARCHAR := '';
          tTable                     VARCHAR := '';
          tWorkTableName             VARCHAR := '';
          tFullyQualifiedTargetTable VARCHAR := '';
          tDistributionKey           VARCHAR := '';
          tDistribution              VARCHAR := '';
          tCreateTableSQL            VARCHAR := '';
          tDebugMsg                  VARCHAR := '';
          tComma                     VARCHAR := '';
		  
      
      BEGIN
      
          tTargetDB := UPPER($1) ;
          tTable := UPPER($2) ;
          tFullyQualifiedTargetTable := tTargetDB || '..' || tTable ;
          tWorkTableName := 'WRK_' || tTable ;
      
          /* Get the distribution key for the target table */
		 tCreateTableSQL :='SELECT attname '
              || ' FROM '||tTargetDB||'.._v_table_dist_map_xdb'
              || ' WHERE tablename = '''||tTable||''''
              || ' ORDER BY distseqno';
          tComma:='';
          FOR tDistributionKeyRecords IN 
              tCreateTableSQL
          LOOP
              tDistributionKey := tDistributionKey || tComma || tDistributionKeyRecords.attname;
              tComma =',';
          END LOOP;
      
      
          /* If no distribution key has been found, then there are 2 further options: Random and None. */
      tCreateTableSQL :=  'SELECT reldistmethod '
                  || ' FROM '||tTargetDB||'.._v_table_xdb'
                  || ' WHERE tablename= '''||tTable||''' LIMIT 1';
          IF tDistributionKey = ''
          THEN
              FOR tDistributionMethodRecord IN
                  tCreateTableSQL
              LOOP
      
                  IF tDistributionMethodRecord.reldistmethod = 6005 -- random
                  THEN
                      tDistribution := 'DISTRIBUTE ON RANDOM';
                  END IF;
      
                  -- If not RANDOM (6005), then don't set tDistribution
      
              END LOOP;
          ELSE
              -- The HASH distribution method
              tDistribution:='DISTRIBUTE ON ('||tDistributionKey||')';
          END IF;
        
        
          tCreateTableSQL := 'CREATE TABLE  ' || tWorkTableName || ' AS SELECT t.*, SUBSTR(''X'',1,1) AS db_action FROM ' || tFullyQualifiedTargetTable || ' t ' || ' LIMIT 0 ' || tDistribution || ';' ;
         
          EXECUTE IMMEDIATE  tCreateTableSQL ;
       
          tDebugMsg := 'created table ' || tWorkTableName ;
          --tDebugMsg = tCreateTableSQL ;
      
          RETURN tDebugMsg; 
       
      END;
END_PROC;
