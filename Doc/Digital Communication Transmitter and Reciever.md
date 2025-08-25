## 1.	Digital Communication Transmitter Concept 
Digital communication begins with voice encoding (assuming voice transmission), which is the process of sampling, quantizing, and converting original analog voice signals into digital data (Digitalizing). 

Subsequently, data compression (Source coding) is used to reduce data volume and improve spectral efficiency. 
Channel coding and Interleaving improve signal integrity by minimizing the effects of noise and interference. 
A small number of extra bits are added for frequency or phase error calibration or as training sequences for data identification and equalization (i.e., I/Q Balance). 

These techniques also simplify frequency synchronization and timing synchronization at the receiver. 

Timing synchronization is the process of recovering the symbol clock from the received signal. 

At the transmitter, the symbol encoder converts the serial bit stream into appropriate I and Q baseband signals, which map to symbols on the I-Q plane. 
The symbol clock represents the clock frequency and precise timing for individual symbol transmissions.

When the symbol clock changes, the transmitted carrier represents specific symbols (specific points on the constellation diagram) at the correct I-Q (or amplitude/phase) values. The time interval for each symbol is the symbol clock period, and its reciprocal is the symbol clock frequency. When the symbol clock is synchronized with the optimal instant for detecting symbols, the symbol clock phase corresponds to the correct symbol data.

After I and Q baseband signals are generated at the transmitter, they are first filtered by a filter to improve spectral efficiency. The output of an unfiltered wireless digital modulator would occupy additional bandwidth. This is because the rapid changes of baseband I-Q square waves in the time domain correspond to a very wide spectrum in the frequency domain. This situation is unacceptable because it consumes additional bandwidth, reduces the available spectrum for other users, and causes signal interference to adjacent users' channel spectrum, known as Adjacent Channel Power Interference.

Baseband filtering solves this problem by limiting the spectrum, thereby limiting interference to other channels. 

In practice, filtering is equivalent to slowing down rapid transitions between states in the time domain, which limits the spectrum. However, filtering can also lead to a degradation in signal and data transmission performance.
The degradation in signal quality is due to the reduction of spectral components, overshoot, and finite oscillation effects caused by the filter's time (impulse) response. Reduced spectral components can lead to loss of information detail, making it difficult or even impossible for the receiver to reconstruct the signal. The filter's oscillatory response may persist for a long time, affecting subsequent symbols and causing Inter-Symbol Interference (ISI). ISI is defined as excess energy from preceding and succeeding symbols interfering with the current symbol, leading to incorrect decoding. The optimal choice of filter thus becomes a best compromise between spectral efficiency and ISI.

In digital communication design, a commonly used specific type of filter is the Nyquist filter. A Nyquist filter is an ideal filter choice because it maximizes data rate, minimizes ISI, and limits channel bandwidth requirements.

To improve the overall communication transmission performance of the system, filters are generally shared or distributed between the transmitter and receiver. In this case, to minimize ISI, the filters must be matched as closely as possible between the transmitter and receiver and implemented correctly. Share and distribution mean to design the filter by considering the impulse response of both transmitter and receiver.

The filtered I and Q baseband signals are the inputs to the I-Q modulator. The LO in the modulator may operate at an intermediate frequency (IF) or directly at the final wireless radio frequency carrier frequency. The modulator's output is a composite of the two orthogonal I and Q signals at IF (or RF). After modulation, if necessary, the signal is further up-converted to the target RF frequency. Any excess frequencies are then filtered out, and finally, the signal is fed into the output amplifier and transmitted.

## 2.	Digital Communication Receiver Concept 
A receiver is essentially the reverse implementation of a transmitter, but it is more complex in design. The receiver first down-converts the input RF signal to an intermediate frequency (IF) signal, then further down-converts it to baseband, and then demodulates it. 

The ability to demodulate signals and recover original data is often quite challenging. Transmitted signals are often degraded during wireless transmission through the air by factors such as noise, signal interference, multipath, or fading.

The demodulation process typically includes the following stages: carrier frequency recovery and synchronization, symbol clock recovery and synchronization, signal decomposition into I and Q components (I-Q demodulation), I and Q symbol detection, bit demodulation and de-interleaving (decoding bits), and decompression to restore the original bit stream.

One of the key difference between the receiver and transmitter is the need to recover the carrier frequency and symbol clock. In the receiver, both the frequency and phase of the symbol clock must be precise for successful bit demodulation and recovery of transmitted data. 

For example, if the symbol clock frequency is set correctly but the phase is wrong, it will cause the sampled symbol to not be the correct original symbol, leading to demodulation errors. 

A challenging task in receiver design is to establish synchronization algorithms for carrier frequency and symbol clock recovery. Some clock synchronization techniques include measuring changes in modulation amplitude, or in systems with pulsed carriers, using edge detection on the ON/OFF sequence of pulses. This task can be simpler if the transmitter's packet format already provides training sequences for synchronization.

