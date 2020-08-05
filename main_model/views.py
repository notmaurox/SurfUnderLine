# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.http import HttpResponse, HttpResponseRedirect
from django.template import loader
from django.shortcuts import render

from .forms import ReportSurfSession

from .models import (
    SURFER, ANNOTATION, READING_INCREMENT, BEACH, REGION, LIGHTING,
    WIND, SWELL, BUOY_READING, WEATHER, TIDE
)

# Create your views here.
def report_surf_session(request):
    # if this is a POST request we need to process the form data
    if request.method == 'POST':
        # create a form instance and populate it with data from the request:
        form = ReportSurfSession(request.POST)
        # check whether it's valid:
        if form.is_valid():
            # process the data in form.cleaned_data as required
            # ...
            # redirect to a new URL:
            return HttpResponseRedirect('../templates/thanks.html')

    # if a GET (or any other method) we'll create a blank form
    else:
        form = ReportSurfSession()

    return render(
        request,
        '../templates/report_surf_session.html',
        {'form': form}
    )