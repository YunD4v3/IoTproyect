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
    
    % Limpiar la cadena de datos
    cleanedData = strrep(data, 'red=', ''); % Eliminar "red="
    cleanedData = strrep(cleanedData, ' ir=', ', '); % Reemplazar " ir=" por ","
    cleanedData = strrep(cleanedData, ' HR=', ', '); % Reemplazar " HR=" por ","
    cleanedData = strrep(cleanedData, ' HRvalid=', ', '); % Reemplazar " HRvalid=" por ","
    cleanedData = strrep(cleanedData, ' SPO2=', ', '); % Reemplazar " SPO2=" por ","
    cleanedData = strrep(cleanedData, ' SPO2Valid=', ''); % Eliminar " SPO2Valid="
    
    % Mostrar los datos limpios
    disp(cleanedData);
    
    % Dividir los datos en valores individuales
    values = regexp(cleanedData, ',', 'split');
    
    % Verificar si se leyeron suficientes valores
    if length(values) < 6
        disp("Error: No se leyeron suficientes valores");
        continue;
    end
    
    % Convertir los valores a números
    red = str2double(values{1});
    ir = str2double(values{2});
    HR = str2double(values{3});
    HRvalid = str2double(values{4});
    SPO2 = str2double(values{5});
    SPO2Valid = str2double(values{6});
    
    % Enviar los datos a ThingSpeak
    try
        thingSpeakWrite(channelID, [red, ir, HR, HRvalid, SPO2, SPO2Valid], 'WriteKey', writeApiKey);
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
