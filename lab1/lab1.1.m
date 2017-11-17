x = 11; %choose the number
N = 50; %choose the number of iterations
%calculate the square root iteratively
for k = 1:N
x = sqrt (x);
fprintf (1, ' %d %.20f \n ', k, x);
end
%retrieve the original number by calculating the square iteratively
for k = 1:N
x = x ^ 2;
fprintf (1, ' %d %.20f \n ', k, x);
end
whos
% Note this does not produce perfect accuracy since there is limited floating
% point precision