# Learning DSP on FPGAs

A free-resource guide, project roadmap, and interview preparation checklist.

## Starting point

This guide is aimed at someone who has already implemented a **63-tap FIR filter in RTL** and wants to advance toward FPGA engineering interviews and substantial personal projects.

Rather than restarting with elementary DSP, focus on **how signal-processing algorithms become efficient FPGA hardware**: fixed-point arithmetic, pipelining, FFTs, multirate processing, DSP block utilization, and verification.

## 1. Free DSP books and university courses

### Discrete-Time Signal Processing — Oppenheim and Schafer

- **Level:** Intermediate to advanced
- **Resource:** [Free MIT edition](https://ocw.mit.edu/courses/res-6-dtsp-discrete-time-signal-processing/)
- **Why read it:** A comprehensive treatment of FIR/IIR structures, Fourier transforms, FFTs, filter banks, and multirate DSP. Use it as a reference when you need to understand an algorithm before designing hardware for it.

### The Scientist and Engineer's Guide to Digital Signal Processing — Steven W. Smith

- **Level:** Beginner to intermediate
- **Resource:** [Free online book](https://www.dspguide.com/)
- **Why read it:** An intuitive, practical explanation of convolution, FFTs, frequency responses, and digital filters without excessive formalism.

### Think DSP — Allen B. Downey

- **Level:** Beginner to intermediate, hands-on
- **Resource:** [Book and exercises on GitHub](https://github.com/AllenDowney/ThinkDSP2)
- **Why read it:** Python/Jupyter-based DSP experiments that are useful for developing reference models to validate RTL against.

### MIT 6.341: Discrete-Time Signal Processing

- **Level:** Advanced
- **Resource:** [MIT OpenCourseWare course](https://ocw.mit.edu/courses/6-341-discrete-time-signal-processing-fall-2005/)
- **Why use it:** Free notes and assignments. Focus on material covering quantization, FIR structures, polyphase filters, and FFT algorithms rather than necessarily completing the entire course.

## 2. FPGA-specific DSP tutorials

### Project F: Fixed-point arithmetic and FPGA multipliers

- [Fixed-Point Numbers in Verilog](https://projectf.io/posts/fixed-point-numbers-in-verilog/)
- [Multiplication with FPGA DSPs](https://projectf.io/posts/multiplication-fpga-dsps/)
- **Learn:** Q formats, signed multiplication, numerical precision, rounding, and how arithmetic maps onto dedicated FPGA DSP hardware.
- **Recommendation:** Start here.

### ZipCPU: Building a High-Speed FIR Filter

- [Building a High-Speed FIR Filter](https://zipcpu.com/dsp/2017/09/15/fastfir.html)
- **Learn:** FIR architectural choices, throughput, timing, and implementation considerations.
- **Why it fits:** Directly builds on your existing FIR filter project.

### FPGA4Fun: Direct Digital Synthesis

- [Direct Digital Synthesis](https://fpga4fun.com/DDS1.html)
- **Learn:** Phase accumulators, waveform generation, frequency synthesis, and the foundations of digitally generated carriers.

### HardwareTeams: FIR Design and Verification with cocotb

- [FIR Design and Verification with cocotb](https://hardwareteams.com/docs/fpga-asic/cocotb/fir-filter/)
- **Learn:** Building a Python reference model, implementing RTL, and checking the output with cocotb.
- **Note:** Treat the example implementation as educational rather than necessarily optimized.

### Industry documentation

These guides document production-oriented approaches. The documentation is free, but some accompanying vendor IP may be proprietary.

- [AMD FIR Compiler Product Guide](https://docs.amd.com/r/en-US/pg149-fir-compiler): Filter architectures, coefficient reload, decimation, interpolation, and throughput trade-offs.
- [AMD FFT Architecture Options](https://docs.amd.com/r/en-US/pg109-xfft/Architecture-Options): Pipelined versus memory-based FFT architectures.
- [AMD UltraScale DSP Slice User Guide](https://docs.amd.com/v/u/en-US/ug579-ultrascale-dsp): Dedicated FPGA multiplier and multiply-accumulate resources. Some details are specific to the UltraScale family.

## 3. GitHub repositories to study

| Repository | Level | What to explore |
|---|---|---|
| [alexforencich/verilog-dsp](https://github.com/alexforencich/verilog-dsp) | Intermediate | CIC filters, DDS, phase accumulators, I/Q multiplication, and audio interfaces. Some modules are older, so validate before reuse. |
| [ZipCPU/dblclockfft](https://github.com/ZipCPU/dblclockfft) | Advanced | FFT pipelines, butterfly stages, twiddle factors, word widths, and streaming architectures. Review the repository's verification limitations. |
| [analogdevicesinc/hdl](https://github.com/analogdevicesinc/hdl) | Advanced | Real-world FPGA systems integrating converters, interfaces, and digital signal processing. |
| [Amirk97/IIR-FIR_IP_SystemVerilog](https://github.com/Amirk97/IIR-FIR_IP_SystemVerilog) | Intermediate | Parameterized FIR/IIR RTL, C reference models, and verification patterns. Some verification coverage is incomplete. |

When reviewing these repositories, focus on architectural choices and test infrastructure instead of simply copying modules.

## 4. Suggested personal projects

### Project A: Optimized streaming FIR filter

**Difficulty:** Intermediate  
**Best immediate project:** Builds on prior FIR experience.

Extend your existing filter with:

- [ ] Parameterizable tap count and coefficient widths.
- [ ] Support for reloading coefficients.
- [ ] Input/output streaming valid signaling.
- [ ] Defined rounding, saturation, and overflow behavior.
- [ ] At least two implementations, such as fully parallel and time-multiplexed multiply-accumulate (MAC).
- [ ] Optional transposed or deeply pipelined architecture.
- [ ] Bit-exact Python reference testing.
- [ ] Comparative synthesis and timing reports.

**Measure:** Maximum clock frequency, resource count, DSP utilization, cycle latency, initiation interval, throughput, and numerical error.

**Interview story:** Explain the timing-versus-area trade-off between architectures and why you selected particular word widths and pipeline stages.

### Project B: Streaming FPGA FFT spectrum analyzer

**Difficulty:** Intermediate to advanced  
**Best architecture project:** Exposes several hardware design decisions.

- [ ] Implement a small radix-2 FFT, starting at 16 points.
- [ ] Build and test butterfly units and complex multipliers.
- [ ] Store twiddle factors in a lookup table or ROM.
- [ ] Account for bit growth and scaling across stages.
- [ ] Handle output ordering, including bit reversal where needed.
- [ ] Compare results against NumPy FFT.
- [ ] Scale toward 64 or 256 points.
- [ ] Introduce a streaming architecture and benchmark it.

**Measure:** Samples per clock, pipeline latency, memory requirements, maximum clock frequency, DSP utilization, and signal-to-quantization-error performance.

### Project C: FPGA digital receiver or GFSK modem

**Difficulty:** Advanced  
**Best systems-level project:** Connects FPGA DSP to communications and a possible BLE modem.

Build a baseband signal chain that includes:

- [ ] Numerically controlled oscillator (NCO) or direct digital synthesizer (DDS).
- [ ] Complex I/Q mixing.
- [ ] CIC decimation.
- [ ] FIR channel filtering.
- [ ] GFSK demodulation and symbol recovery.
- [ ] Python-generated sample streams and end-to-end verification.
- [ ] Optional integration with an external RF transceiver once the digital chain works.

**Recommendation:** Start with simulated I/Q samples and make the digital datapath reliable before incorporating RF hardware.

## 5. FPGA interview preparation topics

| Topic | What to be able to explain |
|---|---|
| Fixed-point arithmetic | Q notation, signed multiplication, truncation, rounding, saturation, overflow, and quantization noise. |
| FIR architecture | Direct and transposed forms, coefficient symmetry, DSP sharing, MAC pipelines, and throughput. |
| Timing and resources | Critical paths, setup timing, DSP slices, LUTs, registers, clock frequency, latency, and area trade-offs. |
| Streaming interfaces | Valid/ready handshakes, buffering, clock enables, and backpressure. |
| FFT | Radix-2 butterflies, twiddle factors, complex multiplication, bit growth, FFT scaling, and memory organization. |
| Multirate DSP | Decimation, interpolation, CIC filters, and polyphase filters. |
| Verification | Python golden models, randomized stimulus, bit-exact comparisons, corner cases, and automated regression tests. |

### Key interview distinction: latency versus throughput

A highly pipelined filter might have many cycles of latency before the first output is ready, while still accepting a new sample every cycle. Be ready to identify both **latency** and **initiation interval**, and to explain how architecture affects frequency, area, and sample rate.

## 6. Six-week self-study plan

### Week 1: Fixed-point arithmetic and DSP blocks

- [ ] Read both Project F articles.
- [ ] Review numeric formats and data widths in your FIR design.
- [ ] Quantify numerical error against a floating-point Python model.

### Weeks 2–3: Optimized FIR architecture

- [ ] Build a second FIR implementation with a different MAC structure.
- [ ] Add pipelining and/or hardware reuse.
- [ ] Run verification and collect synthesis, timing, and utilization results.
- [ ] Write a brief comparison explaining the trade-offs.

### Week 4: FFT fundamentals

- [ ] Review the DFT and radix-2 Cooley-Tukey FFT.
- [ ] Study butterfly arithmetic and scaling.
- [ ] Create a NumPy reference model and decide on fixed-point formats.

### Weeks 5–6: FFT in RTL

- [ ] Implement and verify a small FFT.
- [ ] Add streaming control or extend to larger transform sizes.
- [ ] Produce timing, resource, and accuracy results.
- [ ] Document the architecture with block diagrams and a short README.

## 7. Free development tools

You can make substantial progress before purchasing FPGA hardware.

- **Python, NumPy, SciPy:** Signal generation, filters, spectral analysis, and golden-reference modeling.
- **Icarus Verilog or Verilator:** RTL simulation.
- **cocotb:** Python-driven RTL testbenches.
- **GTKWave:** Waveform inspection.
- **Yosys:** Open-source synthesis and hardware estimation, depending on target flow and device support.
- **Vendor FPGA tools:** Useful when you want device-specific mapping and timing/resource reports; free editions and licensing vary by vendor and device.

## Recommended order

1. Study Project F's fixed-point and DSP multiplier tutorials.
2. Revisit the 63-tap FIR filter, emphasizing numerical precision, timing, and resource optimization.
3. Build and compare two distinct FIR architectures.
4. Study FFT architecture and implement a verified small FFT.
5. Combine these skills in a digital receiver or GFSK modem.

**Goal:** Build a portfolio that shows not only working DSP algorithms, but also your ability to reason about hardware architecture, measure design trade-offs, and verify implementations rigorously.
