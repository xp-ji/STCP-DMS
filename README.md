# STCP-DMS

### Introduction
This code is an MATLAB implementation of the paper: "[Spatio-temporal cuboid pyramid for action recognition using depth motion sequences](https://doi.org/10.1109/ICACI.2016.7449827)".

### Dependency
This code requires MATLAB, tested on 64-bit Windows with MATLAB R2015a. It depends on [LIBLINEAR](http://www.csie.ntu.edu.tw/~cjlin/liblinear/)  as a linear classifier, which has been contained in the folder `./LibMatlab`. 

### Running examples
The code is setted up for the [MSR Action 3D](https://www.uow.edu.au/~wanqing/#Datasets) dataset by default. 
1. Download the MSRAction3D dataset from [https://www.uow.edu.au/~wanqing/#Datasets](https://www.uow.edu.au/~wanqing/#Datasets). And then decompress the file `Depth.rar` to the directory of this code; 
2. Run the file `bin2mat.m` to convert the orginal binary file `*.bin` to MATLAB matrix file `*.mat`; 
3. Run the file `main.m`, and you will get the final result after several minutes: 
```
...
Accuracy = 94.5455% (260/275)
...
```

### Related Publication
If this code is useful for you, please consider citing our paper: 
>X. Ji, J. Cheng, and W. Feng, "Spatio-temporal cuboid pyramid for action recognition using depth motion sequences," in *2016 Eighth International Conference on Advanced Computational Intelligence (ICACI)*, 2016, pp. 208-213.









