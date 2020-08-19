clc
clear
close all 

M = 26;
N = 32;
n = 0:M;
xna = 0:1:M/2;
xnb = ceil(M/2)-1:-1:0;
xn = [xna,xnb];

Xk = fft(xn,512);
Xkm = sqrt(abs(Xk).^2);%幅度
Xka = phase(Xk);%相位

Xk32 = fft(xn,32);
Xk32m = sqrt(abs(Xk32).^2);
Xk32a = phase(Xk32);
xn32 = ifft(Xk32);

Xk16 = Xk32(1:2:N);
Xk16m = sqrt(abs(Xk16).^2);
Xk16a = phase(Xk16);%相位
xn16 = ifft(Xk16);

figure(1)
subplot(131), stem(xn, 'filled'), title('512');
subplot(132), stem(xn32, 'filled'), title('32');
subplot(133), stem(xn16, 'filled'), title('16');

figure(2)
subplot(131), stem(Xkm, 'filled'), title('512');
subplot(132), stem(Xk32m, 'filled'), title('32');
subplot(133), stem(Xk16m, 'filled'), title('16');
figure(3)
subplot(131), stem(Xka, 'filled'), title('512');
subplot(132), stem(Xk32a, 'filled'), title('32');
subplot(133), stem(Xk16a, 'filled'), title('16');




