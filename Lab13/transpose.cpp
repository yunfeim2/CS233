#include <algorithm>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <iostream>
#include "transpose.h"
using namespace std;

// will be useful
// remember that you shouldn't go over SIZE
using std::min;

// modify this function to add tiling
void
transpose_tiled(int **src, int **dest) {
    int tiling = 50;
    int size_tiling = SIZE / tiling;
    for(int i = 0; i <= size_tiling; i++){
        for(int j = 0; j <= size_tiling; j++){
            if(((i + 1) * tiling <= SIZE) && ((j + 1) * tiling <= SIZE)){
                for(int k = 0; k < tiling ; k ++){
                    for(int h = 0; h < tiling; h ++){
                        dest[i * tiling + k][j * tiling + h] = src[j * tiling + h][i * tiling + k];
                    }
                }   
            }else if(((i + 1) * tiling > SIZE) && ((j + 1) * tiling <= SIZE)){
                for(int k = 0; k < SIZE % tiling; k ++){
                    for(int h = 0; h < tiling; h ++){
                        dest[i * tiling + k][j * tiling + h] = src[j * tiling + h][i * tiling + k];
                    }
                }
            }else if(((i + 1) * tiling <= SIZE) && ((j + 1) * tiling > SIZE)){
                for(int k = 0; k < tiling; k ++){
                    for(int h = 0; h < SIZE % tiling; h ++){
                        dest[i * tiling + k][j * tiling + h] = src[j * tiling + h][i * tiling + k];
                    }
                }
            }else{
                for(int k = 0; k < SIZE % tiling; k ++){
                    for(int h = 0; h < SIZE % tiling; h ++){
                        dest[i * tiling + k][j * tiling + h] = src[j * tiling + h][i * tiling + k];
                    }
                }
            }
        }
    }
}
