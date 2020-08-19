clc
clear
close all 

Lx = 41;
N = 5;
M = 10;

n = 0:Lx-1;

hn = ones(1,N);

hnl = [hn, zeros(1,Lx-N)];
xn = cos(pi/10 * n ) + cos(2*pi/5 *n);
yn = fftfilt(hn,xn,M);

figure(1)
subplot(131), stem(hnl,'filled'), title('hn');
subplot(132), stem(xn ,'filled'), title('xn');
subplot(133), stem(yn ,'filled'), title('yn');