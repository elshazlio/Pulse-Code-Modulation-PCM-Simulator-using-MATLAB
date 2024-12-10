% Reconstruction filter
function reconstructed_signal = reconstruct_signal(decoded_signal, t, t_decoded, fm, fs)
    % Interpolate decoded signal
    reconstructed_signal = interp1(t_decoded, decoded_signal, t, 'pchip', 'extrap');
    
    % Apply smoothing for high sampling frequencies
    if fs > 50
        reconstructed_signal = smoothdata(reconstructed_signal, 'gaussian', 5);
    end
    
    % Low-pass filtering
    if fs > 50
        [b,a] = butter(4, 2*fm/fs, 'low');
        reconstructed_signal = filtfilt(b, a, reconstructed_signal);
    end
end