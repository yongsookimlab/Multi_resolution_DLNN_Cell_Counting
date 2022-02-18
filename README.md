
# Multi Resolution DLNN Cell Counting
This code here is designed to create cell counting from limited human annotation and populate it to multiple sample. Finnaly document them under the Allen CCF ROIs.

## How to use
- Following the numerical folder to do each step from training the DLNN to finnally using it.
- The finnal registration require asset from here https://kimlab.io/data_share/files/NVU_young/Code_S3_Multi_resolution_DLNN_Cell_Counting.zip

## Limitations
- The brain need to oriented as x(image top to down) = D->V, y(image left to right)  = L->R, z(image stack) = P->A.
- The image need to be exact dimetion as the Allen CCF
- The input image can be 10x10x10 um or 20x20x20 um (or 20x20x50 with our particular padding)

## Environment
Matlab 2019a
Python 3
Tensorflow 2.0

## Liscense
Free academic use.
