## Lab-1 2-ASK Modulation/Demodulation 
## 1.1 Experiment Objective
1.	Understand and master the basic principle of 2ASK.
2.	Master the basic ideas and methods of keying modulation and demodulation of data under the SDR platform.
3.	Become familiar with the development process of the development platform. 
## 1.2 Experimental Equipment
1.	One PlusSDR device, 
2.	One computer, 
3.	Matlab2018a (or higher version). 
## 1.3 Experimental Theory 
## 1.3.1 Keying Modulation of Digital Signals 
Digital Signal Keying Modulation is a modulation technique that transmits digital data (0s and 1s) wirelessly or over wires by changing a specific characteristic of the carrier waveform (such as amplitude, frequency, or phase). In digital communication systems, this type of technology is widely used for encoding and transmitting data, ensuring that signals can reach the receiver stably and efficiently through the transmission channel.
When discussing the implementation methods of digital modulation, it can theoretically be understood and implemented from two different perspectives:

1. Analog Modulation Perspective: Digital modulation implemented based on analog modulation. This method treats digital modulation as a special case of analog modulation; that is, even though the input is a digital signal (e.g., 0s and 1s), the modulation process still follows the logic of analog signal processing. Specifically, the digital baseband signal is treated as a step-like analog signal (discrete in value but continuous in time), which is then applied to a traditional analog modulation architecture.
2. Keying Perspective: Switching modulation based on digital logic operations. Another approach, closer to practical circuit implementation, uses the discrete nature of digital signals (only 0 or 1) to achieve modulation by controlling the presence and characteristics of the carrier through logical switches. This is known as Keying Modulation.

Common keying modulation methods include the following three basic types: 
ASK (Amplitude Shift Keying), 
FSK (Frequency Shift Keying), and 
PSK (Phase Shift Keying). 

Digital information can be binary or multi-level, so digital modulation can be divided into binary modulation and multi-level modulation. When the modulated signal is a binary digital baseband signal, the modulation technique used is called Binary Digital Modulation. The core feature of this type of modulation is that a certain physical parameter of the carrier (such as amplitude, frequency, or phase) switches only between two discrete states to correspond to the input binary information (0 and 1). Depending on the carrier parameter being modulated, common binary digital modulation methods include:
• 2-ASK (Binary Amplitude Shift Keying): The carrier's amplitude is switched between two levels (e.g., present/absent) to represent 0 and 1.
• 2-FSK (Binary Frequency Shift Keying): Two different frequencies correspond to 0 and 1 respectively.
• 2-PSK (Binary Phase Shift Keying, also known as BPSK): The carrier's phase switches between two fixed angles (e.g., 0 degrees and 180 degrees) to represent digital bits.

## 1.3.2 2ASK Modulation/Demodulation Theory 
2-ASK, also known as On-Off Keying (OOK), is the most basic digital modulation method. Its principle is to use a unipolar Non-Return-to-Zero (NRZ) code to control the on/off state of the carrier. When the input is 1, the carrier is output normally; when the input is 0, the carrier is turned off. In this modulation method, the carrier's frequency and initial phase remain constant, and only the presence or absence of amplitude represents digital data.
Furthermore, the mathematical model and modulation/demodulation process of 2ASK are the most intuitive. It is the most basic and representative type in digital modulation theory, often used as an introductory example for academic and experimental research, helping to understand more complex modulation technologies.
The block diagram of 2ASK modulation/demodulation is shown in Figure below. 
 
The time-domain expression for 2ASK modulation can be defined based on the carrier form and the input bit stream:
If the input binary sequence is {bn} ∈ {0, 1}, and the duration of each bit is Tb, then the 2ASK signal can be expressed as: 
 
Where:
• bn: the nth binary data (0 or 1)
• A: carrier amplitude (corresponds to bit = 1)
• fc: carrier frequency
• p(t): pulse shaping function (e.g., rectangular pulse), defined as:
     
• Tb: duration of each bit
According to the above definition, Figure 2-2 shows the waveform of a 2ASK modulated signal. In the waveform, when the input bit is 1, the signal shows the full amplitude of the carrier A * cos(2πfct); when the input bit is 0, the signal amplitude is 0. The waveform periodically switches with changes in the input binary sequence, reflecting the modulation result within each bit duration Tb. 2ASK signal waveform is shown in Figure 2-2: 
 
Figure 2-2 2ASK Signal Waveform Schematic Diagram
The complete 2ASK modulation generation is shown in Figure below:
 
In this experiment, the 2ASK modulation method used is based on the fundamental principle of keying modulation. It generates the modulated 2ASK signal by multiplying the original binary baseband signal with a sine wave carrier signal of a specific frequency and phase. To ensure that each symbol corresponds completely to the carrier signal, special attention must be paid to ensuring that the symbol width of the baseband signal and the period of the carrier are consistent. This modulation method can essentially be seen as controlling the on and off states of the carrier with the baseband signal, causing the carrier amplitude to switch in a binary manner, thereby achieving the effect of amplitude shift keying.
For the demodulation part, a method similar to correlation detection is employed. This involves multiplying the received 2ASK signal with a local reference carrier of the same frequency and phase, and then taking its absolute value. This operation enhances the sections where the carrier is present and suppresses sections without the carrier. Further, through a threshold decision, sections greater than zero are determined to be the original symbol "1," and sections equal to zero are determined to be "0". This successfully reconstructs the original digital signal, achieving effective demodulation of the modulated signal.
1.4 Program Design Idea 
1.4.1 Transmitter Design
At the transmitting end, we first randomly generate binary codes (0 or 1). Then, we generate a carrier signal. From the principle mentioned above, when the baseband signal is 0, no carrier is transmitted (set to 0); when the baseband signal is 1, a normalized frequency Fc carrier signal is transmitted.
Since the optimal sampling frequency for the PlusSDR used in this experiment is 61.44MHz, for frequency symmetry, we set the transmitted carrier frequency to 30.72 MHz. Fc = Fs / 2, which is exactly at the midpoint of the entire bandwidth (Nyquist frequency). This design ensures that the modulated signal is symmetrically distributed around the Nyquist frequency in the frequency domain, providing good alignment and resolution characteristics for subsequent spectrum analysis or demodulation.
In this experiment, the carrier frequency for the RF circuit is set to Fc = 30.72MHz, and the system's sampling frequency is Fs = 61.44MHz. Therefore, the designed 2ASK modulated signal needs to be centered at 30.72 MHz and sampled and digitally processed based on 61.44 MHz. This sampling frequency is exactly twice the carrier frequency, ensuring that the system design fully complies with the Nyquist criterion and effectively avoids aliasing.
According to the basic principle of keying modulation (ASK), when the input baseband binary signal is "1," a complete cycle of the carrier signal needs to be transmitted. When the input is "0," it corresponds to no carrier (a signal equal to zero). Therefore, there must be strict alignment between the carrier and the baseband signal, and each symbol period must completely correspond to one or more carrier cycles.
In this experiment's setting, the number of sampling points corresponding to each symbol (bit_Width) is 20. This means that each symbol period corresponds to 20 sampling points. According to the following formula, the number of sampling points corresponding to one carrier cycle can be calculated: 
 
Sampling points per carrier cycle = Fs / Fc = 61.44 MHz / 30.72 MHz = 2. This means a complete carrier cycle corresponds to only 2 sampling points. Therefore, to achieve a complete modulation effect, we include 10 complete carrier cycles (each cycle contains 2 points, totaling 20 points) in each symbol, i.e., symbol width = 20.

