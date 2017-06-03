clear all;

s1 = serial('/dev/ttyUSB0');                            %define serial port
s1.BaudRate=9600; %define baud rate

fopen(s1);                                      %open serial port

%%%%%%%%%%%%%%%%%

t = 1:30;

data=fread(s1);
fclose(s1);                                     %close serial port

data = data';
 
for i= 1:30 
    data(i) = data(1);
end

%%%%%%%%%%%%%%%%%

plot(t, data);                                     %plot 100 points
title('DTH11 Temperature Sensor');
xlabel('number of points');
ylabel('Temperature oC');
axis([0 60 10 40]);

%%%%%%%%%%%%%%%%%

fileID = fopen('log.txt','w');
fprintf(fileID,'Temprature Data\n');
fprintf(fileID,'------------------\n');
fprintf(fileID,data);


 
