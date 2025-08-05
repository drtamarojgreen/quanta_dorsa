#ifndef SYNAPSE_H
#define SYNAPSE_H

#include <vector>
#include <string>
#include <map>

// Class to handle configuration
class Config {
public:
    Config(const std::string& config_path);

    double get_double(const std::string& key) const;
    std::string get_string(const std::string& key) const;
    int get_int(const std::string& key) const;

private:
    void parse();
    std::string filepath;
    std::map<std::string, std::string> data;
};


// Simple struct to hold simulation data for each time step
struct SimData {
    double time;
    double pre_activity;
    double post_activity;
    double synaptic_weight;
    std::string region; // Name of the simulated brain region
};

// Class to represent a single synapse
class Synapse {
public:
    Synapse(double initial_weight);
    void update(double pre_activity, double post_activity, double learning_rate, double decay_rate, double dt);
    double get_weight() const;

private:
    double weight;
};

// Class to manage the simulation
class Simulation {
public:
    Simulation(double duration, double dt, double learning_rate, double decay_rate, double initial_weight, std::string region_name);
    void run();
    void save_results(const std::string& filepath) const;

private:
    // Simulation parameters
    double sim_duration;
    double dt;
    double learning_rate;
    double decay_rate;
    std::string region;

    // Simulation objects
    Synapse synapse;

    // Data storage
    std::vector<SimData> results;
};

#endif // SYNAPSE_H
