clc
clear
close all 

xn = [1,1,1,1];
Xk16 = fft(xn,16);
Xk32 = fft(xn,32);
Xk16m = sqrt(abs(Xk16).^2);%幅度
Xk32m = sqrt(abs(Xk32).^2);
Xk16a = phase(Xk16);%相位
Xk32a = phase(Xk32);
figure(1)
subplot(121), stem(Xk16m, 'filled'), title('16');
subplot(122), stem(Xk32m, 'filled'), title('32');
figure(2)
subplot(121), stem(Xk16a, 'filled'), title('16');
subplot(122), stem(Xk32a, 'filled'), title('32');


