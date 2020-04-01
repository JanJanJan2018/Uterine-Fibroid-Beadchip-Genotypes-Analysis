USE newspaper_search_results;	

CREATE TABLE newspaper_search_results.tbl_newspaper_search_results ( id INT NOT NULL AUTO_INCREMENT, story_title VARCHAR(99) NULL, story_date_published DATETIME NULL, story_url VARCHAR(99) NULL, search_term_used VARCHAR(45) NULL, PRIMARY KEY (id));

ALTER USER 'newspaper_search_results_user'@'localhost' identified with mysql_native_password by 'Miss12345$';	

INSERT INTO tbl_newspaper_search_results ( story_title, story_date_published, story_url, search_term_used) VALUES('THE LOST LUSITANIA.', '1915-05-21', LEFT(RTRIM('http://newspapers.library.wales/view/4121281/4121288/94/'),99), 'German+Submarine');

SELECT story_title FROM tbl_newspaper_search_results; 

SELECT story_title, story_date_published FROM tbl_newspaper_search_results ;

select story_title,story_date_published from tbl_newspaper_search_results; 
select story_title,story_date_published from tbl_newspaper_search_results ;

select story_title,story_date_published, search_term_used from tbl_newspaper_search_results ;

TRUNCATE tbl_newspaper_search_results;	

select story_title,story_date_published from tbl_newspaper_search_results; 

select story_title,story_date_published from tbl_newspaper_search_results; 

select story_title,story_date_published from tbl_newspaper_search_results;

select story_title,story_date_published from tbl_newspaper_search_results; 

select story_title,story_date_published from tbl_newspaper_search_results; 

select story_title,story_date_published from tbl_newspaper_search_results; 

SELECT * FROM newspaper_search_results.tbl_newspaper_search_results WHERE story_title = "THE LOST LUSITANIA'S RUDDER." ;

TRUNCATE tbl_newspaper_search_results;	

SELECT * FROM newspaper_search_results.tbl_newspaper_search_results WHERE story_title = "THE LOST LUSITANIA'S RUDDER."; 

SELECT COUNT(*) FROM tbl_newspaper_search_results;

