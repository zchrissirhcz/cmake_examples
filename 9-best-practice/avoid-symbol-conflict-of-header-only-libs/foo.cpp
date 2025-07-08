# include <iostream>
# include <Eigen/Core>

#include <random>




using namespace std;
using namespace Eigen;

#define MATRIX_SIZE 5

int main(int argc, char **argv) {
    std::random_device rd;                          
    std::default_random_engine generator(rd());    
    std::uniform_real_distribution<double> distribution(-1.0, 1.0); 


    cout.precision(3);

    MatrixXd bigMatrix(MATRIX_SIZE, MATRIX_SIZE);

    for (int i = 0; i < MATRIX_SIZE; ++i) {
        for (int j = 0; j < MATRIX_SIZE; ++j) {
            bigMatrix(i, j) = distribution(generator);
        }
    }

    cout << "The big matrix: \n" << bigMatrix << endl;

    Matrix3d extractedBlock = bigMatrix.block<3,3>(0,0);

    cout << "The extracted matrix block: \n" << extractedBlock << endl;

    extractedBlock.setIdentity();

    cout << "The assigned matrix block: \n" << extractedBlock << endl;

    return 0;
}

