import pandas as pd
import matplotlib.pyplot as plt
import os

# Configuration
DATA_FILE = '../data/synapse_data.csv'
FRAMES_DIR = '../frames'
os.makedirs(FRAMES_DIR, exist_ok=True)

def plot_simulation_step(df, step_index):
    """Generates and saves a single frame of the simulation visualization."""
    fig, (ax1, ax2) = plt.subplots(2, 1, figsize=(10, 8), gridspec_kw={'height_ratios': [3, 1]})
    fig.suptitle('Synaptic Plasticity Simulation', fontsize=16)

    current_time = df['time'].iloc[step_index]
    
    # --- Top Plot: Synaptic Weight Time Series ---
    ax1.plot(df['time'][:step_index+1], df['synaptic_weight'][:step_index+1], 'b-', label='Synaptic Weight')
    ax1.set_xlim(0, df['time'].max())
    ax1.set_ylim(0, 1.1)
    ax1.set_title('Synaptic Weight over Time')
    ax1.set_xlabel('Time (s)')
    ax1.set_ylabel('Weight')
    ax1.grid(True)
    ax1.axvline(x=current_time, color='r', linestyle='--', lw=1)
    ax1.legend(title=f'Time: {current_time:.2f}s', loc='upper left')

    # --- Bottom Plot: Neuronal Activity ---
    ax2.set_title('Neuronal Activity at Current Time Step')
    pre_activity = df['pre_activity'].iloc[step_index]
    post_activity = df['post_activity'].iloc[step_index]
    
    pre_color = 'red' if pre_activity > 0 else 'gray'
    post_color = 'red' if post_activity > 0 else 'gray'
    
    ax2.text(0.25, 0.5, 'Pre-Synaptic', ha='center', va='center', fontsize=12)
    ax2.add_patch(plt.Circle((0.4, 0.5), 0.1, color=pre_color))
    
    ax2.text(0.75, 0.5, 'Post-Synaptic', ha='center', va='center', fontsize=12)
    ax2.add_patch(plt.Circle((0.6, 0.5), 0.1, color=post_color))
    
    ax2.plot([0.45, 0.55], [0.5, 0.5], 'k-') # Synapse
    
    ax2.set_xlim(0, 1)
    ax2.set_ylim(0, 1)
    ax2.axis('off')

    plt.tight_layout(rect=[0, 0.03, 1, 0.95])
    
    frame_path = os.path.join(FRAMES_DIR, f'frame_{step_index:04d}.png')
    plt.savefig(frame_path)
    plt.close(fig)

def main():
    """Main function to generate all frames."""
    if not os.path.exists(DATA_FILE):
        print(f"Error: Data file not found at {DATA_FILE}")
        print("Please run the C++ simulation first.")
        return

    print("Reading simulation data...")
    df = pd.read_csv(DATA_FILE)
    
    num_frames = len(df)
    print(f"Generating {num_frames} frames...")

    for i in range(num_frames):
        plot_simulation_step(df, i)
        print(f"  ... {i + 1}/{num_frames} frames saved.", end='\r')
            
    print() # Newline after the progress bar finishes
    print(f"\nAll frames saved in '{os.path.join(os.path.dirname(__file__), FRAMES_DIR)}/'")

if __name__ == '__main__':
    main()