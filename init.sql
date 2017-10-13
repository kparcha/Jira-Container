CREATE USER jira with password 'Test1234';
CREATE database bwejiraprod template template0;
GRANT ALL PRIVILEGES ON DATABASE bwejiraprod to jira;
GRANT ALL PRIVILEGES ON DATABASE bwejiraprod to postgres;
GRANT ALL PRIVILEGES ON DATABASE bwejiraprod to public;
\q
