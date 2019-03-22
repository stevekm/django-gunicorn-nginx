SHELL:=/bin/bash
UNAME:=$(shell uname)
export LOG_DIR:=logs

install: conda-install django $(NEW_CONF)

start: gunicorn-start
	sleep 1
	$(MAKE) nginx-start

stop: gunicorn-kill nginx-stop

# ~~~~~ Setup Conda ~~~~~ #
PATH:=$(CURDIR)/conda/bin:$(PATH)
unexport PYTHONPATH
unexport PYTHONHOME

# install versions of conda for Mac or Linux
ifeq ($(UNAME), Darwin)
CONDASH:=Miniconda3-4.5.4-MacOSX-x86_64.sh
endif

ifeq ($(UNAME), Linux)
CONDASH:=Miniconda3-4.5.4-Linux-x86_64.sh
endif

CONDAURL:=https://repo.continuum.io/miniconda/$(CONDASH)
conda:
	@echo ">>> Setting up conda..."
	@wget "$(CONDAURL)" && \
	bash "$(CONDASH)" -b -p conda && \
	rm -f "$(CONDASH)"

conda-install: conda
	conda install -y -c anaconda \
	django=2.1.2 \
	gunicorn=19.9.0 \
	nginx=1.15.5

# ~~~~~ SETUP DJANGO APP ~~~~~ #
# create the app for development; only need to run this when first creating repo
# django-start:
# 	django-admin startproject webapp .
# 	python manage.py startapp helloworld

django: django-init django-import django-collectstatic

# setup the app for the first time
django-init:
	python manage.py makemigrations
	python manage.py migrate
	python manage.py createsuperuser

# import items to the database
django-import:
	python db_import.py

# copy static files over for web hosting
django-collectstatic:
	python manage.py collectstatic

# run the Django dev server
django-runserver:
	python manage.py runserver

# ~~~~~~ setup Gunicorn WSGI server ~~~~~ #
SOCKET_FILE:=$(CURDIR)/django.sock
SOCKET:=unix:$(SOCKET_FILE)
GUNICORN_CONFIG:=conf/gunicorn_config.py
GUNICORN_PIDFILE:=$(LOG_DIR)/gunicorn.pid
GUNICORN_ACCESS_LOG:=$(LOG_DIR)/gunicorn.access.log
GUNICORN_ERROR_LOG:=$(LOG_DIR)/gunicorn.error.log
GUNICORN_LOG:=$(LOG_DIR)/gunicorn.log
GUNICORN_PID:=
gunicorn-start:
	gunicorn webapp.wsgi \
	--bind "$(SOCKET)" \
	--config "$(GUNICORN_CONFIG)" \
	--pid "$(GUNICORN_PIDFILE)" \
	--access-logfile "$(GUNICORN_ACCESS_LOG)" \
	--error-logfile "$(GUNICORN_ERROR_LOG)" \
	--log-file "$(GUNICORN_LOG)" \
	--daemon

gunicorn-check:
	ps -ax | grep gunicorn

gunicorn-kill: GUNICORN_PID=$(shell head -1 $(GUNICORN_PIDFILE))
gunicorn-kill: $(GUNICORN_PIDFILE)
	kill "$(GUNICORN_PID)"


# ~~~~~ set nginx web sever ~~~~~ #
NGINX_PREFIX:=$(CURDIR)/nginx
NGINX_CONF:=nginx.conf

# need to edit the myapp.conf file
OLD_CONF:=nginx/myapp.conf.og
NEW_CONF:=nginx/myapp.conf
$(NEW_CONF):
	cat "$(OLD_CONF)" | \
	sed 's|unix:/usr/local/bin/apps/myapp/myapp.sock|$(SOCKET)|' | \
	sed 's|/usr/local/bin/apps/myapp/|$(CURDIR)|' > "$(NEW_CONF)"

nginx-start: $(NEW_CONF) $(SOCKET_FILE)
	nginx -p "$(NGINX_PREFIX)" -c "$(NGINX_CONF)"

nginx-stop:
	nginx -p "$(NGINX_PREFIX)" -c "$(NGINX_CONF)" -s quit

nginx-reload:
	nginx -p "$(NGINX_PREFIX)" -c "$(NGINX_CONF)" -s reload

nginx-test:
	nginx -p "$(NGINX_PREFIX)"  -c "$(NGINX_CONF)" -t

nginx-check:
	ps -ax | grep nginx
