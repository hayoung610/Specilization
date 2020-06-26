%% Controlling Network Analyzer remotly by MATLAB

clc; clear all; close all;
test_obj=visa('agilent','TCPIP0::169.254.58.10::gpib0,2::INSTR'); % check IP address
set(test_obj,'InputBufferSize', 100000);
fopen(test_obj);
fprintf(test_obj, '*IDN?');
fscanf(test_obj);
fprintf(test_obj,'INST:SEL CHANNEL1'); % select channel 1
fprintf(test_obj,'SENS:FREQ:STAR 100kHz');   % set start frequency
fprintf(test_obj,'SENS:FREQ:STOP 30MHz');    % set stop frequency
fprintf(test_obj,'SENS:SWE:POIN 801');    % set number of points <= 801 (NA limit <= 2001)
fprintf(test_obj,'FREQ:MODE SWEEP');
fprintf(test_obj,'SENSe:SWEep:SPACing LOG');     % set log sweep
fprintf(test_obj,'CALC:FORM COMP');     % set format complex (Smith chart)
fprintf(test_obj,'INIT:CONT ON');    % turn off continuous mode
fprintf(test_obj,'INIT:IMM; *WAI') ; % wait command
fprintf(test_obj,'TRAC? CH1DATA') ;   % read data of channel 1
s = fscanf(test_obj) ;
data_points = str2num(s) ;
fclose(test_obj) ;
re = data_points(1:2:1602);
im = data_points(2:2:1602);
plot(re,im);
fid = fopen('cableopen.txt','w');
fprintf(fid,'%f',data_points);
fclose(fid);
