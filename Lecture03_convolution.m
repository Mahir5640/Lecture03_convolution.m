%% Lecture03_convolution.m
% Discrete-Time Signal Operations, Convolution, and Moving-Average Filtering
% Generates all figures and exports: signal_operations.png, noise_filtering.png, filter_comparison.png

clear;
close all;
clc;

% Reproducible random noise
rng(1);

%% Initial Setup: Clean and Noisy Signals
n = 0:100;
clean = sin(0.1 * pi * n);

noise = 0.4 * randn(size(n));
measured = clean + noise;

% Display the initial baseline
figure('Name', 'Clean vs Noisy Baseline', 'Color', 'w');
plot(n, clean, 'b', 'LineWidth', 1.5, 'DisplayName', 'Clean Signal');
hold on;
plot(n, measured, 'Color', [0.6 0.6 0.6], 'DisplayName', 'Noisy Signal');
grid on;
xlabel('Sample index n');
ylabel('Amplitude');
title('Clean and Noisy Signals');
legend('Location', 'northeast');
hold off;

%% Task 1: Amplitude Scaling & Task 2: Signal Delay
% Multiply noisy signal by 2
scaled = 2 * measured;

% Delay noisy signal by 5 samples by prepending 5 zeros
delay = 5;
delayed = [zeros(1, delay), measured];

n_measured = 0:length(measured)-1;
n_delayed = 0:length(delayed)-1;

% Figure: Signal Operations (Scaling & Delay)
fig1 = figure('Name', 'Signal Operations', 'Color', 'w', 'Position', [100, 100, 850, 600]);

subplot(2, 1, 1);
plot(n_measured, measured, 'Color', [0.5 0.5 0.5], 'LineWidth', 1.0, 'DisplayName', 'Noisy Signal x[n]');
hold on;
plot(n_measured, scaled, 'r', 'LineWidth', 1.2, 'DisplayName', 'Scaled Signal 2 \cdot x[n]');
grid on;
xlabel('Sample index n');
ylabel('Amplitude');
title('Task 1: Amplitude Scaling (Gain = 2)');
legend('Location', 'northeast');
hold off;

subplot(2, 1, 2);
stem(n_measured, measured, 'Color', [0.5 0.5 0.5], 'Marker', 'o', 'MarkerSize', 3, 'DisplayName', 'Original x[n]');
hold on;
stem(n_delayed, delayed, 'b', 'Marker', 'x', 'MarkerSize', 4, 'DisplayName', 'Delayed x[n-5]');
grid on;
xlabel('Sample index n');
ylabel('Amplitude');
title('Task 2: Signal Delay (Delay = 5 Samples)');
legend('Location', 'northeast');
hold off;

exportgraphics(fig1, 'signal_operations.png', 'Resolution', 300);

%% Task 3: Five-Point Moving-Average Filter
h5 = ones(1, 5) / 5;
filtered5 = conv(measured, h5, 'same');

fig2 = figure('Name', 'Noise Filtering (5-Point MA)', 'Color', 'w', 'Position', [150, 150, 850, 450]);
plot(n, clean, 'b-', 'LineWidth', 1.8, 'DisplayName', 'Clean Signal');
hold on;
plot(n, measured, 'Color', [0.7 0.7 0.7], 'LineWidth', 0.8, 'DisplayName', 'Noisy Signal');
plot(n, filtered5, 'm-', 'LineWidth', 1.4, 'DisplayName', '5-Point Filtered');
grid on;
xlabel('Sample index n');
ylabel('Amplitude');
title('Task 3: Noise Filtering with 5-Point Moving-Average Filter');
legend('Location', 'northeast');
hold off;

exportgraphics(fig2, 'noise_filtering.png', 'Resolution', 300);

%% Task 4: Compare Two Filter Lengths (5-point vs 15-point)
h15 = ones(1, 15) / 15;
filtered15 = conv(measured, h15, 'same');

fig3 = figure('Name', 'Filter Comparison', 'Color', 'w', 'Position', [200, 200, 900, 480]);
plot(n, clean, 'b-', 'LineWidth', 2.0, 'DisplayName', 'Clean Target');
hold on;
plot(n, measured, 'Color', [0.75 0.75 0.75], 'LineWidth', 0.8, 'DisplayName', 'Noisy Input');
plot(n, filtered5, 'm--', 'LineWidth', 1.4, 'DisplayName', '5-Point MA Filter');
plot(n, filtered15, 'r-', 'LineWidth', 1.6, 'DisplayName', '15-Point MA Filter');
grid on;
xlabel('Sample index n');
ylabel('Amplitude');
title('Task 4: Moving-Average Filter Comparison (5-Point vs 15-Point)');
legend('Location', 'northeast');
hold off;

exportgraphics(fig3, 'filter_comparison.png', 'Resolution', 300);

disp('Script finished successfully. All three figures exported.');