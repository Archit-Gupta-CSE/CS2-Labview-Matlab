% Parameters
N = 64;             % Number of OFDM subcarriers
CP_len = 16;        % Length of Cyclic Prefix
SNR_dB = 0:2:30;    % Increased SNR range in dB for higher resolution
numSymbols = 1000;  % Number of OFDM symbols

% Modulation orders to test
M_values = [4, 8, 16, 32, 64]; % BPSK, QPSK, 8-PSK, 16-PSK

% Preallocate SER array
SER = zeros(length(SNR_dB), length(M_values));

for mIdx = 1:length(M_values)
    M = M_values(mIdx); % Current modulation order
   
    for idx = 1:length(SNR_dB)
        % Generate random data symbols
        data = randi([0 M-1], N, numSymbols);
       
        % MPSK modulation
        modData = pskmod(data, M, pi/M);
       
        % IFFT to generate time-domain OFDM symbols
        ifftData = ifft(modData, N);
       
        % Add Cyclic Prefix
        cpData = [ifftData(end-CP_len+1:end, :); ifftData];
       
        % Convert to column vector for transmission
        txSignal = cpData(:);
       
        % Transmit through AWGN channel
        rxSignal = awgn(txSignal, SNR_dB(idx), 'measured');
       
        % Reshape to original matrix form
        rxSignal = reshape(rxSignal, N + CP_len, numSymbols);
       
        % Remove Cyclic Prefix
        rxSignal_noCP = rxSignal(CP_len+1:end, :);
       
        % FFT to get frequency domain data
        fftData = fft(rxSignal_noCP, N);
       
        % MPSK demodulation
        demodData = pskdemod(fftData, M, pi/M);
       
        % Calculate Symbol Error Rate (SER)
        numSymbolErrors = sum(sum(data ~= demodData));
        SER(idx, mIdx) = numSymbolErrors / (N * numSymbols);
    end
end

% Plot SER vs. SNR for multiple modulation orders
figure;
semilogy(SNR_dB, SER, 'o-');
xlabel('SNR (dB)');
ylabel('Symbol Error Rate (SER)');
title('MPSK-CP-OFDM SER vs. SNR for Multiple Modulation Orders');
legend(arrayfun(@(x) sprintf('%d-PSK', x), M_values, 'UniformOutput', false));
grid on;

% Parameters
N = 64;             % Number of OFDM subcarriers
CP_len = 16;        % Length of Cyclic Prefix
SNR_dB = 0:2:30;    % Increased SNR range in dB for higher resolution
numSymbols = 1000;  % Number of OFDM symbols

% Modulation orders to test
M_values = [4, 16, 64, 256]; % 4-QAM, 16-QAM, 64-QAM, 256-QAM

% Preallocate SER array
SER = zeros(length(SNR_dB), length(M_values));

for mIdx = 1:length(M_values)
    M = M_values(mIdx); % Current modulation order
   
    for idx = 1:length(SNR_dB)
        % Generate random data symbols
        data = randi([0 M-1], N, numSymbols);
       
        % MQAM modulation
        modData = qammod(data, M);
       
        % IFFT to generate time-domain OFDM symbols
        ifftData = ifft(modData, N);
       
        % Add Cyclic Prefix
        cpData = [ifftData(end-CP_len+1:end, :); ifftData];
       
        % Convert to column vector for transmission
        txSignal = cpData(:);
       
        % Transmit through AWGN channel
        rxSignal = awgn(txSignal, SNR_dB(idx), 'measured');
       
        % Reshape to original matrix form
        rxSignal = reshape(rxSignal, N + CP_len, numSymbols);
       
        % Remove Cyclic Prefix
        rxSignal_noCP = rxSignal(CP_len+1:end, :);
       
        % FFT to get frequency domain data
        fftData = fft(rxSignal_noCP, N);
       
        % MQAM demodulation
        demodData = qamdemod(fftData, M);
       
        % Calculate Symbol Error Rate (SER)
        numSymbolErrors = sum(sum(data ~= demodData));
        SER(idx, mIdx) = numSymbolErrors / (N * numSymbols);
    end
end

% Plot SER vs. SNR for multiple modulation orders
figure;
semilogy(SNR_dB, SER, 'o-');
xlabel('SNR (dB)');
ylabel('Symbol Error Rate (SER)');
title('MQAM-CP-OFDM SER vs. SNR for Multiple Modulation Orders');
legend(arrayfun(@(x) sprintf('%d-QAM', x), M_values, 'UniformOutput', false));
grid on;
