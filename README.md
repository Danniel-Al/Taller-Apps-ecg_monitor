# Monitor de Electrocardiografía
Aplicación móvil desarrollada en flutter para el monitoreo y análisis de señales ECG, utilizando un sensor AD8332 conectado a un ESP32 para mandar datos vía WiFi.

# Componentes
- AD8332 con derivación bipolar
- ESP32 
- Electrodos desechables

# Funcionamiento
El ad8332 capta la actividad eléctrica del corazón por los electrodos. Acto seguido el esp32 capta el valor por el pin 34, aplica un filtro de media de 8 muestras y transmite los datos vía WiFi por TCP en el puerto 8080. Por otro lado, la app de flutter detecta los picos del complejo QRS y calcula la frecuencia cardíaca. 

# equisitos:
- Flutter 3.x o superior
- Dispositivo Android (puede ser emulado)
- El dispositivo y el ESP32 deben estar en la misma red WiFi

# Setup:
1. Clonar repositorio: https://github.com/Danniel-Al/Taller-Apps-ecg_monitor.git
2. Correr en terminal "flutter pub get"
3. Actualizar datos de red wifi del esp32 y measuring_screen.dart
4. Correr app con "flutter run"

# Video de Funcionamiento App
https://canva.link/0xnbxyct0nw0we9

# Autores:
-Daniel Alfaro Aguilar: https://github.com/Danniel-Al
-Katia Torres Pérez: https://github.com/buttercup23202
-César Carrión Cedano: https://github.com/a01253256-debug