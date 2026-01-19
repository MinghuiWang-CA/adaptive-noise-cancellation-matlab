# Adaptive Noise Cancellation (ANC) using LMS Algorithm

This repository features a **MATLAB implementation of an Adaptive Noise Canceller (ANC)** designed to recover an audio signal (music) heavily corrupted by helicopter engine noise.

## Project Overview
In many real-world scenarios, target signals are obscured by environmental noise that overlaps in the frequency domain. This project demonstrates why standard digital filters (High-pass/Low-pass) often fail in these cases and how **Adaptive Filtering** provides a superior solution by dynamically modeling the interference.

<br>

## Problem Statement
* **Primary Signal (Micro 1):** Music + High-intensity helicopter engine noise.
* **Reference Signal (Micro 2):** Pure engine noise captured near the source (the engine).
* **Challenge:** The engine noise and the music share overlapping frequencies (0-1 kHz), making standard spectral filtering ineffective without destroying the target audio.

<br>

## The Solution: LMS Adaptive Filter
The system utilizes the **Least Mean Squares (LMS)** algorithm. Unlike fixed-coefficient filters, the LMS filter adjusts its coefficients in real-time to minimize the error between the reference noise and the noise present in the primary signal.

<br>

### Key Advantages:
* **Real-time Adaptation:** Adjusts to changes in the noise environment.
* **Minimal Signal Degradation:** Effectively targets noise even when it overlaps with the desired signal's spectrum.
* **Low Complexity:** Computationally efficient for embedded DSP applications.

<br>

## Performance Comparison
The project compares three different approaches:

| Method | Effectiveness | Limitation |
| :--- | :--- | :--- |
| **Simple Subtraction** | Poor | Phase mismatch between microphones prevents cancellation. |
| **Fixed FIR Filter** | Moderate | Attenuates noise but also removes desirable low-frequency music. |
| **LMS Adaptive Filter** | **Excellent** | **Dynamically tracks noise for maximum signal recovery.** |

<br>

## Results
The implementation includes visualization of:
1.  **Time-Domain Analysis:** Comparing raw corrupted audio vs. recovered signal.
2.  **Spectral Analysis:** Visualizing frequency overlap.
3.  **Convergence Plots:** Monitoring the Mean Squared Error (MSE) and filter coefficient stability over time.

<br>

## How to Run
1.  Ensure you have **MATLAB** installed.
2.  Place `Data.mat` in the root directory.
3.  Run the main script:
    `
    adaptive_noise_cancellation.m
    `

<br>

## Technical Concepts Covered
* Digital Signal Processing (DSP)
* Stochastic Gradient Descent (LMS update rule)
* Fast Fourier Transform (FFT) analysis
* FIR Filter Design
