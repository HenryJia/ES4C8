pkg load signal

NT = 40;
z = 0;
p = 0.9;
a = [0 1]; b = [1 -p]; % For 2.4b since 1 / (z - p) = z^(-1) / (1 - p * (z^-1))
x = zeros (NT, 1); x(1) = 1;
y = filter (a, b, x);

figure(1);
subplot(2,2,1); stem(y)
subplot(2,2,2);zplane(z,p) %only in the DSP System Toolbox (alternative
%- plot a unit circle, hold on, then plot the pole coordinates)

NT = 40;
z = 0;
p = 0.9*exp(j*pi/10);
a = [1 0 0];
b = poly([p conj(p)]); %expand (z-p)(z-p*)
roots(b) %the pole location can be checked
x = zeros (NT, 1); x(1) = 1;
y = filter (a, b, x);

figure(2);
subplot(2,2,1); stem(y)
subplot(2,2,2);zplane(z,[p; conj(p)]) %only in the DSP System Toolbox (alternative
%- plot a unit circle, hold on, then plot the pole coordinates)