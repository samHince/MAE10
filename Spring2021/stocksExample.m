% Moving average stock market example
% Inspired by an example given by Professor Dabdub 

% By Sam Hince
% 04/04/2021

clear;
clc;

%% Get data
% Download from: https://finance.yahoo.com/quote/NVDA/history?p=NVDA

% Import data into MATLAB
data = readtable('NVDA.csv');

dataLength = height(data);

%% Create plot 

plot(data.Date, data.Close)

%% Create moving average line

movingAvgLength = 10;
mvAvg = zeros(1,dataLength);

for i = (movingAvgLength + 1):dataLength
    % select data to be averaged 
    dataToAverage = data.Close((i-10):i);
    
    % find average and record value
    average = mean(dataToAverage);
    mvAvg(i) = average;
end

%% Create new plot

plot(data.Date, data.Close)
hold on 
plot(data.Date, mvAvg)
hold off

%% Find trades
% buys / sells:
trade = false(1, dataLength);

for i = 1:dataLength
   if (mvAvg(i) > data.Close(i))
       trade(i) = true;
   end
end

% trades
trades = [];

for i = 2:dataLength
   % buy
   if ((trade(i) == 1) && (trade(i-1) == 0))
       buyPrice = data.Close(i);
   end
   % sell
   if ((trade(i) == 0) && (trade(i-1) == 1))
       sellPrice = data.Close(i);
       difference = sellPrice - buyPrice;
       percentChange = difference / buyPrice;
       trades = [trades, percentChange];
   end
end

%% Find out how much we made

% if we just buy and hold:
simpleHoldChange = data.Close(dataLength) - data.Close(1);
simpleHoldPercent = simpleHoldChange / data.Close(1);

principal = 1000

holdFinalAccount = principal * simpleHoldPercent

% if we trade thr moving average:
for i = 1:length(trades)
    principal = principal * (1 + trades(i));
end

tradeFinalAccount = principal
