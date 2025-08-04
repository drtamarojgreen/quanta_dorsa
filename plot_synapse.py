# plot_synapse.py
import pandas as pd
import matplotlib.pyplot as plt
import os

data = pd.read_csv("synapse_data.csv")
os.makedirs("python_frames", exist_ok=True)

for i in range(1, len(data)):
    subset = data.iloc[:i]
    plt.figure(figsize=(6,4))
    plt.plot(subset['time'], subset['w'], label='Synaptic Weight')
    plt.ylim(min(data['w']) - 0.1, max(data['w']) + 0.1)
    plt.xlabel("Time")
    plt.ylabel("Weight")
    plt.title(f"Synaptic Plasticity (t={subset['time'].iloc[-1]:.2f}s)")
    plt.legend()
    plt.grid(True)
    plt.tight_layout()
    plt.savefig(f"python_frames/frame_{i:04d}.png")
    plt.close()
