NT = 10;
a = [0.9 0.8];
b = [1 0.5]; % b(1) is always 1; see note2 ⧫
x1 = zeros (NT, 1);
x2 = zeros (NT, 1);
x3 = zeros (NT, 1);
x1(1) = 0.6;
x2(2) = -0.2;
x3(3) = 0.8;
x = x1 + x2 + x3;
y1 = filter (a, b, x1); % y has the same number of samples as x
y2 = filter (a, b, x2); % y has the same number of samples as x
y3 = filter (a, b, x3);
y = filter (a, b, x);

y_sum = y1 + y2 + y3;

y
y_sum
figure; stem(y);
figure;
subplot(3,1,1);
stem(y1);
subplot(3,1,2);
stem(y2);
subplot(3,1,3);
stem(y3);
