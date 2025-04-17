% % EECS 1011 MD FAIAZ APRIL 17 2025

%Create Arduono variable 
clear all; close all;
arduino = arduino('COM3' , 'uno'); 

%Create state counters 
dryCounter = 0;
littleWetCounter = 0; 
wetCounter = 0;

%Create plot 
figure
h = animatedline;
ax = gca;
ax.YGrid = 'on';
ax.YLim = [2 , 4];
title('Soil Voltage over time');
ylabel('Voltage (Volts)');
xlabel('Time (HH:MM:SS)');

startTime = datetime('now');

% Set stop to false so the loop can run
stop = false;

%Loop until button is pushed 
while stop == false
    
    %Get the voltage of the soil
    voltage = round(readVoltage(arduino , 'A0'), 1);
    
    % Get current time
    t = datetime('now') - startTime;
    
    % Add points to animation
    addpoints(h,datenum(t),voltage)
    
    % Update axes
    datetick('x','keeplimits')
    drawnow
    
    %Check level of voltage and water acordingly 
    if (voltage >= 3.2)
        disp("Soil State: dry") 
        
        %State counter up 1
        dryCounter = dryCounter+1;
        
        %Water for 2 seconds, wait for water to set 
        writeDigitalPin(arduino, 'D2' , 1);
        pause (2);
        writeDigitalPin(arduino, 'D2' , 0); 
        pause(3); 
        
    elseif (voltage > 2.7) 
        disp("Soil State: a little wet")
        
        %State counter up 1
        littleWetCounter = littleWetCounter+1;
       
        %Water for 1 seconds, wait for water to set 
        writeDigitalPin(arduino, 'D2' , 1);
        pause (1);
        writeDigitalPin(arduino, 'D2' , 0); 
        pause(4)
        
    elseif (voltage <= 2.7) 
        disp("Soil State: sufficiantly wet")
        
        %State counter up 1
        wetCounter = wetCounter + 1; 
        
        %Wait so the water can set in 
        pause (5)
    end
    
    stop = readDigitalPin(arduino,'D6');
end

%Display how many times soil was in each state 
disp("soil was in dry state " + dryCounter + " times."); 
disp("soil was in a little wet state " + littleWetCounter + " times.");  
disp("soil was in wet state " + wetCounter + " times.");     
