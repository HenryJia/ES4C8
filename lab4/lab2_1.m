[y, Fs] = audioread('vowels.wav'); %read the file 'vowels.wav'
speechsegment = y(1:0.3 * Fs); %select a 300 ms duration segment
window = hamming(0.3 * Fs); %create a window of the same length, choose Hamming
speechsegment_w = window .* speechsegment; %windowed speech segment
%choose order of the model; To specify the model order, use general rule
% that the order is at least two times the expected no. of formants +2.
r = 31;

C=[];C1=[];
for k1=1:1:r
 for k2=1:1:r
 temp1=[zeros(1,k1) speechsegment'];
 temp2=[zeros(1,k2) speechsegment'];
 m= max(size(temp1,2),size(temp2,2));
 temp1=[temp1 zeros(1,m-length(temp1)+1)];
 temp2=[temp2 zeros(1,m-length(temp2)+1)];
 C(k1,k2)=sum(temp1.*temp2);
 end
end
for k=1:1:r
 temp=[zeros(1,k) speechsegment'];
 speechsegment2=[speechsegment' zeros(1,k)];
speechsegment =speechsegment2';
 C1(k)=sum(temp.* speechsegment');
end
lpccoef=pinv(C)*C1';
filtercoef=[1; -1*lpccoef]; %you can create a filter using filtfilt()
[H1,W] = freqz(1,filtercoef,512,Fs) ;
figure;

subplot(1,2,1); stem(filtercoef);
subplot(1,2,2); plot(W,abs(H1)); axis([0, 2000, 0, 100])