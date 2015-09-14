# Image Registration by Learning Common Feature
This is part of the research project for medical image registration. The paper of this project is accepted by Machine Learning in Medical Image. 

# Structure of ./5-fold_experiment

Functions in the folder ./5-fold_experiment/utility/ written by Hongkun Ge and All the codes cited by other authors have been given clear indication for copyright.

## ./
- demo_1.m    Test the feature of CT and MR images.
- demo_2.m    Overall training and testing process of CT and MR IMAGES in a 5-fold manner. 
- demo_3.m    Kernel CCA training demo. 
- demo_4.m    Kernel CCA testing demo. 
- demo_5.m    Training the alpha1 and alpha2.
- test.m      Training and testing process in one-fold experiment.

## utility/
The folder includes all the functions I used when training and testing kernel CCA. All the important functions are annotated with explanatory notes. 

## utility/freezeColors_v23_cbfreeze/
The folder contains tools for adjust the color bar of the similarity map.

## Script/
The folder includes the experiments of all the methods for comparison.


