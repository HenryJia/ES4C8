[y, Fs] = audioread('vowels.wav');
sound(y,Fs)
%subplot(3,2,1);plot(y)
time = [1:length(y)]/Fs;
subplot(4,2,1);plot(time,y) %plot entire signal in time domain, real time axis
dur = 0.5; % [s] take 500 ms duration
total=Fs*dur;
n= 1; % choose start of segment from sample no. 1
s0=y(n+1:n+total); %segment (frame) corresponding to 500ms
s1=s0.*hamming(length(s0)); %window the speech segment
t=time(n+1:n+total);
subplot(4,2,2); plot(t*1000,s1) %current segment in time domain [ms]
freq=[0:total-1]*Fs/total; % real frequency axis
S2=abs(fft(s1));subplot(4,2,3); plot(freq,S2); axis([0, 1000, 0, 200]) % frequency content
S3=log(S2); subplot(4,2,4); plot(freq,S3)% log of frequency in frequency domain
%the highest peak corresponds to pitch, the other to formants
S4=smooth(S3,40); subplot(4,2,5); plot(freq,S4)%remove high freq. component/noise
S5=abs(ifft(S4));subplot(4,2,6); plot(t*1000,S5) %cepstrum in quefrency
nsamples=40; %choose the required no.of samples for the 'lifter'
s2= [ones(nsamples,1);zeros(length(s0)-2*nsamples,1);ones(nsamples,1) ]; %create the cepstrum window (lifter) with nsamples
S6=s2.*S5; subplot(4,2,7); plot(t*1000,S6) %remove the high-time corresponding to the pitch
S7=abs(fft(S6));subplot(4,2,8); plot(S7) %transfer back into freq domain and plot the envelope
