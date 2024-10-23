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

#include "buildpage.h"  // webpage HTML code

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

  WiFi.mode(WIFI_AP);  // Wi-Fi AP mode
  delay(1000);         // setup AP mode

  WiFi.softAP(ssidAP, passwordAP);               // initialise Wi-Fi with
  WiFi.softAPConfig(local_ip, gateway, subnet);  // predefined IP address

  IPAddress IP = WiFi.softAPIP();
  Serial.print("AP IP Address: ");
  Serial.println(IP);

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
  /* function to load default webpage and send HTML code to client*/
  server.send(200, "text.html", webcode(LEDG, LEDR, counter));
}

void LEDGfunct() {
  /* function to change green LED state, increment counter, and send HTML code to client*/
  LEDG = !LEDG;
  digitalWrite(LEDGpin, LEDG);
  counter++;
  server.send(200, "text/html", webcode(LEDG, LEDR, counter));
}

void LEDRfunct() {
  /* function to change green LED state, increment counter, and send HTML code to client*/
  LEDR = !LEDR;
  digitalWrite(LEDRpin, LEDR);
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