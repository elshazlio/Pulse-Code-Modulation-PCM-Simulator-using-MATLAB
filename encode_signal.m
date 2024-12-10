% Encoder
function encoded_signal = encode_signal(quantized_signal, L, mp, step_size, encoding_type)
    samples_per_bit = 50;
    binary_levels = round((quantized_signal + mp) / step_size);
    binary_sequence = de2bi(binary_levels, log2(L), 'left-msb');
    
    encoded_signal = zeros(1, size(binary_sequence, 1) * samples_per_bit * size(binary_sequence, 2));
    
    for col = 1:size(binary_sequence, 2)
        for row = 1:size(binary_sequence, 1)
            bit_start = (((row-1) * size(binary_sequence, 2)) + (col-1)) * samples_per_bit + 1;
            bit_end = bit_start + samples_per_bit - 1;
            
            switch encoding_type
                case 'unipolar' % Unipolar NRZ
                    encoded_signal(bit_start:bit_end) = binary_sequence(row, col);
                case 'polar' % Polar NRZ
                    encoded_signal(bit_start:bit_end) = 2*binary_sequence(row, col) - 1;
                case 'manchester' % Manchester
                    if binary_sequence(row, col) == 1
                        encoded_signal(bit_start:bit_start+samples_per_bit/2-1) = 1;
                        encoded_signal(bit_start+samples_per_bit/2:bit_end) = -1;
                    else
                        encoded_signal(bit_start:bit_start+samples_per_bit/2-1) = -1;
                        encoded_signal(bit_start+samples_per_bit/2:bit_end) = 1;
                    end
            end
        end
    end
end