# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.contrib import admin

from .models import (
    SURFER, ANNOTATION, READING_INCREMENT, BEACH, REGION, LIGHTING, BEACH_BUOYS,
    WIND, SWELL, BUOY_READING, WEATHER, TIDE, WETSUIT, SURFLINE_REPORT
)

# Register your models here.
admin.site.register(SURFER)
admin.site.register(ANNOTATION)
admin.site.register(READING_INCREMENT)
admin.site.register(BEACH)
admin.site.register(REGION)
admin.site.register(LIGHTING)
admin.site.register(WIND)
admin.site.register(SWELL)
admin.site.register(BUOY_READING)
admin.site.register(WEATHER)
admin.site.register(TIDE)
admin.site.register(WETSUIT)
admin.site.register(SURFLINE_REPORT)
admin.site.register(BEACH_BUOYS)