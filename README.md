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

<img width="830" alt="Screen Shot 2019-03-21 at 11 53 11 PM" src="https://user-images.githubusercontent.com/10505524/54799663-926ae480-4c34-11e9-9622-ebe3aad32864.png">

Stop the web server and app server:

```
make stop
```
