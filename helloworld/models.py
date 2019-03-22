from django.db import models

class Fruit(models.Model):
    """
    Database table to hold types of fruits
    """
    type = models.CharField(max_length=255, unique = True, blank = False)
    def __str__(self):
        return(self.type)
