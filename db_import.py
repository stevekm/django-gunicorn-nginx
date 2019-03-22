#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
Script to import some items into the Django database
"""
import os
import sys
import django

# set up the django app and import the database model
parentdir = os.path.dirname(os.path.realpath(__file__))
sys.path.insert(0, parentdir)
os.environ.setdefault("DJANGO_SETTINGS_MODULE", "webapp.settings")
django.setup()
from helloworld.models import Fruit
sys.path.pop(0)

for fruit in ['apple', 'banana', 'avocado', 'orange']:
    instance, created = Fruit.objects.get_or_create(type = fruit)
    if created:
        print("Imported fruit: {0}".format(instance.type))
    else:
        print("ERROR: Could not import fruit: {0}".format(instance.type))

print("All the fruits in the database:")
all_fruits = Fruit.objects.all()
print([ x.type for x in all_fruits ])
