[y, Fs] = audioread('vowels.wav'); %read the file 'vowels.wav'
speechsegment = y(1:0.3 * Fs); %select a 300 ms duration segment
window = hamming(0.3 * Fs); %create a window of the same length, choose Hamming
speechsegment_w = window .* speechsegment; %windowed speech segment
%choose order of the model; To specify the model order, use general rule
% that the order is at least two times the expected no. of formants +2.
r = 8;

[lpccoef1, error] = lpc(speechsegment_w,r) ;
%2*sqrt(error) can be used to scale the power of the source

[H,Omega]=freqz(1,lpccoef1,512); %FR of all-pole filter over 512 points
figure; plot(abs(H))
[v_max, pos_max]= max(lpccoef1); %find the position of the formants using max()
p = roots(lpccoef1); % calculate the poles of the vocal tract filter
theta_p = angle(p); % calculate the angle of the pole using angle()
zplane(1, lpccoef1);