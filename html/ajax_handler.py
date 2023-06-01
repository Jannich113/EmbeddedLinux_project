#!/usr/bin/env python
import subprocess

def handle_ajax_request(request):
    if request.method == "POST":
        subprocess.call(["python", "plant_data/plotting_data.py"])
        return "AJAX call succeeded."
    else:
        return "AJAX call failed."
