% Import raw CSV file
input_data = csvread('Podcast_Eyes_Closed_2.csv',2,0); % This excludes the first two rows
eegcols = 5:18; % EEG Columns
eeg.raw = input_data(:,eegcols);

% High pass filter the data to remove slow drifts
% High pass filter will center the data
fs = 128;
HP_freq = 0.5;
[b1,a1] = butter(6,HP_freq/(fs/2),'high');
x = filtfilt(b1,a1,eeg.raw);
eeg.HPfilt = filtfilt(b1,a1,x);

FC5data = eeg.HPfilt(:,4); % FC5
x = FC5data;

% Do FFT to computer power. We need the power value to know the TBP.
n = length(x);
xdft = fft(x);
xdft = xdft(1:n/2+1);
pw = abs(xdft).^2/n; % Power of the DFT
freq = 0:fs/n:fs/2;

% FC5 TBP
theta_L_index = 1249;
theta_H_index = 2496;
beta_L_index = 4366;
beta_H_index = 9354;

disp(['Theta band [' num2str(round(freq(theta_L_index))) ' - ' num2str(round(freq(theta_H_index))) ']']);
disp(['Beta band [' num2str(round(freq(beta_L_index))) ' - ' num2str(round(freq(beta_H_index))) ']']);

TBP_theta = sum(pw(theta_L_index:theta_H_index)); % 4 - 8Hz
TBP_beta = sum(pw(beta_L_index:beta_H_index));   % 14 - 30Hz

% FC5 LBPR
LBPR = log(TBP_theta)/log(TBP_beta);

disp(' ');
disp(['LBPR Theta Beta ratio ' num2str(LBPR)]);
