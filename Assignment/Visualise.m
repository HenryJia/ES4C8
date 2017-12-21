% The function to visualise time domain, freq domain and time/freq
% as required
function Visualise(y, Fs)
% Play the sound
fprintf('Playing original sound file\n');
sound(y, Fs);

% Plot in time domain, with x axis in seconds rather than samples
figure(1)
% We want to change the x axis to seconds rather than samples
plot((1:length(y)) / Fs, y);
title('Time Domain')
xlabel('Time (seconds)')
ylabel('Displacement')

% Plot the power of the frequency domain
figure(2)
% Convert to frequency domain
y_freq = fft(y);
% Set the axis to Hz
x_freq = (0:1 / length(y_freq):1 - 1 / length(y_freq)) * Fs;

% Plot the amplitude
plot(x_freq(1:5:end), abs(y_freq(1:5:end)))
title('Frequency Domain Amplitude (0 to 1KHz)')
xlabel('Frequency (Hz)')
ylabel('Power')
axis([0 1000 0 1500])

figure(3)
spectrogram(y, 1024, 512, 1024, Fs);
title('Time Frequency Domain')

end