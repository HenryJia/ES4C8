omega = pi; %real frequency[rad/s]=>f=0.5[Hz], T=2[s]
t = [0:1/20:5]; %time length of signal[s], stepped in small increments
s = cos (omega*t); %‘continuous’ signal
subplot(2,2,1)
plot (t,s);
xlabel('time[s]'); ylabel('Amplitude'); title('Continuous signal');
grid on;
Ts = 0.2; %sampling period[s/sample]=>sampling frequency fs=5[Hz],T/Ts=10
n=[0:20*Ts:length(s)]; %sampling positions
x = s(n+1); %
subplot(2,2,2)
stem (x); %use ‘stem’to plot individual samples
xlabel('Sample no.(Matlab index)'); ylabel('Amplitude');
title('Sampled signal');
grid on;
n_s =[0: length(x)-1]; %true sample number
subplot(2,2,3)
stem (n_s,x); %see note 2 ⧫
xlabel('Sample no. '); ylabel('Amplitude'); title('Sampled signal');
grid on;
subplot (2,2,4)
stairs (n_s,x);
xlabel('Sample no.'); ylabel('Amplitude'); title(' ZOH signal');
grid on;