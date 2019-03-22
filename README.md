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

- the Django website should be accessible at `http://127.0.0.1:8080/`, with the Django admin panel at `http://127.0.0.1:8080/admin/`
