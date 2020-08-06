# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models

RANGE_1_TO_10 = (
    (1, 1), (2, 2), (3, 3), (4, 4), (5, 5), (6, 6),
    (7, 7), (8, 8), (9, 9), (10, 10)
)

COMPASS_DIRS = (
    ('N', 'N'), ('NNE', 'NNE'), ('NE', 'NE'), ('ENE', 'ENE'), ('E', 'E'),
    ('ESE', 'ESE'), ('SE', 'SE'), ('SSE', 'SSE'), ('S', 'S'), ('SSW', 'SSW'),
    ('SW', 'SW'), ('WSW', 'WSW'), ('W', 'W'), ('WNW', 'WNW'), ('NW', 'NW'),
    ('NNW', 'NNW')
)

SURF_QUALITY = (
    ('1', 'FLAT'), ('2', 'VERY POOR'), ('3' ,'POOR'), ('4' ,'POOR to FAIR'),
    ('5' ,'FAIR'), ('6' ,'FAIR to GOOD'), ('7' ,'GOOD'), ('8' ,'VERY GOOD'),
    ('9' ,'GOOD to EPIC'), ('10' ,'EPIC'),
)

DEGREES = [(degree, degree) for degree in range(0,361)]

GROWTH_DIRECTIONS = ((0, 0),(1, 1))

# Create your models here.
class REGION(models.Model):
    region_id = models.AutoField(primary_key=True)
    name = models.CharField(max_length=45)


class BEACH(models.Model):
    beach_id = models.AutoField(primary_key=True)
    name = models.CharField(max_length=45)
    time_impact = models.IntegerField(
        choices=RANGE_1_TO_10
    )
    min_reccomended_skill_level = models.IntegerField(
        choices=RANGE_1_TO_10
    )
    latitude = models.FloatField()
    longitude = models.FloatField()
    region = models.ForeignKey(REGION, on_delete=models.CASCADE)

class SURFER(models.Model):
    surfer_id = models.AutoField(primary_key=True)
    first_name = models.CharField(max_length=45)
    last_name = models.CharField(max_length=45)
    skill_level = models.IntegerField(
        choices=RANGE_1_TO_10
    )
    favorite_beach = models.ForeignKey(
        BEACH, on_delete=models.CASCADE, null=False
    )
    local_region = models.ForeignKey(
        REGION, on_delete=models.CASCADE, null=False
    )

class WETSUIT(models.Model):
    wetsuit_id = models.AutoField(primary_key=True)
    thickness = models.CharField(max_length=3)
    model = models.CharField(max_length=25)
    brand = models.CharField(max_length=25)
    
class READING_INCREMENT(models.Model):
    reading_id = models.AutoField(primary_key=True)
    date = models.DateField() # ex: datetime.date(1997, 10, 19) 
    time = models.TimeField() # ex: datetime.time(hour=0, minute=0, second=0) 

class SURFLINE_REPORT(models.Model):
    report_id = models.AutoField(primary_key=True)
    min_wave_height = models.FloatField()
    max_wave_height = models.FloatField()
    verdict = models.IntegerField(
        choices=SURF_QUALITY
    )
    wetsuit = models.ForeignKey(
        WETSUIT, on_delete=models.SET_NULL, null=True
    )
    beach = models.ForeignKey(
        BEACH, on_delete=models.CASCADE, null=True
    )
    region = models.ForeignKey(
        REGION, on_delete=models.CASCADE, null=True
    )
    reading_increment = models.ForeignKey(
        READING_INCREMENT, on_delete=models.CASCADE, null=False
    )

class ANNOTATION(models.Model):
    annotation_id = models.AutoField(primary_key=True)
    comment = models.CharField(max_length=150)
    verdict = models.IntegerField(
        choices=SURF_QUALITY
    )
    observed_min_wave_height = models.FloatField()
    observed_max_wave_height = models.FloatField()
    surfline_report = models.ForeignKey(
        SURFLINE_REPORT,
        blank=True,
        null=True,
        on_delete=models.SET_NULL
    )
    surfer = models.ForeignKey(
        SURFER, on_delete=models.CASCADE, null=False
    )
    beach = models.ForeignKey(
        BEACH, on_delete=models.CASCADE, null=False
    )
    reading_increment = models.ForeignKey(
        READING_INCREMENT, on_delete=models.CASCADE, null=False
    )


class LIGHTING(models.Model):
    lighting_id = models.AutoField(primary_key=True)
    first_light = models.TimeField() 
    last_light = models.TimeField() 
    sunrise = models.TimeField() 
    sunset = models.TimeField() 
    date = models.DateField()
    beach = models.ForeignKey(BEACH, on_delete=models.CASCADE)
    
# Surf Metrics
class WIND(models.Model):
    wind_id = models.AutoField(primary_key=True)
    speed = models.FloatField()
    direction = models.CharField(
        max_length=3,
        choices=COMPASS_DIRS
    )
    degree = models.IntegerField(
        choices=DEGREES
    )
    beach = models.ForeignKey(
        BEACH, on_delete=models.CASCADE, null=False
    )
    reading_increment = models.ForeignKey(
        READING_INCREMENT, on_delete=models.CASCADE, null=False
    )

class BUOY_READING(models.Model):
    buoy_reading_id = models.AutoField(primary_key=True)
    name = models.CharField(max_length=45)
    sig_wave_height = models.FloatField()
    peack_period = models.IntegerField()
    mean_wave_direction_degree = models.IntegerField(
        choices=DEGREES
    )
    beach = models.ManyToManyField(
        BEACH,
        through='BEACH_BUOYS',
        through_fields=('buoy_reading', 'beach')
    )
    
class BEACH_BUOYS(models.Model):
    buoy_reading = models.ForeignKey(
        BUOY_READING,
        on_delete=models.PROTECT,
    )
    beach = models.ForeignKey(
        BEACH,
        on_delete=models.PROTECT,
    )
    
class SWELL(models.Model):
    swell_id = models.AutoField(primary_key=True)
    height = models.FloatField()
    period = models.IntegerField()
    direction = models.CharField(
        max_length=3,
        choices=COMPASS_DIRS
    )
    degree = models.IntegerField(
        choices=DEGREES
    )
    growth_direction = models.IntegerField(
        choices=GROWTH_DIRECTIONS
    )
    beach = models.ForeignKey(
        BEACH, on_delete=models.CASCADE, null=False
    )
    reading_increment = models.ForeignKey(
        READING_INCREMENT, on_delete=models.CASCADE, null=False
    )
    buoy_reading = models.ForeignKey(
        BUOY_READING, on_delete=models.SET_NULL, null=True
    )
    
class WEATHER(models.Model):
    weather_id = models.AutoField(primary_key=True)
    temperature = models.IntegerField()
    sky_condition = models.CharField(max_length=15)
    beach = models.ForeignKey(
        BEACH, on_delete=models.CASCADE, null=False
    )
    reading_increment = models.ForeignKey(
        READING_INCREMENT, on_delete=models.CASCADE, null=False
    )
    
class TIDE(models.Model):
    tide_id = models.AutoField(primary_key=True)
    height = models.FloatField()
    label = models.CharField(max_length=10)
    growth_direction = models.IntegerField(
        choices=GROWTH_DIRECTIONS
    )
    beach = models.ForeignKey(
        BEACH, on_delete=models.CASCADE, null=False
    )
    reading_increment = models.ForeignKey(
        READING_INCREMENT, on_delete=models.CASCADE, null=False
    )


    
    

    