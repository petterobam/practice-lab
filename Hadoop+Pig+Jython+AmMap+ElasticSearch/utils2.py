# -*- coding:utf-8 -*-
import sys
sys.path.append('/Users/ouyangjie/Library/Python/3.7/lib/python/site-packages')
sys.path.append('/Library/Frameworks/Python.framework/Versions/3.7/lib/python3.7/site-packages')
import geoip2.database
reader = geoip2.database.Reader('database/GeoLite2-City.mmdb')

@outputSchema('city:chararray')
def get_city(ip):
    try:
        response = reader.city(ip)
        return response.city.name
    except:
        pass


@outputSchema('country:chararray')
def get_country(ip):
    try:
        response = reader.city(ip)
        return response.country.name
    except:
        pass

@outputSchema('location:chararray')
def get_geo(ip):
    try:
        response = reader.city(ip)
        location = response.location
        geo = str(location.longitude) + "," + str(location.latitude)
        return geo
    except:
        pass