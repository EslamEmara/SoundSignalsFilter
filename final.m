[y, fs] = audioread('AudioSample.mp3');
y = y(:,1);             %% Mono channel
sound(y,fs);
%% Time domain plot %%
t = linspace(0,length(y)/fs,length(y));     
figure;subplot(2,1,1);plot(t,y);title('Time')
xlabel('Time');
ylabel('Amplitude');

%%% Frequency domain plot %%%
fvec = linspace(-fs/2,fs/2,length(y));
Ys = fftshift(fft(y));
subplot(2,1,2);plot(fvec,abs(Ys));title('freq');
xlabel('Frequency');
ylabel('Amplitude');

%%%% getting output from different impulse responses %%%%

%% y = x * h (* for convolution) 
%start time of x*y = start x + start y
%end time of x*y = end x + end y
%number of elements = nx+ny-1
%then resampling our time to be 

t1 = [t t];
t1 = t1(1:end-1);      

h1 = (t==0);                %delta function at t=0
h1=double(h1);              %convert logical array to numerical
y1=conv(y,h1);              
figure;subplot(2,2,1);plot(t1,y1);

h2 = exp(-2*pi*5000*t);     
y2 =conv(y,h2);
subplot(2,2,2);plot(t1,y2);title('5000t');

h3 = exp(-2*pi*1000*t);     
y3 = conv(y,h3);
subplot(2,2,3);plot(t1,y3);title('1000t');

h4 =2*(t==0);           %delta function at t=0 *2 
h4=double(h4);          %convert from logical to numerical
h_4 = 0.5 *(t==1);      %delta * 0.5 at t=1
h_4 = double(h_4);      %convert to numerical
h4 = h4 +h_4;           %add the two deltas
y4 = conv(y,h4);        %get convolution
subplot(2,2,4);plot(t1,y4);

%%%%  ADDING NOISE  %%%%
sigma = double(input('enter the value of sigma: '));
z=sigma*randn(length(y),1);
yn = y + z;
figure;subplot(2,1,1); plot(t,yn);title('Time domain');
ys = fftshift(fft(yn));
subplot(2,1,2); plot(fvec,abs(ys));title('Freq domain');

%%%% Filter  %%%%
f_limit=(length(y)/fs)*(fs/2 - 3400);
end_limit = f_limit + (6800*length(y)/fs);
ys(1:real(f_limit)) = 0;
ys(real(end_limit):end) = 0;
figure;subplot(2,1,2);plot(fvec,abs(ys));
grid on
ys = real(ifft(ifftshift(ys)));
subplot(2,1,1);plot(t,ys);
clear sound;        %% stop previous sound if it's still playing
sound(ys,fs);






