FROM store/oracle/database-instantclient:12.2.0.1

MAINTAINER "Ajay Kangare <ajay@infracloud.io>"

# Install restic to take backups
COPY --from=restic/restic:0.9.5 /usr/bin/restic /usr/local/bin/restic

#Install GZip
ADD gzip /usr/local/bin/

# Install kando
ADD kando /usr/local/bin/

# Install RMAN
ADD rman /usr/local/bin/

RUN mkdir -p rdbms/mesg
RUN mkdir -p rdbms/admin

COPY rmanus.msb /rdbms/mesg
COPY recover.bsq /rdbms/admin

ENV PATH=$PATH:.:/
ENV ORACLE_HOME=.

CMD ["tail", "-f", "/dev/null"]

