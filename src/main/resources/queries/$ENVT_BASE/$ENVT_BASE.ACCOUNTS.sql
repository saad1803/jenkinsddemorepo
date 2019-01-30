CREATE MULTISET TABLE $ENVT_BASE.ACCOUNTS ,NO FALLBACK ,
     NO BEFORE JOURNAL,
     NO AFTER JOURNAL,
     CHECKSUM = DEFAULT,
     DEFAULT MERGEBLOCKRATIO
     (
      Account_Id INTEGER ,
      Account_Start_Dt DATE FORMAT 'YYYY-MM-DD' ,
      Account_End_Dt DATE FORMAT 'YYYY-MM-DD',
      Account_Nbr VARCHAR(1) CHARACTER SET LATIN NOT CASESPECIFIC ,
      Account_Type_Cd SMALLINT ,
      Account_Active_Cd SMALLINT ,
      Account_Active CHAR(1) CHARACTER SET LATIN NOT CASESPECIFIC ,
      Start_Date DATE FORMAT 'YYYY-MM-DD' ,
      End_Date DATE FORMAT 'YYYY-MM-DD'  COMPRESS (DATE '9999-12-31'),
      Record_Deleted_Flag BYTEINT  COMPRESS (0 ,1 ),
      Ctl_Id SMALINT  COMPRESS 2 ,
      Process_Name VARCHAR(30) CHARACTER SET LATIN NOT CASESPECIFIC  COMPRESS 'TX_002_02_ACCOUNT_ACCOUNTS',
      Process_Id ITEGER ,
      Update_Process_Name VARCHAR(30) CHARACTER SET LATIN NOT CASESPECIFIC COMPRESS 'TX_002_02_ACCOUNT_ACCOUNTS',
      Update_Process_Id INTEGER COMPRESS )
PRIMARY INDEX ( Account_Id );
