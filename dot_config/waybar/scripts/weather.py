#!/usr/bin/env python

from pyquery import PyQuery  # install using `pip install pyquery`
import json
import re

# weather icons
weather_icons = {
    "sunnyDay": "",
    "clearNight": "",
    "cloudyFoggyDay": "󰖐",
    "cloudyFoggyNight": "",
    "rainyDay": "",
    "rainyNight": "",
    "snowyIcyDay": "",
    "snowyIcyNight": "",
    "severe": "",
    "default": "",
}

# get location_id
# to get your own location_id, go to https://weather.com & search your location.
# once you choose your location, you can see the location_id in the URL(64 chars long hex string)
# like this: https://weather.com/en-IN/weather/today/l/c3e96d6cc4965fc54f88296b54449571c4107c73b9638c16aafc83575b4ddf2e
location_id = "d039a0ceb803979609657cbf6215cba767861bf4ac76ab2a09f2c0c9d1d9d08c"  # TODO
# location_id = "8139363e05edb302e2d8be35101e400084eadcecdfce5507e77d832ac0fa57ae"

# priv_env_cmd = 'cat $PRIV_ENV_FILE | grep weather_location | cut -d "=" -f 2'
# location_id = subprocess.run(
#     priv_env_cmd, shell=True, capture_output=True).stdout.decode('utf8').strip()

# get html page
url = "https://weather.com/en-IN/weather/today/l/" + location_id
html_data = PyQuery(url=url)

# current temperature
temp = html_data("span[data-testid='TemperatureValue']").eq(0).text()
temp = re.sub("°", "", temp)
# temp = round(float(temp))

# print(temp)
# current status phrase
status = html_data("div[data-testid='wxPhrase']").text()
status = f"{status[:16]}.." if len(status) > 17 else status
# print(status)

# status code
status_code = html_data("#regionHeader").attr("class").split(" ")[2].split("-")[2]
# print(status_code)

# status icon
icon = (
    weather_icons[status_code]
    if status_code in weather_icons
    else weather_icons["default"]
)
# print(icon)

# print waybar module data
out_data = {
    "text": f"{icon} {temp}°C",
    "alt": status,
    "class": status_code,
}
print(json.dumps(out_data))
