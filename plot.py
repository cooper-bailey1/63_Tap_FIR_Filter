import numpy as np
import matplotlib.pyplot as plt

#def sign_extend(val, bits):
#    if val & (1 << (bits - 1)):
#        val -= 1 << bits
#    return val
#
#def wrap_signed(val, bits):
#    mask = (1 << bits) - 1
#    val &= mask
#    if val & (1 << (bits - 1)):
#        val -= (1 << bits)
#    return val
#
#def fir_streaming(x, h, x_bits=10, y_bits=10):
#    ntaps = len(h)
#    d = [0] * ntaps
#    y = []
#
#    for xn in x:
#        # shift register
#        d = [xn] + d[:-1]
#
#        acc = 0
#        for i in range(ntaps):
#            acc += d[i] * h[i]
#
#        # wrap to output width
#        mask = (1 << y_bits) - 1
#        acc &= mask
#        if acc & (1 << (y_bits - 1)):
#            acc -= (1 << y_bits)
#
#        y.append(acc)
#
#    return np.array(y)
#
#
#def run_simulation():
#
#    raw = np.loadtxt(
#        "fir_coeffs.hex",
#        dtype=np.int64,
#        converters={0: lambda x: int(x, 16)}
#    )
#
#    coeffs = np.array([sign_extend(v, 10) for v in raw])
#
#    #input x data 
#    pattern = np.array([0, 498, 150, -406, -243, 255, 243, -105, -150, 13, 0, -13, 150, 105, -243, -256, 243, 406, -150, -498], dtype=np.int64)
#
#    input_data = np.tile(pattern, 256 // len(pattern) + 1)[:256]
#
#    #run convolution
#    output_data = fir_streaming(input_data, coeffs)    
#    #take the output data and turn it into 10 bit signed integers
#    #signed_output = np.array([wrap_signed(int(x), 10) for x in output_data], dtype=np.int64)
#    #save data to expected_output.txt
#    np.savetxt("expected_output.txt", output_data, fmt="%d")

def plot_txt_file(filename, title, xlabel, ylabel):
    # Load data (one value per line)
    data = np.loadtxt(filename, dtype=np.int64)
    
    # Create x-axis
    x = np.arange(len(data))

    # Plot
    plt.figure()
    plt.plot(x, data, marker='o', linestyle='-', color='b')
    plt.xlabel(xlabel)
    plt.ylabel(ylabel)
    plt.title(title if title else filename)
    plt.grid(True)
    plt.savefig(f"{filename}.png")  # Save the plot as a PNG file

if __name__ == "__main__":
    #run_simulation()
    plot_txt_file("expected_output.txt", title="Expected Output", xlabel="Sample Index", ylabel="Value") 
    plot_txt_file("fir_output.txt", title="FIR Output", xlabel="Sample Index", ylabel="Value")
    plot_txt_file("input.txt", title="Input Data", xlabel="Sample Index", ylabel="Value")

