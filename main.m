%% PCM System Simulator - Main Script
% Omar ElShazli - Omar Hagras - John Besada - Hala Refaie
clear; close all; clc;

%% User Input Section
% Default values
default_fm = 10;        % Message frequency
default_A = 5;          % Signal amplitude
default_fs = 100;       % Sampling frequency
default_L = 8;          % Quantization levels
default_mp = 5;         % Peak amplitude
default_mu = 255;       % μ-law parameter
default_encoding = 'polar';

% Get user input
prompt = {'Enter message frequency (fm):', 'Enter signal amplitude:', ...
    'Enter sampling frequency (fs):', ...
    'Enter number of quantization levels (L) (powers of 2 only):', ...
    'Enter peak level (mp):', 'Enter mu (0 for uniform quantization):', ...
    'Enter encoding type (unipolar/polar/manchester):'};
defaultans = {num2str(default_fm), num2str(default_A), num2str(default_fs), ...
    num2str(default_L), num2str(default_mp), num2str(default_mu), default_encoding};
answer = inputdlg(prompt, 'PCM System Parameters', 1, defaultans);

% Input processing
if isempty(answer)
    fm = default_fm; A = default_A; fs = default_fs;
    L = default_L; mp = default_mp; mu = default_mu;
    encoding_type = default_encoding;
else
    fm = str2double(answer{1}); A = str2double(answer{2});
    fs = str2double(answer{3}); L = str2double(answer{4});
    mp = str2double(answer{5}); mu = str2double(answer{6});
    encoding_type = lower(answer{7});
end

%% Signal Generation
t = 0:0.001:2;
input_signal = A * cos(2*pi*fm*t);

%% Process Signal through PCM System
% Sampling
sampled_signal = sample_signal(input_signal, t, fs, mp);
t_sampled = 0:1/fs:t(end);

% Quantization
step_size = (2 * mp) / (L - 1); % redundant but added for debugging
quantized_signal = quantize_signal(sampled_signal, L, mp, mu);

% Encoding
encoded_signal = encode_signal(quantized_signal, L, mp, step_size, encoding_type);

% Decoding
decoded_signal = decode_signal(encoded_signal, L, mp, step_size, encoding_type);
t_decoded = linspace(0, t(end), length(decoded_signal));

% Reconstruction
reconstructed_signal = reconstruct_signal(decoded_signal, t, t_decoded, fm, fs);

%% Plotting
t_encoded = linspace(0, t(end), length(encoded_signal));

% Figure 1: Source and Sampled Signal
figure('Name', ['Source and Sampled Signal']);
plot(t, input_signal, 'b-', 'LineWidth', 1.5);
hold on;
stem(t_sampled, sampled_signal, 'r.', 'MarkerSize', 10);
grid on;
xlabel('Time (s)'); ylabel('Amplitude');
title(['Source Signal and Sampled Signal']);
legend('Source Signal', 'Sampled Signal');

% Figure 2: Sampled and Quantized Signal
figure('Name', ['Sampled and Quantized Signal']);
stem(t_sampled, sampled_signal, 'b.', 'MarkerSize', 10); % Original sampled signal
hold on;
stem(t_sampled + 0.01, quantized_signal, 'r.', 'MarkerSize', 10); % Slight horizontal offset for quantized signal to make it visible
grid on;
xlabel('Time (s)');
ylabel('Amplitude');
title(['Sampled and Quantized Signal']);
legend('Sampled Signal', 'Quantized Signal');

% Figure 3: Encoded Signal
figure('Name', ['Encoded Signal']);
plot(t_encoded, encoded_signal, 'b-', 'LineWidth', 1.5);
grid on;
xlabel('Time (s)'); ylabel('Amplitude');
title(['Encoded Signal']);

% Figure 4: Source and Reconstructed Signal
figure('Name', ['Source and Reconstructed Signal']);
plot(t, input_signal, 'c-', 'LineWidth', 1.5);
hold on;
plot(t, reconstructed_signal, 'r--', 'LineWidth', 1.5);
grid on;
xlabel('Time (s)'); ylabel('Amplitude');
title(['Source and Reconstructed Signal']);
legend('Source Signal', 'Reconstructed Signal');

% Figure 5: Frequency Domain Analysis
figure('Name', ['Frequency Domain Analysis']);
% Source signal spectrum
subplot(3,1,1);
[pxx_source, f_source] = periodogram(input_signal, [], length(input_signal), 1/(t(2)-t(1)));
plot(f_source, 10*log10(pxx_source));
grid on;
title(['Source Signal Spectrum']);
xlabel('Frequency (Hz)'); ylabel('Power/Frequency (dB/Hz)');

% Sampled signal spectrum
subplot(3,1,2);
[pxx_sampled, f_sampled] = periodogram(sampled_signal, [], length(sampled_signal), fs);
plot(f_sampled, 10*log10(pxx_sampled));
grid on;
title(['Sampled Signal Spectrum']);
xlabel('Frequency (Hz)'); ylabel('Power/Frequency (dB/Hz)');

% Reconstructed signal spectrum
subplot(3,1,3);
[pxx_recon, f_recon] = periodogram(reconstructed_signal, [], length(reconstructed_signal), 1/(t(2)-t(1)));
plot(f_recon, 10*log10(pxx_recon));
grid on;
title(['Reconstructed Signal Spectrum']);
xlabel('Frequency (Hz)'); ylabel('Power/Frequency (dB/Hz)');