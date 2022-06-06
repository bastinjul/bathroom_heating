# Bathroom Heating

Application to manage the heating in my bathroom.

## System description

Here is a diagram of the whole system :

![](./images/bathroom_heating_system_schema.svg)

### Bathroom

#### Heating
In my bathroom is installed a electric heater. This electric heater is plugged into a smartplug ([TP-Link HS100](https://www.tp-link.com/fr-be/home-networking/smart-plug/hs100/)).
This smartplug can be controlled via wifi to be turned on or off.

#### Temperature sensor
I also installed an IOT device ([ESP8266](https://www.amazon.fr/AZDelivery-NodeMCU-ESP8266-d%C3%A9veloppement-development/dp/B06Y1ZPNMS/ref=sr_1_1?keywords=arduino+esp8266&qid=1652100283&sr=8-1)) with a temperature sensor ([LM35](https://www.engineersgarage.com/lm35-description-and-working-principal/#:~:text=LM35%20is%20a%20temperature%20sensor,not%20require%20any%20external%20calibration.)) exposing a REST API that gives the temperature of the room.

The code of this device can be found in the [temperature_sensor](./temperature_sensor/) directory and is based on this article : https://www.instructables.com/IoT-Temperature-Sensor-With-ESP8266/.

### Raspberry PI
On the other hand, I have a Raspberry Pi 3B+ running 24/7. It runs 3 Docker containers responsible of communicating with the smartplug and the IOT temperature sensor.

#### Communication with the smartplug
The module [plug_communication](./plug_communication/) uses the python library [tplink-smartplug-api](https://github.com/vrachieru/tplink-smartplug-api) to communicate with the smartplug. It exposes a REST API that allows the [home_automation](./home_automation/) module to turn the plug on or off and retrieve its status.

#### Web interface + system intelligence
The module [home_automation](./home_automation/) is an [elixir](http://elixir-lang.org/) [phoenix](https://www.phoenixframework.org/) [liveview](https://hexdocs.pm/phoenix_live_view/Phoenix.LiveView.html#module-guides) application. It contains the entire application intelligence discussed in the [next section](#desired-features).

It also communicates with the temperature sensor by calling its REST API.

## <a id="desired-features">Desired features</a>

### Minimal features
* An interface where I can see the actual temperature with a live refresh
* An interface where I can see the actual status of the smartplug, and where I'm able to turn it on or off
* An interface where I can configure the behaviour of the automatic heating day by day of the bathroom.
    * I can configure the desired temperature
        * Once this temperature is reached, the heater should be turn off to save energy
    * I can set the time I get up (so the time I shower) for the whole week
        * I can disable the heating for certain days
        * Regarding this hour, the heating starts 1h30 before so that the room is at the desired temperature when I get up

### Advanced features
* From the weather data and the previous data, calculate the time at which the heating must be turned on to obtain the desired temperature at the time of rising.

## Deployment

### Mock

If you are not able to work with a plug and a temperature sensor, you can use simple mocks. The [mock](./mock/) directory contains two mocks, respectively to mock the temperature sensor and to mock the [plug_communication](./plug_communication/).

In order to use these mock, you need to specify as environment variable the file [mock.env](./mock.env). To do so, just specify it when starting the application with docker-compose : `docker-compose --env-file mock.env up -d`
