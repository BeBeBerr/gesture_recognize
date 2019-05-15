# Gesture Recognize

A hand gesture recognizer implementation in Matlab.

## Authors

- Christopher Whetsel

- Luyuan Wang

(University of Missouri - Columbia)

## Abstract

We propose a vision-based method for hand gesture classification in a video stream from 
a single camera using a hand detection module and static hand gesture classifier. 
The hand detection model uses skin threshold, and a sliding window binary hand classifier 
operating on the PCA reduced LBP feature space of the image. The hand gesture classifier 
also uses PCA to reduce the combined LBP-HOG feature space of the detected hand image. 
Different classifiers are considered for gesture classification.

