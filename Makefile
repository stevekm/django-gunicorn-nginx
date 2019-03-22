SHELL:=/bin/bash
UNAME:=$(shell uname)

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
# start-django:
# 	django-admin startproject webapp .
# 	python manage.py startapp helloworld
