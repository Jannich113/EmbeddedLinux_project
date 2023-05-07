#include <ESP8266WiFi.h>
#include <PubSubClient.h>

// Embedded Linux (EMLI)
// University of Southern Denmark
// ESP8266 Wifi client - Webserver - User interface 
// Kjeld Jensen <kjen@sdu.dk> <kj@kjen.dk>
// 2023-04-18, KJ, First version
// inspired by https://docs.arduino.cc/tutorials/uno-wifi-rev2/uno-wifi-r2-hosting-a-webserver

// LED
#define PIN_LED_RED     14
#define PIN_LED_YELLOW  13
#define PIN_LED_GREEN   12

// button
#define PIN_BUTTON      4
#define DEBOUNCE_TIME 200 // milliseconds
volatile int button_a_count;
volatile unsigned long count_prev_time;


// MQTT broker credentials 
const char* MQTT_username = "pi";
const char* MQTT_password = "burgerking";

// RPI pi IP address
const char*  mqtt_server = "192.168.10.1";

// init espCLient
WiFiClient espClient;
PubSubClient client(espClient);



// Wifi
const char* WIFI_SSID = "McWifi";
const char* WIFI_PASSWORD = "burgerking";

// Static IP address
//IPAddress IPaddress(192, 168, 0, 222);
//IPAddress gateway(192, 168, 0, 1);
//IPAddress subnet(255, 255, 255, 0);
//IPAddress primaryDNS(1, 1, 1, 1); 
//IPAddress secondaryDNS(8, 8, 8, 8); 

// Webserver
//#define CLIENT_TIMEOUT 2000

//WiFiServer server(80);
//WiFiClient client = server.available();
//unsigned long clientConnectTime = 0;
//String currentLine = "";
//char response_s[10];
//char s[25];

ICACHE_RAM_ATTR void button_a_isr()
{
  if (millis() - count_prev_time > DEBOUNCE_TIME)
  {
    count_prev_time = millis();
    button_a_count++;
  }
}


void callback(String topic, byte* message, unsigned int length) {
  Serial.print("Message arrived on topic: ");
  Serial.print(topic);
  Serial.print(". Message: ");
  String messageTemp;
  
  for (int i = 0; i < length; i++) {
    Serial.print((char)message[i]);
    messageTemp += (char)message[i];
  }
  Serial.println();

  // If a message is received on the topic room/lamp, you check if the message is either on or off. Turns the lamp GPIO according to the message
  if(topic=="testTopic"){
      Serial.print("Changing Room lamp to ");
      if(messageTemp == "on"){
        digitalWrite(LED_BUILTIN, HIGH);
        Serial.print("On");
      }
      else if(messageTemp == "off"){
        digitalWrite(LED_BUILTIN, LOW);
        Serial.print("Off");
      }
  }
  else if(topic="remote/led/red"){
      Serial.print("Changing red led to ");
      if(messageTemp == "on"){
        digitalWrite(PIN_LED_RED, HIGH);
        Serial.print("On");
      }
      else if(messageTemp == "off"){
        digitalWrite(PIN_LED_RED, LOW);
        Serial.print("Off");
      }
  }
  else if(topic="remote/led/green"){
      Serial.print("Changing green led to ");
      if(messageTemp == "on"){
        digitalWrite(PIN_LED_GREEN, HIGH);
        Serial.print("On");
      }
      else if(messageTemp == "off"){
        digitalWrite(PIN_LED_GREEN, LOW);
        Serial.print("Off");
      }
  }
  else if(topic="remote/led/yellow"){
      Serial.print("Changing red led to ");
      if(messageTemp == "on"){
        digitalWrite(PIN_LED_YELLOW, HIGH);
        Serial.print("On");
      }
      else if(messageTemp == "off"){
        digitalWrite(PIN_LED_YELLOW, LOW);
        Serial.print("Off");
      }
  } 
  Serial.println();
}




void setup()
{
  // serial
  Serial.begin(115200);
  delay(10);

  
  // LEDs
  pinMode(LED_BUILTIN, OUTPUT);
  digitalWrite(LED_BUILTIN, LOW);
  pinMode(PIN_LED_RED, OUTPUT);
  digitalWrite(PIN_LED_RED, HIGH);
  pinMode(PIN_LED_YELLOW, OUTPUT);
  digitalWrite(PIN_LED_YELLOW, HIGH);
  pinMode(PIN_LED_GREEN, OUTPUT);
  digitalWrite(PIN_LED_GREEN, HIGH);

  // button
  pinMode(PIN_BUTTON, INPUT_PULLUP);
  attachInterrupt(digitalPinToInterrupt(PIN_BUTTON), button_a_isr, RISING);

  // set the ESP8266 to be a WiFi-client
  //WiFi.mode(WIFI_STA); 
  
  // configure static IP address
  //WiFi.config(IPaddress, gateway, subnet);
  //WiFi.config(IPaddress, gateway, subnet, primaryDNS, secondaryDNS);

  // connect to Wifi access point
  Serial.println();
  Serial.println();
  Serial.print("Connecting to ");
  Serial.println(WIFI_SSID);

  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  while (WiFi.status() != WL_CONNECTED)
  {
    delay(500);
    Serial.print(".");
  }
  digitalWrite(LED_BUILTIN, HIGH);
  Serial.println("");
  Serial.println("WiFi connected");
  Serial.println("IP address: ");
  Serial.println(WiFi.localIP());
  Serial.println("");

  // start webserver
  //Serial.println("Starting webserver");
  //Serial.println("");
  //server.begin();

  client.setServer(mqtt_server, 1883);
  client.setCallback(callback);
  
}


// 

// https://randomnerdtutorials.com/esp8266-and-node-red-with-mqtt/

// reconnect to the MQTT broker
void reconnect() {
  // Loop until we're reconnected
  while (!client.connected()) {
    Serial.print("Attempting MQTT connection...");
    // Attempt to connect
    if (client.connect("ESP8266Client", MQTT_username, MQTT_password)) {
      Serial.println("connected");  
      // Subscribe or resubscribe to a topic
      // You can subscribe to more topics (to control more LEDs in this example)
      //client.setCallback(callback);
      client.subscribe("testTopic");
      client.subscribe("remote/led/red");
      client.subscribe("remote/led/green");
      client.subscribe("remote/led/yellow");
    } else {
      Serial.print("failed, rc=");
      Serial.print(client.state());
      Serial.println(" try again in 5 seconds");
      // Wait 5 seconds before retrying
      delay(5000);
    }
  }
}





void loop()
{
  if (!client.connected()){
    reconnect();
  }

  if(!client.loop())
    client.connect("ESP8266Client", MQTT_username, MQTT_password);

 
  // publish every 5 sec
  delay(5000);
  client.publish("testTopic", String(4).c_str());
   
}
