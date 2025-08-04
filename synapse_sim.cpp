// synapse_sim.cpp
#include <iostream>
#include <fstream>
#include <cmath>

int main() {
    const int T = 200;
    double eta = 0.05, lambda = 0.01;
    double w = 0.0;

    std::ofstream file("synapse_data.csv");
    file << "time,x,y,w\n";

    for (int t = 0; t < T; ++t) {
        double time = t * 0.1;
        double x = sin(time * 3.14);
        double y = cos(time * 3.14);
        double dw = eta * x * y - lambda * w;
        w += dw;

        file << time << "," << x << "," << y << "," << w << "\n";
    }

    file.close();
    std::cout << "CSV data generated.\n";
    return 0;
}
