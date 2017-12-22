clear
clc
close all
phrase = input('Enter phrase\n','s');

% Load the phrase
if strcmp(phrase, 'signal')
    [y, Fs] = audioread('signal.wav');
    y = y(22000:53000, 1); % Chop out the bits with no voice
elseif strcmp(phrase, 'and')
    [y, Fs] = audioread('and.wav');
    y = y(30000:53000, 1);
elseif strcmp(phrase, 'image')
    [y, Fs] = audioread('image.wav');
    y = y(22000:44000, 1);
elseif strcmp(phrase, 'processing')
    [y, Fs] = audioread('processing.wav');
    y = y(22000:end, 1);
else % Otherwise, load everything and concatenate
    [y1, Fs] = audioread('signal.wav');
    [y2, Fs] = audioread('and.wav');
    [y3, Fs] = audioread('image.wav');
    [y4, Fs] = audioread('processing.wav');
    y1 = y1(22000:53000, 1);
    y2 = y2(30000:53000, 1);
    y3 = y3(22000:44000, 1);
    y4 = y4(22000:end, 1);
    y = [y1; y2; y3; y4];
end

% Normalise to +-1
y = y / max(abs(y));

% Use our Visualise function to output the sound, do the basic plots
% As well as get the frequency
Visualise(y, Fs);

% Now for speech generation and the formant and pitch plots
% We divide it up into segments each with seg_length length
seg_len = 2000;
y_fake = zeros(length(y) + seg_len, 1);
fundamental_all = zeros(length(y), 1);
formants_all = zeros(length(y), 3);
i = 1;
fprintf("Performing Synthesis using LPC\n");
r = 30;

while seg_len < length(y) - i
    y_seg = y(i:i + seg_len - 1);
    
    % Determine if signal is voiced or unvoiced
    % And calculate the time period of the fundamental frequency
    % if voiced
    [pk, loc] = findpeaks(abs(fft(y_seg)), 'MinPeakDistance', 128);
    
    freq = (1:length(y_seg)) / Fs;
    
    fundamental = round(1 / freq(loc(2)));
    
    if mean(y_seg .^ 2) > 0.02
        inp = zeros(seg_len, 1);
        inp(1:fundamental:end) = 1;
    else
        fundamental = 1e6;
        inp = randn(seg_len, 1);
    end
    
    % Do the LPC and filtering
    [lpccoef, err] = lpc(y_seg, r);
    out = filter(err, lpccoef, inp);
    
    % Record stuff for the plots
    fundamental_all(i:i+seg_len) = Fs / fundamental;
    % The peaks are the formants
    [H, freq] = freqz(1, lpccoef, 512, Fs);
    [pks, locs] = findpeaks(abs(H), 'MinPeakDistance', 32);
    formants_all(i:i+seg_len, 1) = freq(locs(1));
    formants_all(i:i+seg_len, 2) = freq(locs(2));
    formants_all(i:i+seg_len, 3) = freq(locs(3));
    
    if i == 1
        fprintf('LPC Coefficients\n')
        lpccoef
        % Plot the frequency response of the LPC of the last segment
        figure(4)
        plot(freq, abs(H))
        title('LPC Frequency Response of First Segment')
        xlabel('Frequency (Hz)')
        ylabel('Power')
        axis([0 15000 0 150])
        
        figure(5)
        zplane(1, lpccoef);
        title('LPC Pole/Zero Plot of First Segment')
    end
    y_fake(i:i+seg_len-1) = out;
    
    
    i = i + seg_len;
end

figure(6)
plot((1:size(fundamental_all)) / Fs, fundamental_all)
title('Fundamental Frequencies Across Time')
xlabel('Time (seconds)')
ylabel('Frequency (Hz)')

figure(7)
hold on
plot((1:length(formants_all)) / Fs, formants_all(1:end, 1))
plot((1:length(formants_all)) / Fs, formants_all(1:end, 2))
plot((1:length(formants_all)) / Fs, formants_all(1:end, 3))
title('Formant Frequencies Across Time')
xlabel('Time (seconds)')
ylabel('Frequency (Hz)')
hold off
% Normalise to +- 1
y_fake = y_fake / max(abs(y_fake));

fprintf("Done, wait 5 seconds before playing\n");

% Plot
figure(8);
plot((1:length(y_fake)) / Fs, y_fake)
title('Generated Speech Time Domain')
xlabel('Time (seconds)')
ylabel('Magnitude')

figure(9);
y_freq = fft(y_fake);
% Set the axis to Hz
x_freq = (0:1 / length(y_freq):1 - 1 / length(y_freq)) * Fs;

% Plot the amplitude
plot(x_freq(1:5:end), abs(y_freq(1:5:end)))
title('Generated Speech Frequency Domain Amplitude (0 to 1KHz)')
xlabel('Frequency (Hz)')
ylabel('Power')
axis([0 1000 0 500])

% Pause for a bit then play
pause(5)
fprintf('Playing generated sound\n');
sound(y_fake, Fs)
fprintf('Saving generated sound\n');
audiowrite(strcat(phrase, '_fake.wav'), y_fake, Fs);