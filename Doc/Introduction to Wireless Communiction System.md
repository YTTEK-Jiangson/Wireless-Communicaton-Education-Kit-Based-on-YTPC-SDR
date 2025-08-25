## 1.Introduction to Wireless Communication Systems 

Traditional wireless communication systems are divided into two parts: digital and analog. 
The digital baseband portion and the analog radio frequency (RF) portion are converted through a Digital-to-Analog Converter (DAC) and an Analog-to-Digital Converter (ADC), respectively.
 
In the development history of communication systems, Analog Communication Systems played an important role in early information transmission. 
Analog communication transmits information using continuously varying signals, such as the familiar AM (Amplitude Modulation) and FM (Frequency Modulation) broadcasts, as well as old-fashioned analog telephones, all of which use analog signals to transmit sound or images over long distances. These signals continuously change over time and are transmitted through carrier modulation, amplification, and antenna emission.

However, analog signals are more sensitive to noise and interference, easily causing distortion during transmission, and are relatively difficult to manage in terms of signal processing and storage.
 
To solve these problems, modern communication mostly relies on Digital Communication Systems. Unlike analog, digital communication is based on discontinuous signals composed of 0s and 1s, offering advantages such as strong anti-interference capabilities, stable transmission, and ease of compression and encryption. Its core part is the "digital baseband" system.

The digital baseband part is generally referred to as the "digital communication system," primarily for baseband digital communication signal processing. "Baseband" refers to digital signals without a carrier, typically composed of 0s and 1s, to facilitate signal processing using methods like a Digital Signal Processor (DSP) or Micro-Processor (uP). A digital communication system includes two main parts: a digital transmitter and a digital receiver, as shown in the block diagram of Figure 1.
 
The main blocks of a digital transmitter include: 

Source Coding: which encodes and compresses raw data to reduce the amount of information to be transmitted; 
Cyclic Redundancy Check (CRC): which adds redundant bits for error detection to prevent overly long transmitted data; 
Scrambling: which scrambles 0s and 1s in the raw data to avoid long sequences of 0s or 1s; 
Channel Coding: which adds redundant bits for error correction; and 
Modulation, which converts signals into the amplitude, frequency, or phase of a carrier, or a combination thereof, to improve spectral efficiency.

The main blocks of a digital receiver include: 

De-modulation: which restores the received signal, carried on the carrier's amplitude, frequency, or phase, or a combination thereof, into 0s or 1s bit signals; 
Channel Decoding: which removes the redundant bits added for error correction; 
Descrambling, which restores the scrambled 0s or 1s; 
Cyclic Redundancy Check (CRC): which detects errors in the received signal through redundant bits; and 
Source Decoding: which restores the encoded and compressed signal. 

