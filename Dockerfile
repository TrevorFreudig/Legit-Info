FROM registry.access.redhat.com/ubi8

WORKDIR /app

# Install Python
USER root
COPY MariaDB.repo /etc/yum.repos.d/
RUN yum -y install python3
RUN yum -y install python3-pip wget 
RUN yum -y install sqlite3
RUN yum -y install openssl openssl-libs openssl-devel
RUN yum -y install MariaDB-client
RUN yum -y install mysql-client

ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

# Install Pip
RUN pip3 install --upgrade pip \
  && pip3 install --upgrade pipenv \
  && pipenv --three

# Install Dependencies
COPY requirements.txt /tmp/requirements.txt
RUN pip3 install --upgrade -r /tmp/requirements.txt

USER 1001

# Copy Code into Container
COPY . /app

# Configurate the Static Database
#RUN python3 manage.py makemigrations learning_logs
#RUN python3 manage.py migrate

CMD ["gunicorn", "-b", "0.0.0.0:3000", "--env", "DJANGO_SETTINGS_MODULE=cfc_project.settings", "cfc_project.wsgi", "--timeout 120"]
