# adaptive-noise-cancellation-matlab

This project implements an **Active Noise Control (ANC)** system in MATLAB designed to isolate music from high-intensity helicopter noise. The system simulates a pilot's headset environment where adaptive filtering is required to cancel overlapping engine interference that traditional filters cannot handle.

<br>

## Key Features

* **Spectral Analysis**: Fast Fourier Transform (FFT) utilized to identify overlapping frequencies between noise and music (0-1000 Hz).
* **Adaptive Filtering**: Implementation of the **Least Mean Squares (LMS)** algorithm with $N_w = 3$ coefficients for real-time noise tracking.
* **Stability Control**: Precise tuning of the convergence step-size ($\mu = 0.188$) to ensure algorithm stability and prevent divergence.
* **Performance Comparison**: Comprehensive evaluation of different methods (Direct subtraction, fixed FIR filtering, and LMS) using relative error metrics.
* **Dual-Phase Simulation**: Features a **Learning Phase** (dynamic coefficient update) and an **Estimation Phase** (static filtering using optimized weights).

<br>

## System Architecture

The system mimics a dual-microphone noise cancellation headset:
* **Reference Input (Micro_2)**: Captures pure helicopter engine noise near the source to provide a noise reference.
* **Primary Input (Micro_1)**: Captures the desired music signal corrupted by the same engine noise within the cockpit.
* **LMS Filter**: Adaptively modifies the reference signal to match the phase and amplitude of the noise in the primary input.
* **Error Signal**: The result of the subtraction, which converges toward the "clean" music signal as the filter learns.

<br>

## Software Stack

* **MATLAB**: Core environment for signal processing and matrix calculations.
* **Signal Processing Toolbox**: Used for FFT analysis and FIR filter design (`fir1`, `filter`).
* **Audio System**: Integrated `audioplayer` functionality for real-time auditory verification of noise reduction quality.

<br>

## How to Run

To execute the noise cancellation simulation:
1.  Ensure the dataset `anc_audio_signals.mat` is in the working directory.
2.  Open the script `noise_cancellation.m` in MATLAB.
3.  Run the script to generate time-domain plots, frequency spectrums, and convergence curves.
4.  Follow the command window prompts to listen to the audio outputs (Original, Corrupted, and Recovered).

<br>

## Performance Results

The effectiveness of the algorithm is validated by the following observations:
* **Fixed Filter Limitation**: High-pass filtering (800Hz) successfully removes engine drone but significantly degrades music quality by cutting bass and percussion.
* **LMS Convergence**: The squared error ($e^2$) curve demonstrates that the filter successfully "learns" and stabilizes its coefficients.
* **Accuracy**: The **LMS Estimation Phase** achieved a superior relative error compared to direct subtraction, proving its ability to handle phase shifts and environmental changes.
