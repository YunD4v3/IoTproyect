clc
clear all
% Configuración del puerto serial
s = serialport("COM3", 115200);
configureTerminator(s, "LF");

% ThingSpeak API Key y ID de canal
writeApiKey = 'FG8FNRAO1YU9LS95';
channelID = 2498593;

% Tiempo total de lectura en segundos
tiempoTotal = 60;
t = 0;

tic;  % Iniciar temporizador

while t < tiempoTotal
    % Leer datos del puerto serial
    try
        data = readline(s);
    catch
        disp("Error al leer datos del puerto serial");
        continue;
    end
    
    % Limpiar la cadena de datos
    cleanedData = strrep(data, 'Â', '');  % Eliminar el símbolo "Â"
    
    % Mostrar los datos limpios
    disp(cleanedData);
    
    % Dividir los datos en humedad y temperatura
    C = split(cleanedData, {'Humidity:', 'Temperature:', '°C'});
    if length(C) < 4
        disp("Formato de datos incorrecto");
        continue;
    end
    humidity = str2double(C{2});
    temperature = str2double(C{4});
    
    % Enviar los datos a ThingSpeak
    try
        thingSpeakWrite(channelID, [humidity, temperature], 'WriteKey', writeApiKey);
        disp("Datos enviados a ThingSpeak");
    catch
        disp("Error al enviar datos a ThingSpeak");
        continue;
    end
    
    % Obtener el tiempo transcurrido
    t = toc;
    
    % Esperar un tiempo antes de la siguiente lectura
    pause(15);  % Pausa de 15 segundos entre envíos (limitación de ThingSpeak)
end

% Cerrar el puerto serial

clear s;
