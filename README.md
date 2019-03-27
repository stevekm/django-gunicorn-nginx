# django-gunicorn-nginx

Demonstration of deployment of Django web app with Gunicorn WSGI server and nginx web server.

# Usage

Clone this repo:

```
git clone https://github.com/stevekm/django-gunicorn-nginx.git
cd django-gunicorn-nginx
```

Install Django, Gunicorn, nginx, in the current directory using conda

```
make install
```

- provide a username and password for the admin account in Django

Run the web servers:

```
make start
```

- the demo nginx page should be accessible at `http://127.0.0.1:8079/`

<img width="830" alt="Screen Shot 2019-03-21 at 11 53 01 PM" src="https://user-images.githubusercontent.com/10505524/54799651-7ff0ab00-4c34-11e9-84f6-03a0c35eda99.png">

- the Django website should be accessible at `http://127.0.0.1:8080/`, with the Django admin panel at `http://127.0.0.1:8080/admin/`

<img width="830" alt="Screen Shot 2019-03-22 at 12 49 06 PM" src="https://user-images.githubusercontent.com/10505524/54839288-ef9c7f80-4ca0-11e9-92ae-fe51461e5977.png">

<img width="830" alt="Screen Shot 2019-03-22 at 12 53 06 PM" src="https://user-images.githubusercontent.com/10505524/54839568-810bf180-4ca1-11e9-93e1-fc65b548af20.png">

<img width="830" alt="Screen Shot 2019-03-22 at 12 53 10 PM" src="https://user-images.githubusercontent.com/10505524/54839582-8cf7b380-4ca1-11e9-8040-b3b85ff3dddb.png">

Stop the web server and app server:

```
make stop
```

# Django

Django is a web app framework for Python. It allows you to leverage Python and its libraries in your web applications, such as `pandas`, `numpy`, etc.. Django also has a great database ORM, letting you interface with databases such as SQLite and PostgreSQL as Python objects, without having to write SQL commands and queries. On top of all this, it provides a free 'admin panel' out of the box, where you can add, edit, update, and delete entries from your databases via a web interface. Django is well-established, has great community support, and offers a variety of add-ons for added functionality.

## Notes

The included demo Django app includes two parts: `webapp` and `helloworld`. `webapp` is the parent Django "project" that controls the entire app, and `helloworld` is a modular app that is managed by the project. `webapp` includes the settings and URL configurations that determine how everything functions (`webapp/settings.py`, `webapp/urls.py`). Notably, an example has been included on how to set up some customized logging behavior that can be used throughout the apps.

`helloworld` is a basic app that includes a database model for recording the names of some fruits (`helloworld/models.py`). The default configuration uses a SQLite database to store this information. This app contains a single web "view", which returns a message describing the fruits that are in the app database (`helloworld/views.py`).

An additional script has been included, `db_import.py`, which imports some fruits into the app database for you. This shows how you can initialize your Django app and interact with it via scripts and other programs.

## Resources

- offical website: https://www.djangoproject.com/

- documentation: https://docs.djangoproject.com/en/2.1/

- official tutorial: https://docs.djangoproject.com/en/2.1/intro/tutorial01/

- Django Girls tutorial: https://tutorial.djangogirls.org/en/

- deployment checklist: https://docs.djangoproject.com/en/2.1/howto/deployment/checklist/

# Gunicorn

While Django includes a basic web server (`python manage.py runserver`), it is not appropriate for user-facing or production usage; instead you should use a WSGI server. Gunicorn is one such server, and is easy to configure for usage with Django. This replaces the Django built-in web server when you want to deploy your app "for real".

## Resources

- Gunicorn homepage: https://gunicorn.org/

- Django & WSGI: https://docs.djangoproject.com/en/2.1/howto/deployment/wsgi/

- Django & Gunicorn: https://docs.djangoproject.com/en/2.1/howto/deployment/wsgi/gunicorn/

- Gunicorn deployment: https://docs.gunicorn.org/en/latest/deploy.html

- "Run a Django app with Gunicorn": [Part 1](http://rahmonov.me/posts/run-a-django-app-with-gunicorn-in-ubuntu-16-04/), [Part 2](http://rahmonov.me/posts/run-a-django-app-with-nginx-and-gunicorn/)

- "Deploying Django with nginx and gunicorn": http://honza.ca/2011/05/deploying-django-with-nginx-and-gunicorn

- Gunicorn sample config file: https://github.com/benoitc/gunicorn/blob/cc8e67ea83ce1064ef605d82130ace2a3670d68a/examples/example_config.py

# nginx

nginx is a standard web server, widely used to serve websites and web apps. It does not natively serve Python apps, but offers advantages over using the Python WSGI serve alone. Additionally, it serves the static files for your app (images, .css files, etc.), which are not typically handled by the WSGI server. It can also act as a reverse proxy, directing the incoming network traffic to your web app's WSGI server and can act as a buffer against the WSGI server.

## Notes

Typically, nginx lives in your server and is managed independently of your web apps. In this example repo, nginx is installed via conda, and includes items at these locations:

```
conda/bin/nginx
conda/etc/nginx
conda/var/log/nginx
conda/var/tmp/nginx
```

nginx expects to find specific files in specific locations on the system, relative to a "prefix" location, which defaults to the standard install location. For the purpose of this demonstration, the "prefix" is provided to nginx as `${PWD}/nginx/`, or the `nginx/` directory included here. Based on this prefix, the following included locations are required for nginx to function:

```
nginx/var/log/nginx
nginx/var/run/nginx
nginx/var/tmp/nginx
```

Additionally, we are using a custom config file, `nginx.conf`; using the "prefix" configuration, it corresponds to this file:

```
nginx/nginx.conf
```

This file "includes" configs from adjacent files, `nginx/myapp.conf` and `nginx/default-site.conf`. A default site for nginx has been included to help determine that nginx is running correctly, located at `http://127.0.0.1:8079/`.

In order to communicate between nginx and Gunicorn, we are using a Unix socket, created at `${PWD}/django.sock`. This allows communication between processes on the same system; if Gunicorn and nginx were running on different computers, we would use a network address here instead.

## Resources

- Beginner's guide: http://nginx.org/en/docs/beginners_guide.html

- home page: https://nginx.org/en/

- Core functionality and configuration descriptions: http://nginx.org/en/docs/ngx_core_module.html

- Logging configuration: https://docs.nginx.com/nginx/admin-guide/monitoring/logging/

- Pitfalls and Common Mistakes: https://www.nginx.com/resources/wiki/start/topics/tutorials/config_pitfalls/

- config mangement: https://tylergaw.com/articles/how-i-manage-nginx-config/

- Config example: https://www.nginx.com/resources/wiki/start/topics/examples/full/

# conda

conda is a package manager, which allows for the scripted installation of version-controlled software and libraries. conda allows us to install all the software needed for this demo without requiring admin-rights to the computer or server.

conda was originally developed for Python library management but has expanded to include a wide range of software.

conda is often downloaded via the Anaconda and Miniconda distributions. Anaconda is a package that includes conda + a large number of optional Python libraries, whereas Miniconda is a bare-bones installation of conda + essential Python libraries. Miniconda is used in this demonstration. Both Anaconda and Miniconda come in '2' and '3' variants, which correspond to the base versions of Python they include (Python 2 and Python 3, respectively).

## Resources

- home page: https://conda.io/en/latest/

- Miniconda archive: https://repo.anaconda.com/miniconda/

# make

This demonstration uses a Makefile to wrap up all the commands to be run (see the file `Makefile`). Makefiles consist of "targets" and "recipes", where the recipe is a list of commands used to create the target item. Targets can have dependencies on other targets, and Makefiles can include variables that can be exported into the shell environment of the commands run in  recipes. In this case, the targets are easy names to describe the actions we are taking. You can read the Makefile to see the full list of commands being used throughout the demo.

Importantly, the Makefile also configures the environment so that the software installed with conda in this directory is used to run all commands. Thus, you should use Makefile recipes to run all commands to interact with the programs used in this repo. 

# Software

Software used in this demonstration:

- Python 3.6

- Django 2.2.1

- Gunicorn 19.9.0

- nginx 1.15.5

- conda (Miniconda 3) 4.5.4

- GNU Make 3.81

This demonstration was designed on macOS 10.12.6 Sierra, and should work on most macOS and Linux operating systems.
