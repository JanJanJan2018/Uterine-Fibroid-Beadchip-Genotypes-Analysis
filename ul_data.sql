/* This uses the csv file on uterine leiomyoma beadchip data in RStudio 
to fill in a table in a data base both created from within RStudio MySQL_on_ULdata.R*/
use ul_data;
select count(sequence) from ul_data;

select * from ul_data.ul_data;

select SEQUENCE,SYMBOL,GENE_COUNT,FOLDCHANGE_MEAN_UL_to_nonUL FROM ul_data.ul_data
WHERE( FOLDCHANGE_MEAN_UL_to_nonUL > 1.5 AND GENE_COUNT>2)
ORDER BY GENE_COUNT DESC,FOLDCHANGE_MEAN_UL_to_nonUL DESC LIMIT 30;

CREATE DATABASE UL_Data; /*server->users&privileges->add new user -> new user-tab selection radio options */
ALTER USER 'newuser'@'localhost' IDENTIFIED WITH mysql_native_password BY '2020mystery$';

