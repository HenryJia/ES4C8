NT = 10;
a = [0.9 0.8 -0.4 0.1];% insert here the values for multipliers ak
b = [1];% insert here the values for multipliers bk
x = ones (NT, 1); %input signal is a unit step;
y = filter (a, b, x)
figure(1); stem (y);

NT = 10;
a = [0.9 0.8 -0.4 0.1];% insert here the values for multipliers ak
b = [1 -1];% insert here the values for multipliers bk
x = zeros (NT, 1); % impulse
x(1) = 1;
y = filter (a, b, x)
figure(2); stem (y);

