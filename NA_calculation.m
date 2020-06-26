clear all; close all;
%Import data
tem1 = importdata('bal_open.txt',';',1);
tem11 = tem1.data;
freq = tem11(:,1); %frequency
bal_open_res11 = tem11(:,2);
bal_open_ims11 = tem11(:,3);

tem2 = importdata('bal_short.txt',';',1);
tem12 = tem2.data;
bal_short_res11 = tem12(:,2);
bal_short_ims11 = tem12(:,3);

tem3 = importdata('bal_term.txt',';',1);
tem13 = tem3.data;
bal_term_res11 = tem13(:,2);
bal_term_ims11 = tem13(:,3);

tem4 = importdata('cabopen.txt',';',1);
tem14 = tem4.data;
tel_open_res11 = tem14(:,2);
tel_open_ims11 = tem14(:,3);

tem5 = importdata('cabshort.txt',';',1);
tem15 = tem5.data;
tel_short_res11 = tem15(:,2);
tel_short_ims11 = tem15(:,3);
%%
%Represent BAL, TEL data in complex
B_open = bal_open_res11+1i*bal_open_ims11; %Bal open
B_short = bal_short_res11+1i*bal_short_ims11; %Bal short
B_term = bal_term_res11+1i*bal_term_ims11; %Bal term
T_open = tel_open_res11+1i*tel_open_ims11; %Tel open
T_short = tel_short_res11+1i*tel_short_ims11; %Tel short

%Calculate BAL open, short, temi impedence
Z_o = 50.*(1.-B_open)./(1.+B_open); %Bal Impedence open
Z_s = 50.*(1.-B_short)./(1.+B_short); %Bal Impedence short
Z_t = 50.*(1.-B_term)./(1.+B_term); %Bal Impedence termi

%Calculate ABCD matrix 
A = Z_o.*sqrt((Z_s - Z_t)./(50.*(Z_t-Z_o).*(Z_o-Z_s)));
B = Z_s.*sqrt(50.*(Z_t - Z_o)./((Z_s-Z_t).*(Z_o-Z_s)));
C = sqrt((Z_s - Z_t)./(50.*(Z_t-Z_o).*(Z_o-Z_s)));
D = sqrt(50.*(Z_t - Z_o)./((Z_s-Z_t).*(Z_o-Z_s)));

%Calculate Tel open, short impedence
Zt_o = 50.*(1.-T_open)./(1.+T_open); %Tel Impedence open
Zt_s = 50.*(1.-T_short)./(1.+T_short); %Tel Impedence short

%Calculate actual impedence
Zta_o = (B-D.*Zt_o)./(C.*Zt_o-A);
Zta_s = (B-D.*Zt_s)./(C.*Zt_s-A);

%Get Cable properties, Zw, Secondary line parameter(gamma)
Zw = sqrt(Zta_o .*Zta_s);
m_Zw = abs(Zw); %Magnitude Zw
p_Zw = angle(Zw); %Phase Zw
g = atanh(sqrt(Zta_s./Zta_o)); %gamma = alpha+jbetha
alp=real(g); %alpha
bet=imag(g); %betha

%Plot graph
figure(1);
semilogx(freq, m_Zw);
grid on; xlim([9e3,1e8]); title('Amplitude Zw');

figure(2);
semilogx(freq, p_Zw);
grid on; xlim([9e3,1e8]); title('Phase Zw');
 
figure(3);
semilogx(freq, alp);
grid on; xlim([9e3,1e8]); title('Alpha');

figure(4);
semilogx(freq, bet);
grid on; xlim([9e3,1e8]); title('Beta');