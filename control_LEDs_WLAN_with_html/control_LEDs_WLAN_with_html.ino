#include <FS.h>  // Include the SPIFFS library for ESP32/ESP8266

#ifdef ESP8266
#include <ESP8266WebServer.h>  // include ESP8266 library
ESP8266WebServer server;       // associate server with ESP8266 library
int LEDGpin = D7;              // define LED pins for ESP8266
int LEDRpin = D8;

#elif ESP32
#include <WebServer.h>  // include ESP32 library
WebServer server(80);  // associate server with ESP32 library (with port 80)
int LEDGpin = 26;      // define LED pins for ESP32
int LEDRpin = 25;

#else
#error "ESP8266 or ESP32 microcontroller required"
#endif

/* WLAN SSID and password */
char ssidAP[] = "ESP8266";
char passwordAP[] = "12345678";

/* pre-defined IP address values */
IPAddress local_ip(192, 168, 2, 1);
IPAddress gateway(192, 168, 2, 1);
IPAddress subnet(255, 255, 255, 0);

/* default LED states */
int LEDR = LOW;
int LEDG = LOW;

int counter = 0;

void setup() {
  Serial.begin(115200);  // Start serial communication for debugging
  SPIFFS.begin();        // Initialize SPIFFS

  WiFi.mode(WIFI_AP);  // Wi-Fi AP mode
  delay(1000);         // setup AP mode

  WiFi.softAP(ssidAP, passwordAP);               // initialise Wi-Fi with
  WiFi.softAPConfig(local_ip, gateway, subnet);  // predefined IP address

  server.begin();  // initialise server

  server.on("/", base);              // load default webpage
  server.on("/LEDGurl", LEDGfunct);  // map URLs to functions:
  server.on("/LEDRurl", LEDRfunct);  // LEDGfunct, LEDRfunct
  server.on("/zeroUrl", zeroFunct);  // and zeroFunct

  /* define LED pins as output */
  pinMode(LEDGpin, OUTPUT);
  pinMode(LEDRpin, OUTPUT);
}

void base() {
  // Serve the index.html file
  File file = SPIFFS.open("/index.html", "r");

  if (!file) {
    Serial.println("Failed to open index.html");
    server.send(404, "text/plain", "File Not Found");
    return;
  }

  server.streamFile(file, "text/html");
  
  file.close();
}

void LEDGfunct() {
  /* function to change green LED state, increment counter, and send HTML code to client*/
  LEDG = !LEDG;
  digitalWrite(LEDGpin, LEDG);
  counter++;
  server.send(200, "text/html", webcode(LEDG, LEDR, counter));
}

void zeroFunct() {
  /* function to zero counter and send HTML code to client */
  counter = 0;
  server.send(200, "text/html", webcode(LEDG, LEDR, counter));
}

void loop() {
  server.handleClient();  // manage HTTP requests
}

String webcode(int LEDG, int LEDR, int counter) {
  String page = "<!DOCTYPE html><html><head>";
  page += "<title>Local network</title>";
  // Add remaining web code here, or keep it in the separate index.html
  // Update with dynamic data (LED states, counter)
  return page;
}
