#include "ESP8266WiFi.h"
#include "ESP8266WebServer.h"
#include "ArduinoJson.h"
#include <OneWire.h>
#include <DallasTemperature.h>
 
ESP8266WebServer server(80);

// GPIO where the DS18B20 is connected to
const int oneWireBus = 4;     

// Setup a oneWire instance to communicate with any OneWire devices
OneWire oneWire(oneWireBus);

// Pass our oneWire reference to Dallas Temperature sensor 
DallasTemperature sensors(&oneWire);
 
void setup() {
 
  Serial.begin(115200);
  WiFi.begin("<Wifi-Name>", "<Wifi_password>");  //Connect to the WiFi network
 
  while (WiFi.status() != WL_CONNECTED) {  //Wait for connection
 
    delay(500);
    Serial.println("Waiting to connect…");
 
  }
 
  Serial.print("IP address: ");
  Serial.println(WiFi.localIP());  //Print the local IP
 
  server.on("/", handleRootPath);    //Associate the handler function to the path
  server.on("/temp", handleTemp);
  server.begin();                    //Start the server
  Serial.println("Server listening");

  sensors.begin();
 
}
 
void loop() {
 
  server.handleClient();         //Handling of incoming requests
 
}
 
void handleRootPath() {            //Handler for the rooth path
 
  server.send(200, "text/plain", "Hello world");
 
}

void handleTemp() {
  sensors.requestTemperatures(); 
  float temperatureC = sensors.getTempCByIndex(0);
  // allocate the memory for the document
  const size_t CAPACITY = JSON_OBJECT_SIZE(2);
  StaticJsonDocument<CAPACITY> doc;

// create an object
  JsonObject object = doc.to<JsonObject>();
  object["sensor"] = "temp";
  object["data"] = temperatureC;
  String res;
  serializeJsonPretty(object, res);
  server.send(200, "text/json", res);
}
