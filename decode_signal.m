% Decoder
function decoded_signal = decode_signal(encoded_signal, L, mp, step_size, encoding_type)
    samples_per_bit = 50;
    binary_sequence_size = [floor(length(encoded_signal)/(samples_per_bit*log2(L))), log2(L)];
    decoded_binary = zeros(binary_sequence_size);
    
    for col = 1:binary_sequence_size(2)
        for row = 1:binary_sequence_size(1)
            bit_start = (((row-1) * binary_sequence_size(2)) + (col-1)) * samples_per_bit + 1;
            bit_end = bit_start + samples_per_bit - 1;
            
            switch encoding_type
                case 'unipolar'
                    decoded_binary(row, col) = mean(encoded_signal(bit_start:bit_end)) > 0.5;
                case 'polar'
                    decoded_binary(row, col) = mean(encoded_signal(bit_start:bit_end)) > 0;
                case 'manchester'
                    first_half = mean(encoded_signal(bit_start:bit_start+samples_per_bit/2-1));
                    second_half = mean(encoded_signal(bit_start+samples_per_bit/2:bit_end));
                    decoded_binary(row, col) = first_half > second_half;
            end
        end
    end
    
    decoded_levels = bi2de(decoded_binary, 'left-msb');
    decoded_signal = decoded_levels * step_size - mp;
end