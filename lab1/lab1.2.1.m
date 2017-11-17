NT = 10;
a = [0.9, 0.8]; % insert here the values for multipliers ak
N = length (a)- 1;
b = [1, 0.5]; % insert here the values for multipliers bk
M = length (b)-1;
x = zeros(NT, 1); %initialise the memory for the input sequence
y = zeros(NT, 1); %initialise the memory for the output sequence
x(1) = 1; %initialise input signal as a unit impulse
for n = 1:NT
y(n) = 0;
for k = 0:N
if ((n-k) > 0)
y(n) = y(n) + x(n-k)* a(k+1);
end
end
for k = 1:M
if ((n-k) > 0)
y(n) = y(n) - y(n-k) * b(k+1);
end
end
end
y
figure; stem (y);