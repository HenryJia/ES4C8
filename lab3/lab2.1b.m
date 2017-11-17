t= 0:0.001:1.2; % 1.2 sec @ 1kHz sample rate
fo=25; f1=200; % Start at 25 Hz, go up to 200 Hz at 1.2 sec
y=chirp(t,fo,1.2,f1);
subplot(2,2,1); plot(t, y)
subplot(2,2,2); spectrogram(y);% uses DSP Toolbox
subplot(2,2,3); spectrogram(y,256,200,256,1000);
subplot(2,2,4); spectrogram(y,256,100,128,500);