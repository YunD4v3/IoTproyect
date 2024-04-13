clc
clear all

% Configuración del puerto serial
s = serialport("COM3", 115200);
configureTerminator(s, "LF");

% ThingSpeak API Key y ID de canal
writeApiKey = 'JTH9RKQ0XUEPPCQ6'; % Reemplazar con tu API Key
channelID = 2498670; % Reemplazar con tu ID de Canal

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
    
    % Mostrar los datos
    disp(data);
    
    % Convertir los datos a números
    dustDensity = str2double(data);
    
    % Enviar los datos a ThingSpeak
    try
        thingSpeakWrite(channelID, dustDensity, 'WriteKey', writeApiKey);
        disp("Datos enviados a ThingSpeak");
    catch
        disp("Error al enviar datos a ThingSpeak");
        continue;
    end
    
    % Obtener el tiempo transcurrido
    t = toc;
end

% Cerrar el puerto serial
clear s;
