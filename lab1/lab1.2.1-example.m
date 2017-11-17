NT = 10; %choose the number of samples
x = zeros (NT, 1); %initialise the memory for the input sequence
y = zeros (NT, 1); %initialise the memory for the output sequence
x(1) = 1; %input signal is a unit impulse; see note 2 ⧫
for n = 1:NT %see note 2 ⧫
y(n) = 0.9 * x(n);
if (n > 1)
y(n) = y(n) + 0.8 * x(n-1)- 0.5 * y(n-1);
end
end
figure; stem (y); %output signal is the impulse response h(n)