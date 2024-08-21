% Parameters
M = 16; % QAM order (16-QAM)
numSymbols = 1e5; % Number of symbols per SNR point
SNRdB = 0:2:20; % SNR range in dB
EbNo = SNRdB - 10*log10(log2(M)); % Convert SNR to Eb/No
numSNR = length(SNRdB);
SER = zeros(1, numSNR); % Initialize SER array
% Receiver impairments
gainImbalance = 0.1; % Gain imbalance
phaseMismatch = 0.05; % Phase mismatch in radians
dcOffsetI = 0.05; % DC offset in I component
dcOffsetQ = 0.05; % DC offset in Q component
for k = 1:numSNR
    % Generate random data symbols
    dataSymbols = randi([0 M-1], numSymbols, 1);
    % QAM modulation
    modulatedSignal = qammod(dataSymbols, M, 'UnitAveragePower', true);
    % Apply gain imbalance
    I = real(modulatedSignal);
    Q = imag(modulatedSignal);
    receivedSignal = (1 + gainImbalance) * I + 1i * (1 - gainImbalance) * Q;
    % Apply phase mismatch
    receivedSignal = receivedSignal .* exp(1i * phaseMismatch);
    % Apply DC offsets
    receivedSignal = receivedSignal + dcOffsetI + 1i * dcOffsetQ;
    % Add AWGN
    receivedSignal = awgn(receivedSignal, SNRdB(k), 'measured');
    % QAM demodulation
    demodulatedSymbols = qamdemod(receivedSignal, M, 'UnitAveragePower', true);
    % Calculate SER
    SER(k) = sum(dataSymbols ~= demodulatedSymbols) / numSymbols;
end
% Plot SER vs Eb/No
figure;
semilogy(EbNo, SER, 'b-o');
xlabel('E_b/N_0 (dB)');
ylabel('Symbol Error Rate (SER)');
title('SER vs E_b/N_0 for 16-QAM with Receiver Impairments');
grid on;
% Display results for each SNR point
fprintf('SNR (dB)    SER\n');
fprintf('--------    ---\n');
for k = 1:numSNR
    fprintf('%8.2f    %e\n', SNRdB(k), SER(k));
end
% Optional: Plot constellation diagram for the highest SNR point
scatterplot(receivedSignal);
title('Received Signal Constellation with Receiver Impairments (SNR = 20 dB)');
grid on;