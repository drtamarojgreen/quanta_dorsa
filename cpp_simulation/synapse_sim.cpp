#include "synapse.h"
#include <iostream>
#include <string>

int main(int argc, char* argv[]) {
    // --- Configuration Loading ---
    if (argc != 2) {
        std::cerr << "Usage: " << argv[0] << " <path_to_config.json>" << std::endl;
        return 1;
    }
    std::string config_path = argv[1];
    Config config(config_path);

    // Load parameters from config object
    const double sim_duration = config.get_double("sim_duration");
    const double dt = config.get_double("dt");
    const double learning_rate = config.get_double("learning_rate");
    const double decay_rate = config.get_double("decay_rate");
    const double initial_weight = config.get_double("initial_weight");
    const std::string region = config.get_string("region");

    // --- Simulation Setup ---
    // Construct output path based on region
    std::string output_file = "../data/synapse_data_" + region + ".csv";

    // Create the simulation object
    Simulation sim(sim_duration, dt, learning_rate, decay_rate, initial_weight, region);

    // --- Execution ---
    std::cout << "Running simulation for region: '" << region << "'..." << std::endl;
    sim.run();
    sim.save_results(output_file);

    std::cout << "C++ simulation for region '" << region << "' finished. Data saved to " << output_file << std::endl;

    return 0;
}