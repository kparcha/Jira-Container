#!/bin/bash
psql -h localhost -U postgres -c "create database bwejiraprod template template0 LC_COLLATE 'C' LC_CTYPE 'C';"
psql -h localhost -U postgres -c "create role jira with login superuser password 'Test1234';"
psql -h localhost -U postgres -c "GRANT ALL PRIVILEGES ON DATABASE bwejiraprod to jira;" 
psql -h localhost -U postgres -c "GRANT ALL PRIVILEGES ON DATABASE bwejiraprod to postgres;"
psql -h localhost -U postgres -c "GRANT ALL PRIVILEGES ON DATABASE bwejiraprod to public; " 
psql -h localhost -U postgres bwejiraprod < /opt/bwejiraprod2.pgsql
