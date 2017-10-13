FROM postgres:9.2
RUN apt-get update && apt-get install -y vim && apt-get install -y python
COPY bwejiraprod2.pgsql /opt/
RUN chown postgres:postgres -R /opt/
ADD importdb.sh /docker-entrypoint-initdb.d/importdb.sh
RUN chmod 755 /docker-entrypoint-initdb.d/importdb.sh

