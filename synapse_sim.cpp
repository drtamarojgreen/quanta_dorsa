#include <iostream>
#include <fstream>
#include <vector>
#include <string>
#include <random>
#include <cmath>

// Simulation parameters
const double SIM_DURATION = 10.0; // seconds
const double DT = 0.01;           // time step
const double LEARNING_RATE = 0.5;
const double DECAY_RATE = 0.1;

// Simple struct to hold simulation data for each time step
struct SimData {
    double time;
    double pre_activity;
    double post_activity;
    double synaptic_weight;
};

int main() {
    // Set up random number generation for activity
    std::random_device rd;
    std::mt19937 gen(rd());
    std::uniform_real_distribution<> dis(0.0, 1.0);

    // Data storage
    std::vector<SimData> results;
    double synaptic_weight = 0.5; // Initial weight

    // Simulation loop
    for (double t = 0; t < SIM_DURATION; t += DT) {
        // Generate some noisy, correlated pre- and post-synaptic activity
        double pre_activity = dis(gen) > 0.7 ? 1.0 : 0.0; // Spike with 30% probability
        double post_activity = (pre_activity > 0.5 && dis(gen) > 0.3) ? 1.0 : (dis(gen) > 0.9 ? 1.0 : 0.0); // Higher chance of post if pre fired

        // Hebbian learning rule with decay: dw/dt = -alpha*w + eta*pre*post
        double dw = (-DECAY_RATE * synaptic_weight + LEARNING_RATE * pre_activity * post_activity) * DT;
        synaptic_weight += dw;

        // Clamp weight between 0 and 1
        if (synaptic_weight > 1.0) synaptic_weight = 1.0;
        if (synaptic_weight < 0.0) synaptic_weight = 0.0;

        results.push_back({t, pre_activity, post_activity, synaptic_weight});
    }

    // Write to CSV
    std::ofstream outfile("../data/synapse_data.csv");
    if (!outfile.is_open()) {
        std::cerr << "Error: Could not open output file ../data/synapse_data.csv" << std::endl;
        std::cerr << "Please ensure the 'data' directory exists at the project root." << std::endl;
        return 1;
    }

    outfile << "time,pre_activity,post_activity,synaptic_weight\n";

    for (const auto& data_point : results) {
        outfile << data_point.time << "," << data_point.pre_activity << "," << data_point.post_activity << "," << data_point.synaptic_weight << "\n";
    }

    outfile.close();
    std::cout << "C++ simulation finished. Data saved to ../data/synapse_data.csv" << std::endl;

    return 0;
}