%%
% generate signals with different mean where the changes in mean are known
clc 
clear
num_singal_mean=100;
mean_lst = [1,6,11,16,21];
var =1;
x=[];
for i=1:length(mean_lst)
    x_gen= normrnd(mean_lst(i),var,num_singal_mean,1);
    x=[x;x_gen];
end
%x=[1,2,3,4,5,6,7,8,9,10]';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Simple Moving Average (SMA) Filter
w_size = 6; % window size
y_sma = [NaN*ones(length(x),1)];
for i=1:length(x)-w_size+1
    % just for testing that it gets the right index
    %indx_sma(i,:)=i:i+w_size-1; 
    y_sma(i+w_size-1) = sum(x(i:i+w_size-1))/w_size;  
end

% verify test with the built-in function tsmovavg
sma = tsmovavg(x,'s',w_size,1);

% another way to calculate the mean of the values in indx list of x
% y_sma2 = [NaN*ones(length(x),1)];
% for i=1:length(x)-w_size+1
%      indx(i,:)=i:i+w_size-1;
% end
% y_sma2(w_size:length(x))=mean(x(indx),2); 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Exponential Moving Average(EMA) Filter
%EMA gives more weight to recent values over old values
lags = 5; % the number of lags (time periods)
alpha = 2/(lags+1); % smooth constant value
beta = 1-alpha; 

y_ema= [NaN*ones(length(x),1)];
% Use SMA for the first exp mov avg value
y_ema(lags) = sum(x(1:lags))/lags; 
y_ema(lags) = (alpha * x(lags))+ (beta * y_ema(lags));

for i=lags+1:length(x)
    y_ema(i) = alpha * x(i) + beta * y_ema(i-1); 
end

% to verify the implementation
ema = tsmovavg(x,'e',lags,1);

% % plot all results
fig = figure;
subplot(3,2,[1 2]),plot(x),xlabel('x'),ylabel('y'),
title(['Generated signal with mean= ' num2str(mean_lst)]),grid on,

subplot(323),plot(y_sma),xlabel('x'),ylabel('y'),
title(['Simple Moving Average w=' num2str(w_size)]),grid on,

subplot(324),plot(y_ema),xlabel('x'),ylabel('y'),
title(['Exponential Moving Average lag=' num2str(lags)]),grid on,

subplot(325),plot(sma),xlabel('x'),ylabel('y'),
title(['Simple Moving Average (tsmovavg) w=' num2str(w_size)]),grid on,

subplot(326),plot(ema),xlabel('x'),ylabel('y'),
title(['Exponential Moving Average (tsmovavg) lag=' num2str(lags)]),grid on,

savefig(fig,'moving_average_filters.fig');

