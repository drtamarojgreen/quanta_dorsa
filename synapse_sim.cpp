#include <iostream>
#include <fstream>
#include <vector>
#include <string>
#include <random>
#include <algorithm> // For std::clamp
#include <stdexcept> // For std::stod exceptions
#include <cmath>

// Simple struct to hold simulation data for each time step
struct SimData {
    double time;
    double pre_activity;
    double post_activity;
    double synaptic_weight;
};

int main(int argc, char* argv[]) {
    // Default simulation parameters
    double learning_rate = 0.5;
    double decay_rate = 0.1;
    double sim_duration = 10.0; // seconds
    const double DT = 0.01;     // time step

    // --- Argument Parsing ---
    if (argc != 1 && argc != 4) {
        std::cerr << "Usage: " << argv[0] << " [learning_rate decay_rate sim_duration]" << std::endl;
        return 1;
    }
    if (argc == 4) {
        try {
            learning_rate = std::stod(argv[1]);
            decay_rate = std::stod(argv[2]);
            sim_duration = std::stod(argv[3]);
        } catch (const std::invalid_argument& ia) {
            std::cerr << "Error: Invalid argument. Please provide numbers." << std::endl;
            return 1;
        }
    }

    // Set up random number generation for activity
    std::random_device rd;
    std::mt19937 gen(rd());
    std::uniform_real_distribution<> dis(0.0, 1.0);

    std::vector<SimData> results;
    double synaptic_weight = 0.5; // Initial weight

    // Simulation loop
    for (double t = 0; t < sim_duration; t += DT) {
        double pre_activity = dis(gen) > 0.7 ? 1.0 : 0.0;
        double post_activity = (pre_activity > 0.5 && dis(gen) > 0.3) ? 1.0 : (dis(gen) > 0.9 ? 1.0 : 0.0);
        double dw = (-decay_rate * synaptic_weight + learning_rate * pre_activity * post_activity) * DT;
        synaptic_weight += dw;
        synaptic_weight = std::clamp(synaptic_weight, 0.0, 1.0);
        results.push_back({t, pre_activity, post_activity, synaptic_weight});
    }

    // Write to CSV
    std::ofstream outfile("../data/synapse_data.csv");
    if (!outfile.is_open()) {
        std::cerr << "Error: Could not open output file ../data/synapse_data.csv" << std::endl;
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