CREATE MULTISET TABLE $ENVT_BASE.ACCOUNT_ACTIVE ,NO FALLBACK ,
     NO BEFORE JOURNAL,
     NO AFTER JOURNAL,
     CHECKSUM = DEFAULT,
     DEFAULT MERGEBLOCKRATIO
     (
      Acct_Active_Id INTEGER NOT NULL,
      Acct_Active_Cd VARCHAR(10) CHARACTER SET LATIN NOT CASESPECIFIC NOT NULL,
      Acct_Active_Desc VARCHAR(30) CHARACTER SET LATIN NOT CASESPECIFIC NOT NULL,
      Start_Date DATE FORMAT 'YYYY-MM-DD' NOT NULL,
      End_Date DATE FORMAT 'YYYY-MM-DD' NOT NULL COMPRESS (DATE '9999-12-31'),
      Record_Deleted_Flag BYTEINT NOT NULL COMPRESS (0 ,1 ),
      Ctl_Id SMALLINT NOT NULL COMPRESS 1 ,
      Process_Name VARCHAR(30) CHARACTER SET LATIN NOT CASESPECIFIC NOT NULL COMPRESS 'TX_002_02_ACCOUNT_ACCOUNTS',
      Process_Id INTEGER NOT NULL,
      Update_Process_Name VARCHAR(30) CHARACTER SET LATIN NOT CASESPECIFIC COMPRESS 'TX_002_02_ACCOUNT_ACCOUNTS',
      Update_Process_Id INTEGER COMPRESS )
PRIMARY INDEX ( Acct_Active_Id );
