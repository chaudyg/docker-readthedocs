FROM python:2.7-slim
MAINTAINER Georges Chaudy "chaudyg@gmail.com"

WORKDIR /usr/src/app/readthedocs
ENV APPDIR /usr/src/app
ENV DJANGO_SETTINGS_MODULE settings.sqlite

# Install linux dependencies
RUN apt-get -qq update && \
    apt-get -y -qq upgrade && \
    apt-get install -y -qq git build-essential python-dev libxml2-dev libxslt1-dev zlib1g-dev wget unzip libpq-dev python-dev  && \
    apt-get clean

# Get latest RTD version
RUN mkdir -p $APPDIR && cd $APPDIR && \
    wget -q --no-check-certificate https://github.com/rtfd/readthedocs.org/archive/master.zip && \
    unzip master.zip >/dev/null 2>/dev/null && rm -f master.zip && \
    mv readthedocs.org-master/* readthedocs.org-master/.??* . && \
    rmdir readthedocs.org-master

# Install python requirements
RUN pip install -r $APPDIR/requirements.txt
RUN pip install -r $APPDIR/requirements/deploy.txt --allow-external launchpadlib --allow-unverified launchpadlib


# Setup local DB
RUN python manage.py syncdb --noinput --settings=$DJANGO_SETTINGS_MODULE && \
	python manage.py migrate --settings=$DJANGO_SETTINGS_MODULE && \
	python manage.py loaddata test_data --settings=$DJANGO_SETTINGS_MODULE && \
	python manage.py collectstatic --noinput && \
	echo "from django.contrib.auth.models import User; User.objects.create_superuser('admin', 'admin@localhost', 'admin')" | python manage.py shell --settings=$DJANGO_SETTINGS_MODULE

# COPY new config
COPY settings.py settings/sqlite.py

# Nginx config
COPY nginx /etc/nginx
VOLUME /etc/nginx/
VOLUME /usr/src/app/

EXPOSE 8000
CMD gunicorn -b 0.0.0.0:8000 wsgi