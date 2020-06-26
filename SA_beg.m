clc; close all; clear all;
h = visa('agilent','TCPIP::10.50.252.70::INSTR');  % check IP address!!!
h.inputbuffersize = 1000000;
fopen(h);
fprintf(h, 'FREQ:STAR 0.5MHz');    % set start frequency
fprintf(h, 'FREQ:STOP 5MHz');    % set stop frequency
fprintf(h, 'BAND:RES 100kHz;VID 1kHz');    % set video bandwidth to 1 kHz
                                    % set resolution bandwidth to 100 kHz  
 fprintf(h, 'SWE:POIN 10001');   % set number of points to 10001
%fprintf(h,'FORM ASCII');
pause(10)
fprintf(h,'TRAC? TRACE1');
tr = fscanf(h);
fclose(h);
trace = str2num(tr);
freq = linspace(0.5e6, 5e6, 501);    % produce frequency axis
plot(freq, trace);

xlabel('Frequency [Hz]');
ylabel('Magnitude [dB]');
title('Video BW=1kHz, Res BW=100kHz');