#!/bin/bash
#echo "A new docker container stack is ready to be deployed"
echo "The process start time `date`"
echo "Taking backup of the current database..."
pg_dump -h localhost -U postgres -p 5433 bwejiraprod > /home/postgresdb/clone/bwejirabackup.sql
echo "The database is backed up, now lets spin a new database container"
docker run --detach --publish 5432:5432 --name bweclone-db postgrescloneimg;
sleep 30s| echo "A new database server is now up. Please wait till the database gets populated......"
docker logs $(docker ps -a --no-trunc -ql)
sleep 2m| echo "The database restoration process is running in the background..."

Tableno=`psql -h localhost -U postgres -p 5432 bwejiraprod -c "select count(*) from information_schema.tables where table_schema = 'public'"| sed 's/ //g'|sed -n 3p`
dbAddr=`docker inspect --format "{{ .NetworkSettings.IPAddress }}" $(docker ps -ql)`

snapTime=`date +'%Y-%m-%d'`
snapName=daily.$(date +"%Y-%m-%d")_0010
#update the application base URL with IPaddress of this host:port

#psql -h localhost -U postgres -p 5432 bewjiraprod -c "update propertystring set propertyvalue = 'http://10.14.208.28:8005' from propertyentry PE where PE.id=propertystring.id and PE.property_key = 'jira.baseurl';"


if  [ ! -d /home/postgresdb/docker_clone_volume.sh ]; then
    echo "The application data replication process has started"
    /home/postgresdb/docker_clone_volume.sh jiradata jiradata2
    echo "The application data replication process has started"
    /home/postgresdb/docker_clone_volume.sh jirainstall jirainstall2
    echo "The application data replication is completed"
    sleep 3s
    sed -i "s/[0-9]\{1,3\}.[0-9]\{1,3\}.[0-9]\{1,3\}.[0-9]\{1,3\}/$dbAddr/g" /var/lib/docker/volumes/jiradata2/_data/dbconfig.xml
    sleep 5s| echo "The application wil now start"
    docker run --detach -v jiradata2:/var/atlassian/jira -v jirainstall2:/opt/atlassian/jira --publish 8005:8080 cptactionhank/atlassian-jira-software:7.2.6
    echo "The application is now up and running, please access the application at 10.14.208.27:8005"
    echo "The process end time `date`"
fi
