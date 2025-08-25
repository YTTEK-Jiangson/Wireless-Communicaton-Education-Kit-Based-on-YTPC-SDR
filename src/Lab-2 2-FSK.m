%% CH3: 2FSK Example

% === Basic Parameters ===
Fs        = 61.44e6;   % Sampling rate
Fc1       = 2e6;       % Frequency 1 (Hz)
Fc2       = 10e6;       % Frequency 2 (Hz)
Num_bit   = 1000;      % Number of bits
bit_Width = 64;        % Samples per bit
use_YTTEK_SDR = 0;   % true = complex carrier, false = real carrier

% === Random Data ===
rng('default');
data = randi([0 1], 1, Num_bit);
data_trans = reshape(repmat(data, bit_Width, 1), 1, []);

% === Continuous Phase 2FSK Modulation ===
freqs = Fc1*(data_trans==0) + Fc2*(data_trans==1);
phase = 2*pi*cumsum(freqs)/Fs; % Integrate frequency to get phase
mod_data = cos(phase);

% === Received Signal  ===
if use_YTTEK_SDR == 1
    set_TX_Attenuation([0 20]); 
    set_RX_Gain([0 20]);   
    % ---- Loopback mode -----
    TX_REP = 0;                 
    RX_LEN = length(mod_data);   
    RX_delay = 50;  %RX_delay = 50為最佳，解調錯誤率最低             
    LB_mode = 0;                
    rec_data = TX_RX(mod_data, TX_REP, RX_LEN, RX_delay, LB_mode);
else
    rec_data = mod_data;
end

% === Demodulation Filter Design ===
bp_order       = 201;      % FIR filter order
fcut_bandwidth = 1.5e6;    % Filter bandwidth

clamp = @(x) min(max(x, 0), 1); % Clamp function for normalized freq

% Bandpass filter for Fc1
f1_low  = clamp((Fc1 - fcut_bandwidth) / (Fs/2));
f1_high = clamp((Fc1 + fcut_bandwidth) / (Fs/2));
b1 = fir1(bp_order, [f1_low, f1_high], 'bandpass');

% Bandpass filter for Fc2
f2_low  = clamp((Fc2 - fcut_bandwidth) / (Fs/2));
f2_high = clamp((Fc2 + fcut_bandwidth) / (Fs/2));
b2 = fir1(bp_order, [f2_low, f2_high], 'bandpass');

% Filtering + Envelope Detection
signal_f1 = filtfilt(b1, 1, rec_data);
signal_f2 = filtfilt(b2, 1, rec_data);
env_f1 = abs(signal_f1);
env_f2 = abs(signal_f2);

% Demodulation decision (vectorized)
env_f1_reshape = reshape(env_f1(1:Num_bit*bit_Width), bit_Width, []);
env_f2_reshape = reshape(env_f2(1:Num_bit*bit_Width), bit_Width, []);

avg_f1 = mean(env_f1_reshape);
avg_f2 = mean(env_f2_reshape);

demod_data_bits = avg_f2 > avg_f1;

% Calculate BER
error_rate = sum(demod_data_bits ~= data) / Num_bit;
fprintf('Bit Error Rate (BER): %.4f%%\n', error_rate*100);

%% === Figure 1: Transmit Waveforms ===
figure(1);
subplot(4,1,1); plot(data_trans(1:500));
title('Random Binary Baseband Signal'); ylim([-0.2 1.2]); grid on;
subplot(4,1,2); plot(cos(2*pi*Fc1*(0:499)/Fs));
title(sprintf('Carrier Fc1 = %.1f MHz', Fc1/1e6)); ylim([-1.2 1.2]); grid on;
subplot(4,1,3); plot(cos(2*pi*Fc2*(0:499)/Fs));
title(sprintf('Carrier Fc2 = %.1f MHz', Fc2/1e6)); ylim([-1.2 1.2]); grid on;
subplot(4,1,4); plot(mod_data(1:500));
title('2FSK Modulated Signal (TX)'); grid on;

%% === Figure 2: Modulated Signal Spectrum ===
figure(2);
subplot(2,1,1); plot(mod_data(1:500)); title('Modulated Signal Time Domain'); grid on;
Nfft = 2^nextpow2(length(mod_data));
f = Fs*(0:(Nfft/2))/Nfft / 1e6;
Mod_fft = fft(mod_data, Nfft);
P1 = abs(Mod_fft / Nfft); P1 = P1(1:Nfft/2+1); P1(2:end-1) = 2*P1(2:end-1);
subplot(2,1,2); plot(f, 20*log10(P1)); title('Modulated Signal Spectrum');
xlim([0 15]); grid on;

%% === Figure 3: Filtering Comparison (Only Fc1 frequency) ===
signal_f1_only = filtfilt(b1, 1, rec_data);
figure(3);
subplot(2,1,1); plot(real(rec_data(1:1000)));
title('Received Signal Before Filtering'); grid on;
subplot(2,1,2); plot(real(signal_f1_only(1:1000)));
title(sprintf('Filtered Signal (%.1f MHz)', Fc1/1e6)); grid on;

%% === Figure 4: Frequency Domain Filtering Comparison (Fc1) ===
Nfft = 2^nextpow2(length(rec_data));
f = Fs*(0:(Nfft/2))/Nfft / 1e6;
Rec_fft = fft(rec_data, Nfft);
P1 = abs(Rec_fft/Nfft); P1 = P1(1:Nfft/2+1); P1(2:end-1) = 2*P1(2:end-1);
F1_fft = fft(signal_f1_only, Nfft);
P2 = abs(F1_fft/Nfft); P2 = P2(1:Nfft/2+1); P2(2:end-1) = 2*P2(2:end-1);

figure(4);
subplot(2,1,1); plot(f, 20*log10(P1));
title('Spectrum Before Filtering'); xlim([0 15]); grid on;
subplot(2,1,2); plot(f, 20*log10(P2));
title(sprintf('Spectrum After Filtering (%.1f MHz)', Fc1/1e6)); xlim([0 15]); grid on;

%% === Figure 5: Demodulated Signal Waveforms ===
figure(5);
subplot(3,1,1); plot(real(rec_data(1:500))); title('Received Signal - Real Part'); grid on;
subplot(3,1,2); plot(imag(rec_data(1:500))); title('Received Signal - Imaginary Part'); grid on;
subplot(3,1,3);
expanded_demod = reshape(repmat(demod_data_bits, bit_Width, 1), 1, []);
plot(expanded_demod(1:500));
title('Demodulated Binary Signal (RX)'); ylim([-0.2 1.2]); grid on;
