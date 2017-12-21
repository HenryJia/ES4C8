clear
clc
while true
   phrase = input('Enter phrase\n','s');

   % Default for when we find the fundamental frequency
   peak_distance = 128;
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

       % With a longer a signal, MatLab will make a longer fft sequence
       % with higher resolution
       % So we set the peak distance bigger
       peak_distance = 512;
   end

   % Apply a butterworth filter between 40Hz and 1KHz
   %[b_bpf, a_bpf] = butter(2, [40/(Fs/2), 1000/(Fs/2)]);
   %y = filter(b_bpf, a_bpf, y);

   % Normalise to +-1
   y = y / max(abs(y));

   % Use our Visualise function to output the sound, do the plots
   % As well as get the frequency
   [x_freq, y_freq] = Visualise(y, Fs);

   % We don't actually care much about the phase
   y_freq = abs(y_freq);

   % Find the fundamental frequency
   [pks, locs] = findpeaks(y_freq, 'MinPeakDistance', peak_distance);
   fundamental = x_freq(locs(1));
   fprintf("Fundamental frequency %f Hz\n", fundamental);

   % Find the formants with LPC
   figure(4)
   r = 100; % Use 20 because our computers can handle it
   [lpccoef, err] = lpc(y, r);
   [H, freq] = freqz(1, lpccoef, 512, Fs);
   plot(freq, abs(H))
   title('Linear Predictive Coefficients')

   % The peaks are the formants
   [pks, locs] = findpeaks(abs(H), 'MinPeakDistance', 32);

   % We only look at the first 5 since find peaks will also find weak
   % peaks which are not really formants
   pks = pks(1:min(5, length(pks)));
   locs = locs(1:min(5, length(locs)));

   formants = [];
   for i = 1:length(locs)
       formants = [formants; freq(locs(i))];
       fprintf("Formant frequency at %f Hz\n", formants(i));
   end

   % Now for speech generation
   % Doing the entire word or phrase by LPC will not be possible
   % We divide it up into segments each with seg_length length
   % We first do the long term Glottal (pitch) model
   % We need each segment to be long enough to contain the lowest
   % Frequency which is 40Hz
   % Fs = 44100, therefore 44100/40 = 1102.5 < 2000
   seg_len = 2000;
   shift_len = 50;
   y_fake = zeros(length(y) + seg_len, 1);
   i = 1;
   fprintf("Performing Synthesis using LPC\n");
   while seg_len < length(y) - i
       y_seg = y(i:i + seg_len - 1);

       % Determine if signal is voiced or unvoiced
       % Signal is voiced if the energy at any frequency is higher
       % Than the 10% of the average
       % Source: https://github.com/krylenko/LPCsynthesis/
       acf = autocorr(y_seg, length(y_seg) - 1);
       [energy, fundamental] = max(acf(50:end));
       fundamental = fundamental + 50;

       if energy > 0.1 * acf(1)
          inp = zeros(seg_len, 1);
          inp(1:fundamental:end) = 1;
       else
          inp = randn(seg_len, 1);
       end

       % Do the LPC and filtering
       [lpccoef, err] = lpc(y_seg, r);
       out = filter(err, lpccoef, inp) .* hamming(seg_len);

       % Soft cutoff at +- 1 for magnitude
       y_fake(i:i+seg_len-1) = tanh(0.5*(out + y_fake(i:i+seg_len-1)));

       i = i + shift_len;
   end

   % Normalise to +- 1
   y_fake = y_fake / max(abs(y_fake));

   fprintf("Done, wait 5 seconds before playing\n");

   % Plot
   figure(5);
   plot((1:length(y_fake)) / Fs, y_fake)
   title('Generated Speech Time Domain')
   xlabel('Time (seconds)')
   ylabel('Magnitude')

   figure(6);
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
end