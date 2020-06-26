%Establish Connection
DSO = actxcontrol('LeCroy.ActiveDSOCtrl.1'); % Load ActiveDSO control
invoke(DSO,'MakeConnection','IP:10.50.217.111'); % Substitute your choice of IP address here
invoke(DSO,'WriteString','*IDN?',true); % Query the scope name and model number
ID=invoke(DSO,'ReadString',1000) % Read back the scope ID to verify connection

%Turn channels on
invoke(DSO,'WriteString','C1:TRA ON',true); % Turn channel 1 on
invoke(DSO,'WriteString','C2:TRA ON',true); % Turn channel 2 on

%Settings of the channels
invoke(DSO,'WriteString',' C1:VDIV 0.05',true); %Setting the vertical res. Ch1
invoke(DSO,'WriteString',' C2:VDIV 0.05',true); %Setting the vertical res. Ch2

%Time Resolution
invoke(DSO,'WriteString','C1:TDIV 50NS',true);  %Setting the time base - Ch1
invoke(DSO,'WriteString','C2:TDIV 50NS',true);  %Setting the time base - Ch2

%Triggering
invoke(DSO,'WriteString','C2:TRIG_SLOPE POS',true);  % Trigger on positive
invoke(DSO,'WriteString','C2:TRCP DC',true);% DC coupled
invoke(DSO,'WriteString','C2:TRLV 0.05 POS',true);%Trigger level
invoke(DSO,'WriteString','TRSE EDGE,SR,C2,HT,OFF',true);% Set trigger mode to SINGLE
%pause(5);
invoke(DSO,'WriteString','ARM;WAIT', true);

% % % TRANSFER WAVEFORM FROM SCOPE TO MATLAB
channel1data=invoke(DSO,'GetScaledWaveformWithTimes','C1',1000000,0); % Get Wavefrom Data - 1 Mpts is chosen as the arbitrary maximum file transfer file size (substitute your own max value to use)
channel1data=double(channel1data); % ActiveDSO transfers single precision matrix.  Need to convert to double to plot in Matlab.

% % % TRANSFER WAVEFORM FROM SCOPE TO MATLAB
channel2data=invoke(DSO,'GetScaledWaveformWithTimes','C2',1000000,0); % Get Wavefrom Data - 1 Mpts is chosen as the arbitrary maximum file transfer file size (substitute your own max value to use)
channel2data=double(channel2data); % ActiveDSO transfers single precision matrix.  Need to convert to double to plot in Matlab.

%Ch1
t_ch1=channel1data(1,:);
V_ch1=channel1data(2,:);

%Ch2
t_ch2=channel2data(1,:);
V_ch2=channel2data(2,:);

%Plot data from Channel 2

plot(t_ch2,V_ch2);
xlabel('Time [s]');
ylabel('Voltage [V]');
title('Channel 2');

%Plot data from Channel 1
figure;
plot(t_ch1,V_ch1);
xlabel('Time [s]');
ylabel('Voltage [V]');
title('Channel 1');

invoke(DSO,'Disconnect');