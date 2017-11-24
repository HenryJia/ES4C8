[y, Fs] = audioread('vowels.wav');

sound(y, Fs);
spectrogram(y)