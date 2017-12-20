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

   y = y .* hamming(length(y));


   % Use our Visualise function to output the sound, do the plots
   % As well as get the frequency
   [x_freq, y_freq] = Visualise(y, Fs);

   % We don't actually care much about the phase
   y_freq = abs(y_freq);

   % Find the fundamental frequency
   [pks, locs] = findpeaks(y_freq, 'MinPeakDistance', peak_distance);
   fundamental = x_freq(locs(2));
   fprintf("Fundamental frequency %f Hz\n", fundamental);

   % Find the formants with LPC
   figure(5)
   r = 50;
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
   % Doing the entire word by LPC will not be possible
   % We divide it up into segments each with seg_length length
   y_fake = [];
   seg_length = 1000;
   for i = 1:seg_length:length(y)
       if seg_length > length(y) - i
           break
       end
       y_short = y(i:i + seg_length);
       y_long = [y_short; y_short; y_short; y_short];

       [lpccoef1, err] = lpc(y_long, 4 * r);
       [lpccoef2, err] = lpc(y_short, r);

       %t = (0:1/Fs:(seg_length - 1) / Fs)';
       %inp = sin(2 * pi * fundamental * t);
       %inp = cos(2 * pi * fundamental * t);

       inp = inp + randn(seg_length, 1);
       % We multiply and weight by the maximum displacement of the real
       % signal do mimic the silent and non-silent regions
       out = filter(1, lpccoef1, inp);
       out = filter(1, lpccoef2, out) * max(abs(y_short));
       y_fake = [y_fake; out];
   end
   % Scale our generated speech's magnitude to match our real speech
   y_fake = y_fake / max(abs(y_fake)) * max(abs(y));

   % Pause for a bit then plot and play
   pause(5)
   figure(6);
   sound(y_fake, Fs)
   plot((1:length(y_fake)) / Fs, y_fake)
   title('Generated Speech Time Domain')
   xlabel('Time (seconds)')
   ylabel('Magnitude')
end