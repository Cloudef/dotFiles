#!/usr/bin/python2 -o
# -*- coding: utf-8 -*-

from urllib import urlopen, quote
from xml.etree.cElementTree import parse
from datetime import datetime, timedelta
import os
from os.path import join
from sys import argv
try:
    import cPickle as pickle
except ImportError:
    import pickle


TRANSLATED_TEXT = {
    'en': {
        'current': 'Current conditions',
        'weather': 'Weather',
        'temp': 'Temperature',
        'humidity': 'Humidity',
        'wind': 'Wind',
        'forecast': 'Forecast',
        'mintemp': 'Minimum Temperature',
        'maxtemp': 'Maximum Temperature'
    },
    'fi': {
        'current': u'Nykyinen Tila',
        'weather': u'Sää',
        'temp': u'Lämpötila',
        'wind': u'Tuuli',
        'forecast': u'Ennustus',
        'mintemp': u'Minimi lampötila',
        'maxtemp': u'Maximi lampötila'
    },
    'sv': {
        'current': u'Aktuell prognos',
        'weather': u'Väder',
        'temp': u'Temperatur',
        'forecast': u'Prognos',
        'mintemp': u'Lägsta temperatur',
        'maxtemp': u'Högsta temperatur'
    },
    'es': {
        'current': u'Actualmente',
        'weather': u'Tiempo',
        'temp': u'Temperatura',
        'humidity': u'Humedad',
        'wind': u'Viento',
        'forecast': u'Previsión',
        'mintemp': u'Temperatura Mínima',
        'maxtemp': u'Temperatura Máxima'
    },
    'fr': {
        'current': u'Actuel',
        'weather': u'Météo',
        'temp': u'Température',
        'humidity': u'Humidité',
        'wind': u'Vent',
        'forecast': u'Prévision',
        'mintemp': u'Température minimale',
        'maxtemp': u'Température maximale'
    },
    'de': {
        'current': u'Aktuell',
        'weather': u'Wetter',
        'temp': u'Temperatur',
        'humidity': u'Luftfeuchtigkeit',
        'wind': u'Wind',
        'forecast': u'Prognostizieren',
        'mintemp': u'Minimale Temperatur',
        'maxtemp': u'Höchste Temperatur'
    }
}


if len(argv) != 3:
    raise Exception('Usage: gweather2.py city language.')
else:
    city = argv[1]
    lang = argv[2]



CACHE_HOURS = 1

WEATHER_URL = 'http://www.google.fi/ig/api?weather=%s&hl=%s&oe=UTF-8'

def get_weather(city, lang):
    url = WEATHER_URL % (quote(city), quote(lang))
    data = parse(urlopen(url))
    
    forecasts = []
    for forecast in data.findall('weather/forecast_conditions'):
        forecasts.append(
    dict([(element.tag, element.get("data")) for element in forecast.getchildren()]))
    
    return {
        'forecast_information': dict([(element.tag, element.get("data")) for element in data.find('weather/forecast_information').getchildren()]),
        'current_conditions': dict([(element.tag, element.get("data")) for element in data.find('weather/current_conditions').getchildren()]),
        'forecasts': forecasts
    }

def get_openbox_pipe_menu(lang, forecast_information, current_conditions, forecasts):
    if lang == 'en-US':
        lang = 'en'
#this solves the English language SI units problem
    if lang == 'en-GB':
        lang = 'en'
    tt = TRANSLATED_TEXT[lang]
    
    temp_var, temp_unit = ("temp_c", u"\u00b0C") if forecast_information['unit_system'] == "SI" else ("temp_f", "F")
    
    output =  '<openbox_pipe_menu>'
    output += '\n<separator label="%s (%s)" />' % (weather['forecast_information']['city'],forecast_information['current_date_time'])
    output += '\n<separator label="%s" />' % tt['current']
    output += '<item label="%s: %s" />' % ( tt['weather'], current_conditions['condition'])
    output += '<item label="%s: %s %s" />' % (tt['temp'], current_conditions[temp_var], temp_unit)
    output += '<item label="%s" />' % (current_conditions['humidity'])
    output += '<item label="%s" />' % (current_conditions['wind_condition'])
    for forecast in forecasts:
        output += '\n<separator label="%s: %s" />' % (tt['forecast'], forecast['day_of_week'])
        output += '<item label="%s: %s" />' % (tt['weather'], forecast['condition'])
        output += '<item label="%s: %s %s" />' % ( tt['mintemp'], forecast['low'], temp_unit )
        output += '<item label="%s: %s %s" />' % ( tt['maxtemp'], forecast['high'], temp_unit )
    output += '\n</openbox_pipe_menu>'
    
    return output.encode('utf-8')

cache_file = join(os.getenv("HOME"), '.gweather.cache')

try:
    f = open(cache_file,'rb')
    cache = pickle.load(f)
    f.close()
except IOError:
    cache = None

if cache == None or (city, lang) not in cache or (
        cache[(city, lang)]['date'] + timedelta(hours=CACHE_HOURS) < datetime.utcnow()):
    # The cache is outdated
    weather = get_weather(city, lang)
    ob_pipe_menu = get_openbox_pipe_menu(lang, **weather)
    print ob_pipe_menu
    if cache == None:
        cache = dict()
    cache[(city, lang)] = {'date': datetime.utcnow(), 'ob_pipe_menu': ob_pipe_menu}
    
    #Save the data in the cache
    try:
        f = open(cache_file, 'wb')
        cache = pickle.dump(cache, f, -1)
        f.close()
    except IOError:
        raise
else:
    print cache[(city, lang)]['ob_pipe_menu']