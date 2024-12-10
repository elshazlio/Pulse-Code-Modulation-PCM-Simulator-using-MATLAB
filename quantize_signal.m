% Quantizer
function quantized_signal = quantize_signal(sampled_signal, L, mp, mu)
    % Compute step size
    step_size = (2 * mp) / (L - 1);
    
    if mu == 0
        % Uniform Mid-Rise Quantizer
        quantized_signal = round((sampled_signal + mp) / step_size) * step_size - mp; %  This creates a uniform distribution of error values within this interval
    else
        % μ-law Quantizer
        % Compress
        compressed = sign(sampled_signal) .* (log(1 + mu * abs(sampled_signal)/mp) / log(1 + mu)) * mp;
        % Quantize compressed signal
        quantized_compressed = round((compressed + mp) / step_size) * step_size - mp;
        % Expand
        quantized_signal = sign(quantized_compressed) .* ...
            ((mp / mu) .* ((1 + mu).^(abs(quantized_compressed)/mp) - 1));
    end
end