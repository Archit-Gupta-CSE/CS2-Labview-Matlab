% Parameters
M = 2; % BPSK modulation
numBits = 1e3; % Number of bits
chipRate = 10; % Chips per bit
snr = 10; % Signal-to-noise ratio in dB
fs = 1000; % Sampling frequency
% Generate random bits
dataBits = randi([0 1], numBits, 1);
% BPSK Modulation
modulatedData = 2*dataBits - 1; % BPSK mapping (0 -> -1, 1 -> 1)
% Generate PN sequence (chips)
pnSequence = randi([0 1], numBits*chipRate, 1);
pnSequence = 2*pnSequence - 1; % Convert to bipolar (-1, 1)
% Spread the signal
spreadSignal = repelem(modulatedData, chipRate) .* pnSequence;
% Transmit over AWGN channel
receivedSignal = awgn(spreadSignal, snr, 'measured');
% Despread the signal
despreadSignal = receivedSignal .* pnSequence;
despreadBits = sum(reshape(despreadSignal, chipRate, numBits), 1)' / chipRate;
% BPSK Demodulation
receivedBits = despreadBits > 0;
% Calculate Bit Error Rate (BER)
BER_DSSS = sum(dataBits ~= receivedBits) / numBits;
% Calculate FFT for plotting spectra
n = length(spreadSignal);
frequencies = (-n/2:n/2-1)*(fs/n);
% Message signal spectrum
messageSpectrum = fftshift(fft(modulatedData, n));
% PN code spectrum
pnSpectrum = fftshift(fft(pnSequence, n));
% Modulated signal spectrum (spread signal)
spreadSignalSpectrum = fftshift(fft(spreadSignal, n));
% Received signal spectrum
receivedSignalSpectrum = fftshift(fft(receivedSignal, n));
% Despread signal spectrum
despreadSignalSpectrum = fftshift(fft(despreadSignal, n));
% Plotting
figure;
% Message signal spectrum
subplot(3,2,1);
plot(frequencies, abs(messageSpectrum));
title('Message Signal Spectrum');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
grid on;
% PN code spectrum
subplot(3,2,2);
plot(frequencies, abs(pnSpectrum));
title('PN Code Spectrum');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
grid on;
% Spread signal spectrum
subplot(3,2,3);
plot(frequencies, abs(spreadSignalSpectrum));
title('Spread Signal Spectrum');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
grid on;
% Received signal spectrum
subplot(3,2,4);
plot(frequencies, abs(receivedSignalSpectrum));
title('Received Signal Spectrum');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
grid on;
% Despread signal spectrum
subplot(3,2,5);
plot(frequencies, abs(despreadSignalSpectrum));
title('Despread Signal Spectrum');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
grid on;
% Demodulated signal spectrum (before decision device)
demodulatedSignalSpectrum = fftshift(fft(despreadBits, n));
subplot(3,2,6);
plot(frequencies, abs(demodulatedSignalSpectrum));
title('Demodulated Signal Spectrum (Before Decision Device)');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
grid on;
fprintf('DSSS BER: %e\n', BER_DSSS);