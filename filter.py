import numpy as np

#h[n] array, produced by http://t-filter.engineerjs.com/
h_float = np.array([
    0.000131056234575957,
    -0.00017563908822241866,
    -0.00192222670341725,
    -0.004805884914337431,
    -0.005885785791084064,
    -0.002442571836722744,
    0.003053427699952468,
    0.003988639588801947,
    -0.0014769410781528254,
    -0.005646242996505892,
    -0.001071629056200065,
    0.006671448391645752,
    0.004831778405263035,
    -0.006127847346013345,
    -0.009356295127822723,
    0.0031778359524926563,
    0.01364716725601914,
    0.0026816878298860035,
    -0.016286087583086944,
    -0.011463762241882941,
    0.015557194444107103,
    0.022602406244613283,
    -0.009513236121853992,
    -0.03498052434670724,
    -0.004291296602271465,
    0.04709038088809737,
    0.030417905335615246,
    -0.057272360765851786,
    -0.0844693841412773,
    0.06407430827126079,
    0.31080137164270005,
    0.43353623548474896,
    0.31080137164270005,
    0.06407430827126079,
    -0.0844693841412773,
    -0.057272360765851786,
    0.030417905335615246,
    0.04709038088809737,
    -0.004291296602271465,
    -0.03498052434670724,
    -0.009513236121853992,
    0.022602406244613283,
    0.015557194444107103,
    -0.011463762241882941,
    -0.016286087583086944,
    0.0026816878298860035,
    0.01364716725601914,
    0.0031778359524926563,
    -0.009356295127822723,
    -0.006127847346013345,
    0.004831778405263035,
    0.006671448391645752,
    -0.001071629056200065,
    -0.005646242996505892,
    -0.0014769410781528254,
    0.003988639588801947,
    0.003053427699952468,
    -0.002442571836722744,
    -0.005885785791084064,
    -0.004805884914337431,
    -0.00192222670341725,
    -0.00017563908822241866,
    0.000131056234575957
])

# Simulate a signal x[n] = sin(2*pi*400/fs*n) + sin(2*pi*500/fs*n)
#write the below as a function
def simulate_signal(fs, n):
    return np.sin(2 * np.pi * 400 / fs * n) + np.sin(2 * np.pi * 500 / fs * n)

#write a function which takes in the quantized values and turns them into a hex representation in 10 bits fixed point
#make the file named fir_coeffs.hex

def quantized_to_hex(quantized_values, bits=10):
    hex_values = []
    for value in quantized_values:
        if value < 0:
            value = (1 << bits) + value  # Convert to two's complement
        hex_values.append(f"{value:0{bits // 4}X}")  # Format as hex
    return hex_values

if __name__ == "__main__":
    fs = 2000  # Sampling frequency
    n = np.arange(0, 256)  # Sample indices
    x_float = simulate_signal(fs, n)
    x_scale = x_float * 0.5
    #print("Simulated x[n] values (float):", x_scale)


    #Quantize x[n]
    quantized_x = [int(round(x * 511)) for x in x_scale]
   # print("Quantized x[n] values:", quantized_x)

    #Quantize h[n] to 10 bits (Using Q1.10 format because the coefficient can all fit into 10 bit representation)
    quantized_h = [int(round(h * 1023)) for h in h_float]
    #print("Quantized h[n] values:", quantized_h)

    expected_output = np.convolve(quantized_x, quantized_h, mode='full')[:256]  # Take only the first 256 samples of the convolution result

    quantized_output = [int(round(y / 511)) for y in expected_output]
    #print("Expected output (convolution result):", expected_output)
    #write expected output to a .txt file
    with open("expected_output.txt", "w") as f:
        for value in quantized_output:
            f.write(str(value) + "\n")

    fir_coefficients_hex = quantized_to_hex(quantized_h)
    with open("fir_coeffs.hex", "w") as f:
        for hex_value in fir_coefficients_hex:
            f.write(hex_value + "\n")

#    dequantized_h = dequantize_fixed(quantized_h_q19, frac_h_bits)
#    print("Dequantized h[n] values:", dequantized_h)

