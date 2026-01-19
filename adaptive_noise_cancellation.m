% =========================================================================
% Adaptive Noise Cancellation (ANC) for Aircraft Audio
% =========================================================================
% Objective: Recover a music signal corrupted by high-intensity helicopter 
% engine noise using Adaptive Filtering (LMS Algorithm).
% =========================================================================

clear all; close all; clc;

%% 1. Workspace Initialization & Data Loading
% Dataset contains:
% - Music_parfait: Ground truth signal
% - Micro_1: Distorted signal (Music + Engine noise)
% - Micro_2: Reference noise (Engine noise only, captured near source)
% - Fs: Sampling frequency
if exist('Data.mat', 'file')
    load('Data.mat');
else
    error('Dataset not found. Please ensure the .mat file is in the workspace.');
end

N = length(Micro_1);
t = (0:N-1) / Fs;

%% 2. Time-Domain Signal Visualization
figure('Name', 'Input Signal Analysis');
plot(t, Micro_1, 'b'); hold on;
plot(t, Micro_2, 'r');
plot(t, Music_parfait, 'g');
title("Raw Audio Signals: Corrupted vs Reference Noise");
xlabel("Time (s)"); ylabel("Amplitude");
legend("Micro 1 (Corrupted)", "Micro 2 (Noise Ref)", "Ground Truth");
grid on; xlim([0 1.5]);

%% 3. Frequency Domain Analysis
% Computing FFT to observe overlapping spectra
FFT_Music = abs(fft(Music_parfait));
FFT_M1    = abs(fft(Micro_1));
FFT_M2    = abs(fft(Micro_2));

f = (0:N/2-1) * (Fs/N);

figure('Name', 'Spectral Analysis');
subplot(3,1,1); plot(f, FFT_Music(1:N/2), 'g'); title("Spectrum: Ground Truth");
subplot(3,1,2); plot(f, FFT_M1(1:N/2), 'b'); title("Spectrum: Micro 1 (Corrupted)");
subplot(3,1,3); plot(f, FFT_M2(1:N/2), 'r'); title("Spectrum: Micro 2 (Reference Noise)");
for i=1:3, subplot(3,1,i); xlabel("Frequency (Hz)"); ylabel("Magnitude"); grid on; end

%% 4. Baseline Approach: Standard High-Pass Filtering
% Attempting to remove engine drone (low frequencies)
Fc = 800;                 
N_filt = 100;                 
Wn = Fc/(Fs/2);           
b_coeff = fir1(N_filt, Wn, "high");

Micro_1_Filtered = filter(b_coeff, 1, Micro_1);

%% 5. Advanced Approach: Adaptive LMS Filtering
% Adaptive filter parameters
Nw = 3;             % Filter order
mu = 0.188;         % Convergence step size
W_LMS = zeros(1, Nw);   

% Buffers for learning phase
longueur_apprentissage = length(Music_parfait);
Music_lms_estimate = zeros(longueur_apprentissage, 1);
err_lms = zeros(longueur_apprentissage, 1);
W_history = zeros(longueur_apprentissage, Nw);

% Signal padding for convolution
vect_input = [zeros(Nw-1, 1); Micro_1];

% LMS Adaptive Loop
for n = 1:longueur_apprentissage
    part_in = vect_input(n:n+Nw-1);
    
    % Filter output
    y_out = W_LMS * part_in;
    
    % Error calculation (Music recovery)
    % Note: In ANC, the error signal is the recovered audio
    Music_lms_estimate(n) = Micro_2(n) - y_out;
    
    % Model error (Relative to Ground Truth)
    err_lms(n) = Music_parfait(n) - Music_lms_estimate(n);
    
    % Coefficients update
    W_LMS = W_LMS + mu * Music_lms_estimate(n) * part_in';
    W_history(n,:) = W_LMS;
end

%% 6. Convergence & Performance Analysis
figure('Name', 'LMS Filter Performance');
subplot(2,1,1);
plot(err_lms.^2, 'LineWidth', 1.2);
title("Mean Squared Error (MSE) Convergence");
xlabel("Iterations"); ylabel("Squared Error"); grid on;

subplot(2,1,2);
plot(W_history);
title('Filter Coefficients Convergence');
xlabel('Iterations'); ylabel('Amplitude');
legend('w1', 'w2', 'w3'); grid on;

%% 7. Comparison of Results
figure('Name', 'Final Signal Recovery Comparison');
plot(t, Micro_1, 'g', 'Color', [0.7 0.9 0.7]); hold on; % Faded green
plot(t, Music_lms_estimate, 'r', 'LineWidth', 1);
plot(t, Music_parfait, 'b:', 'LineWidth', 1.2);
title("Music Signal Recovery: Raw vs LMS vs Ground Truth");
xlabel("Time (s)"); ylabel("Amplitude");
legend("Corrupted Input", "LMS Recovered", "Ground Truth");
grid on; xlim([1.0 1.1]); % Zoom to show tracking

%% 8. Quantitative Evaluation (Relative Error)
% Normalizing results for comparison
calc_err = @(est, ref) sum((est - ref).^2) / sum(ref.^2);

err_raw     = calc_err(Micro_1, Music_parfait);
err_fixed   = calc_err(Micro_1_Filtered, Music_parfait);
err_lms_final = calc_err(Music_lms_estimate, Music_parfait);

fprintf('\n--- Performance Metrics ---\n');
fprintf('Raw Signal Relative Error:    %.4f\n', err_raw);
fprintf('Fixed FIR Filter Error:       %.4f\n', err_fixed);
fprintf('Adaptive LMS Filter Error:    %.4f\n', err_lms_final);