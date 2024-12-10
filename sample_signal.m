% Sampling
function sampled_signal = sample_signal(input_signal, t, fs, mp)
    % Create sampling time vector
    Ts = 1/fs;
    t_sampled = 0:Ts:t(end);
    
    % Sample the signal using linear interpolation
    sampled_signal = interp1(t, input_signal, t_sampled, 'linear');
    
    % Clip sampled signal to [-mp, mp]
    sampled_signal = max(min(sampled_signal, mp), -mp);
end