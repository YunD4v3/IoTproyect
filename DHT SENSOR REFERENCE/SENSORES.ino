#include <DHT.h>
#define DHTTYPE DHT11
#define DHTPIN 8


DHT dht(DHTPIN, DHTTYPE);

void setup() {
  Serial.begin(115200);
  dht.begin();
}

void loop() {

  float humidity = dht.readHumidity();
  float temperature = dht.readTemperature();
  
  Serial.print("Humidity: ");
  Serial.print(humidity);
  Serial.print("% Temperature: ");
  Serial.print(temperature);
  Serial.println("°C" );
  delay(2500);
}
