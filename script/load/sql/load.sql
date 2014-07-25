connect to mdm_app user db2inst using admin;
load client from /home/hadoop/apps/IBM-MDM-LogAnalyzer/script/load/data/bulk_load.csv of del modified by COLDEL, TIMESTAMPFORMAT="YYYY-MM-DD H:MM:SS" INSERT INTO tbs_mdm.mdm_performance("name","run","operation","delay","date");
