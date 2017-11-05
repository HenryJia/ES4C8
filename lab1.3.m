pkg load signal

r = 0.9; % pole radius
theta = pi/10; % pole angle
%coefficients of z in the TF
a = [1 0 0];
b = [1 -2*r*cos(theta) r*r];
%frequency response
Omega=0:pi/100:2*pi; %discrete frequency range
L = length(Omega);
H = zeros(L,1);
for k =1:L
expvec = exp(j*[2:-1:0]*Omega(k)); %current value for z=exp(j*Omega)
H(k) = sum(a.*expvec)./ sum(b.*expvec);
end
subplot(1,2,1); plot (Omega, abs(H)); grid on; %magnitude
set( gca , 'xlim' , [0 2*pi]); set( gca , 'xtick' , [0:4]*pi/2);
subplot(1,2,2); plot (Omega, angle(H)); grid on; %phase
set( gca, 'xlim', [0 2*pi]);set( gca,'xtick',[0:4]*pi/2);

r = 0.9; % pole radius
theta = pi/10;
a = [1 0 0];
b = [1 -2*r*cos(theta) r*r];
[H,Omega] = freqz(a,b,100, 'whole'); %only in the DSP System Toolbox
fs = 1000; %sampling frequency [Hz]
[H1,omega] = freqz(a,b,100, 'whole',fs);

figure(1)
subplot(1,2,1); plot (Omega, abs(H)); grid on; %magnitude
set( gca , 'xlim' , [0 2*pi]); set( gca , 'xtick' , [0:4]*pi/2);
subplot(1,2,2); plot (Omega, angle(H)); grid on; %phase
set( gca, 'xlim', [0 2*pi]);set( gca,'xtick',[0:4]*pi/2);

figure(2)
subplot(1,2,1); plot (omega, abs(H1)); grid on; %magnitude
set( gca , 'xlim' , [0 1000]); set( gca , 'xtick' , [0:4]*250);
subplot(1,2,2); plot (omega, angle(H1)); grid on; %phase
set( gca, 'xlim', [0 1000]);set( gca,'xtick',[0:4]*250);

