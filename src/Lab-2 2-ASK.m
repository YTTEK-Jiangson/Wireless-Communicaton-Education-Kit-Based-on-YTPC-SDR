%% CH2: ASK Example

% === Parameter Settings ===
Fs = 61.44e6;        % Sampling frequency (Hz)
Fc = 1.92e6;         % Carrier frequency (Hz)
Num_bit = 1000;      % Number of bits
bit_Width = 20;      % Samples per symbol
use_YTTEK_SDR = 0;   % true = complex carrier, false = real carrier

% === Random Number Generator Initialization ===
rng('shuffle');      % Different random sequence each run

% === Generate Random Binary Sequence ===
data = randi([0 1], 1, Num_bit);

% === Upsample the Bit Stream ===
data_trans = reshape(repmat(data, bit_Width, 1), 1, []);

% === Generate Carrier Signal ===
carrier = cosine_wave_generator(Fc, Fs, length(data_trans));

% === 2ASK Modulation ===
mod_data = data_trans .* carrier;

% === Simulate Transmission (Loopback) ===
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

% === Envelope Detection ===
envelope = abs(rec_data);

% === FIR Low-pass Filter Design ===
lp_order = 10;  % Higher order for narrower transition band
fcut = (Fs / bit_Width) / 2;               % Half of symbol rate
normalized_cutoff = fcut / (Fs / 2);       % Normalized cutoff
b = fir1(lp_order, normalized_cutoff, hamming(lp_order+1)); 
filtered_signal = filtfilt(b, 1, envelope); % Zero-phase filtering

% === Normalization ===
filtered_signal = filtered_signal / max(abs(filtered_signal));

% === Threshold Decision ===
threshold = 0.5;  % Fixed threshold after normalization
demod_data_bits = zeros(1, bit_Num); % Preallocate memory
for k = 1:bit_Num
    idx = (k-1)*bit_Width+1 : k*bit_Width;
    avg_val = mean(filtered_signal(idx));
    demod_data_bits(k) = avg_val > threshold;
end

% === Bit Error Rate (BER) Calculation ===
error_rate = sum(demod_data_bits ~= data) / bit_Num;
fprintf('BER: %.4f%%\n', error_rate * 100);

% === TX Plots ===
figure(1);
subplot(3,1,1);
plot(data_trans(1:500));
title('Baseband Bit Sequence');
ylim([-0.2 1.2]); grid on;

subplot(3,1,2);
plot(real(carrier(1:500)));
title('Carrier Signal (Real Part)');
ylim([-1.2 1.2]); grid on;

subplot(3,1,3);
plot(real(mod_data(1:500)));
title('2ASK Modulated Signal (TX)');
ylim([-1.2 1.2]); grid on;

% === RX Plots ===
figure(2);
subplot(2,1,1);
plot(real(rec_data(1:500)));
title('Received Signal (Real Part)');
ylim([-1.2 1.2]); grid on;

subplot(2,1,2);
expanded_demod_data = reshape(repmat(demod_data_bits, bit_Width, 1), 1, []);
plot(expanded_demod_data(1:500));
title('Demodulated Binary Sequence (RX)');
ylim([-0.2 1.2]); grid on;

% === Carrier Generation Functions ===
function y = cosine_wave_generator(freq, Fs, len)
    t = (0:len-1) / Fs;
    y = cos(2 * pi * freq * t);
end

