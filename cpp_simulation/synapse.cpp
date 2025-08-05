#include "synapse.h"
#include <iostream>
#include <fstream>
#include <random>
#include <cmath>
#include <sstream> // Required for std::stringstream
#include <stdexcept> // Required for std::stod, std::stoi

// --- Config Class Implementation ---

// A corrected, simple JSON parser for a flat key-value structure.
void Config::parse() {
    std::ifstream file(filepath);
    if (!file.is_open()) {
        std::cerr << "Error: Could not open config file: " << filepath << std::endl;
        exit(1);
    }

    std::stringstream buffer;
    buffer << file.rdbuf();
    std::string content = buffer.str();

    size_t pos = 0;
    while (true) {
        size_t key_start = content.find('"', pos);
        if (key_start == std::string::npos) break;

        size_t key_end = content.find('"', key_start + 1);
        if (key_end == std::string::npos) break;

        std::string key = content.substr(key_start + 1, key_end - key_start - 1);

        size_t colon_pos = content.find(':', key_end);
        if (colon_pos == std::string::npos) break;

        size_t value_start = content.find_first_not_of(" \t\r\n", colon_pos + 1);
        if (value_start == std::string::npos) break;

        size_t value_end;
        std::string value;

        if (content[value_start] == '"') { // String value
            value_end = content.find('"', value_start + 1);
            if (value_end == std::string::npos) break;
            value = content.substr(value_start, value_end - value_start + 1);
            pos = value_end + 1;
        } else { // Numeric or boolean value
            value_end = content.find_first_of(",}\n\r", value_start);
            if (value_end == std::string::npos) break;
            std::string raw_value = content.substr(value_start, value_end - value_start);
            size_t last = raw_value.find_last_not_of(" \t\r\n");
            value = raw_value.substr(0, last + 1);
            pos = value_end;
        }

        //std::cout << "DEBUG: Found key: '" << key << "', value: '" << value << "'" << std::endl;
        data[key] = value;
    }
}


Config::Config(const std::string& config_path) : filepath(config_path) {
    parse();
}

double Config::get_double(const std::string& key) const {
    try {
        return std::stod(data.at(key));
    } catch (const std::out_of_range&) {
        std::cerr << "Error: Configuration key '" << key << "' not found." << std::endl;
        exit(1);
    } catch (const std::invalid_argument&) {
        std::cerr << "Error: Invalid numeric value for key '" << key << "'." << std::endl;
        exit(1);
    }
}

int Config::get_int(const std::string& key) const {
    try {
        return std::stoi(data.at(key));
    } catch (const std::out_of_range&) {
        std::cerr << "Error: Configuration key '" << key << "' not found." << std::endl;
        exit(1);
    } catch (const std::invalid_argument&) {
        std::cerr << "Error: Invalid integer value for key '" << key << "'." << std::endl;
        exit(1);
    }
}

std::string Config::get_string(const std::string& key) const {
    try {
        std::string value = data.at(key);
        // Remove quotes from string values
        if (value.length() >= 2 && value.front() == '"' && value.back() == '"') {
            return value.substr(1, value.length() - 2);
        }
        return value;
    } catch (const std::out_of_range&) {
        std::cerr << "Error: Configuration key '" << key << "' not found." << std::endl;
        exit(1);
    }
}

// --- Synapse Class Implementation ---

Synapse::Synapse(double initial_weight) : weight(initial_weight) {}

void Synapse::update(double pre_activity, double post_activity, double learning_rate, double decay_rate, double dt) {
    // Hebbian learning rule with decay: dw/dt = -alpha*w + eta*pre*post
    double dw = (-decay_rate * weight + learning_rate * pre_activity * post_activity) * dt;
    weight += dw;

    // Clamp weight between 0 and 1
    if (weight > 1.0) weight = 1.0;
    if (weight < 0.0) weight = 0.0;
}

double Synapse::get_weight() const {
    return weight;
}

// --- Simulation Class Implementation ---

Simulation::Simulation(double duration, double dt, double learning_rate, double decay_rate, double initial_weight, std::string region_name)
    : sim_duration(duration),
      dt(dt),
      learning_rate(learning_rate),
      decay_rate(decay_rate),
      synapse(initial_weight),
      region(region_name) {}

void Simulation::run() {
    // Set up random number generation for activity
    std::random_device rd;
    std::mt19937 gen(rd());
    std::uniform_real_distribution<> dis(0.0, 1.0);

    // Simulation loop
    for (double t = 0; t < sim_duration; t += dt) {
        // Generate some noisy, correlated pre- and post-synaptic activity
        double pre_activity = dis(gen) > 0.7 ? 1.0 : 0.0; // Spike with 30% probability
        double post_activity = (pre_activity > 0.5 && dis(gen) > 0.3) ? 1.0 : (dis(gen) > 0.9 ? 1.0 : 0.0); // Higher chance of post if pre fired

        synapse.update(pre_activity, post_activity, learning_rate, decay_rate, dt);

        results.push_back({t, pre_activity, post_activity, synapse.get_weight(), region});
    }
}

void Simulation::save_results(const std::string& filepath) const {
    // Write to CSV
    std::ofstream outfile(filepath);
    if (!outfile.is_open()) {
        std::cerr << "Error: Could not open output file " << filepath << std::endl;
        return;
    }

    outfile << "time,pre_activity,post_activity,synaptic_weight,region\n";

    for (const auto& data_point : results) {
        outfile << data_point.time << ","
                << data_point.pre_activity << ","
                << data_point.post_activity << ","
                << data_point.synaptic_weight << ","
                << data_point.region << "\n";
    }

    outfile.close();
}
