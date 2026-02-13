# 63-Tap FIR Filter (SystemVerilog)

This repository contains a 63-tap low-pass FIR filter implemented in SystemVerilog. The project was completed as part of a digital IC design lab and focuses on RTL development, fixed-point arithmetic, and functional verification through simulation.

The goal was to translate a high-level signal processing specification into synthesizable hardware and validate its behavior using a custom testbench and reference model.

---

## Design Specifications

- **Sampling rate:** 2 kHz  
- **Pass band:** up to 400 Hz  
- **Stop band:** from 500 Hz  
- **Stop band attenuation:** 80 dB  
- **Number of taps:** 63  
- **Data format:** 10-bit signed fixed-point (inputs and coefficients)  

The filter coefficients were generated from the specification and quantized to fixed-point for hardware implementation.

---

## RTL Implementation

The FIR filter is implemented as:

- A 63-element shift register to store input history  
- Multiply-accumulate logic to compute the output sample  
- Fully fixed-point arithmetic throughout the datapath  

On each clock cycle, a new input sample is shifted into the register and the output is computed from the weighted sum of the stored samples.

The design is written in synthesizable SystemVerilog.

---

## Verification

A SystemVerilog testbench was developed to verify correctness.

The testbench:

- Instantiates the FIR module  
- Loads quantized coefficients  
- Applies a generated input waveform  
- Captures output samples for comparison  

The input signal is the sum of two sinusoids at 400 Hz and 500 Hz. Since the filter is low-pass, the expected behavior is preservation of the 400 Hz component and attenuation of the 500 Hz component.

Python scripts are included to:

- Generate input samples  
- Quantize coefficients  
- Compute the expected convolution result  
- Plot and compare simulation output  

The RTL output matches the reference model within fixed-point quantization limits.

---

## Repository Structure

- `FIR_63TAP.sv` – RTL implementation of the FIR filter  
- `tb.sv` – Testbench used for simulation  
- `fir_coeffs.hex` – Quantized filter coefficients  
- `filter.py` – Input generation and expected output computation  
- `plot.py` – Script for plotting waveform results  
- `expected_output.txt` – Reference output from Python model  
- `fir_output.txt` – Output from RTL simulation  

---

## Skills Demonstrated

- RTL design in SystemVerilog  
- Fixed-point datapath design and scaling decisions  
- Testbench development and functional verification  
- Using software models to validate hardware behavior  
- Translating high-level specifications into working RTL  

This project reflects the front end of a digital IC design flow, from specification to verified RTL.
