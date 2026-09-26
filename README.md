# Lecture 03 – Discrete-Time Signal Operations, Convolution, and Moving-Average Filtering

## Signal Operations

### Amplitude Scaling
Multiplying the signal by $2$ (`scaled = 2 * measured`) scaled the signal's vertical amplitude uniformly across all samples:
* **Amplitude:** Every sample value was doubled ($y[n] = 2 \cdot x[n]$), expanding the signal's dynamic range from approximately $[-1.4, 1.4]$ to $[-2.8, 2.8]$.
* **Frequency:** The underlying frequency remained unchanged at $\omega_0 = 0.1\pi\text{ rad/sample}$ ($20\text{ samples/cycle}$).
* **Sample Positions:** The horizontal sample indices $n$ remained unaltered.

### Signal Delay
Prepending 5 zeros (`delayed = [zeros(1, 5), measured]`) created a causal discrete-time shift ($y[n] = x[n - 5]$):
* **Direction:** The signal shifted **to the right** along the positive horizontal axis by 5 sample indices. The first nonzero sample that originally occurred at $n = 0$ moved to $n = 5$.
* **Waveform Shape:** The shape and sample-to-sample relationships were identical, but the total vector length expanded from 101 to 106 samples.
* **Engineering Causes:** In physical systems, this delay corresponds to transmission propagation latency (e.g., acoustic or cable delay), ADC conversion latency, or pipeline buffering prior to processing.

---

## Convolution and Moving-Average Filtering

### What the Impulse Response $h[n]$ Represents
The impulse response $h[n]$ is the output produced by a linear time-invariant (LTI) system when driven by a unit impulse input $\delta[n]$. In a moving-average filter, $h[n]$ defines the weighting factors applied to current and past input samples:
* For a 5-point filter: $h_5[n] = [0.2, 0.2, 0.2, 0.2, 0.2]$.
* It functions as a finite rectangular window in the time domain, which corresponds to a low-pass sinc-shaped filter in the frequency domain.

### Effect of Convolution on the Noisy Signal
Discrete convolution calculates a running weighted sum:

$$y[n] = (x * h)[n] = \sum_{k} x[k] h[n - k]$$

Because zero-mean Gaussian noise fluctuates rapidly between successive samples while the underlying sine wave changes smoothly, local averaging cancels out the high-frequency random fluctuations, yielding a smoother output signal.

---

## Comparison of 5-Point and 15-Point Filters

### Filter Performance Observations
* **Noise Reduction:** The **15-point filter removed noticeably more noise** than the 5-point filter. The variance of random fluctuations decreases proportionally to $1/M$ (where $M$ is filter length), so averaging over 15 samples suppresses high-frequency noise much more aggressively.
* **Signal Distortion and Attenuation:** The 15-point filter introduces distinct amplitude attenuation. Because a 10-sample window already spans half of the sine wave's 20-sample period ($T = 2\pi / 0.1\pi = 20\text{ samples}$), a 15-sample window spans three quarters of a cycle ($75\%$ of a wave). Averaging across both positive peaks and negative troughs suppresses the actual sinusoidal amplitude, lowering the peak value from $1.0$ down to approximately $0.65$. It also creates boundary transient distortion at the signal edges.
* **5-Point Filter Response:** The 5-point filter spans only $25\%$ of a cycle. It retains high fidelity to the true amplitude peak ($\approx 1.0$) while eliminating sharp noise spikes, though residual ripple remains.

### Engineering Recommendation
For this specific signal, the **5-point moving-average filter is recommended**:
* **Justification:** Even though the 15-point filter produces a smoother line, it destroys signal fidelity by damping the true amplitude by roughly $35\%$. In a sensor monitoring system, such attenuation would register as a false loss of vibration or power. The 5-point filter provides the best trade-off by removing rapid noise while preserving the true waveform peaks and dynamic range.

### Real Engineering Application
A common industrial application of moving-average filtering is **temperature and battery monitoring in battery management systems (BMS)**. Thermal and battery voltage sensors operate at low baseline frequencies but pick up high-frequency electromagnetic interference (EMI) from power inverter switching. A moving-average filter removes EMI spikes without distorting the slowly changing temperature or state-of-charge trends.

---

## AI Usage

* **Tool used:** Gemini
* **How I used it:** Generated the baseline MATLAB vector syntax for discrete padding and convolution options (`conv(..., 'same')`), and cross-checked the analytical sample period calculation ($T = 2\pi / \omega$).
* **What I verified or changed:**
  * Replaced basic subplots with dedicated figures and used `exportgraphics` at 300 DPI to guarantee clear exports named exactly as requested (`signal_operations.png`, `noise_filtering.png`, `filter_comparison.png`).
  * Verified that `conv(..., 'same')` introduces zero-padding edge effects and checked the exact ratio of filter length to signal period ($15 / 20 = 0.75$) to explain the amplitude drop in the 15-point filter.
