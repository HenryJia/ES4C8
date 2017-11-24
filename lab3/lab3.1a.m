function [ ACF_M,D,dim ] = stacf(s,frame_l,frame_o,nlags )
%STACF Returns the short-time auto-correlation function of a time series
% The time series is split into N frames of length frame_l and
% overlap frame_overlap which are arranged in a frame_l x N matrix
% The autocorrelation of the each of the N rows is performed
% Split s into N overlapping arrays with frame_o overlap
dim=(length(s)-frame_o)/(frame_l-frame_o);
dim=floor(dim); %rounds down and discards last frame
% Construct overlapped arrays
D=zeros(dim,frame_l);
D(1,:)=s(1:frame_l);
for i=2:dim
 D(i,:)=s((i-1)*(frame_l-frame_o)+1:(i*frame_l-(i-1)*frame_o));
end
%Calculate the autocorrelation of the arrays
ACF_M=zeros(dim,frame_l);
for i=1:dim
 ACF_M(i,:)=autocorr(D(i,:),nlags);
end
end

[y, Fs] = audioread('vowels.wav');%read the file 'vowels.wav'
dur = 0.3; % [s] take 300 ms duration
n = dur * Fs; % calculate number of points which corresponds to that
s=y(1:n); % take the first 300 ms of the signal
frame_length=720; %Define frame length
frame_overlap=240; %Define frame overlap
nlags=frame_length-1;
[ACF_M,D,dim] = stacf( s,frame_length,frame_overlap,nlags );
subplot(2,2,1); plot(y);
subplot(2,2,2); plot(s);
subplot(2,2,3); waterfall(D);
subplot(2,2,4); plot(ACF_M');