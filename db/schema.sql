CREATE TABLE 'postings' (
id INTEGER PRIMARY KEY AUTOINCREMENT,
posted_on varchar(100),
price varchar(100),
location varchar(250),
category varchar(100),
url varchar(250),
title varchar(250),
created_at DATETIME,
updated_at DATETIME,
search_result_id integer,
FOREIGN KEY (search_result_id) REFERENCES search_results(id)
)