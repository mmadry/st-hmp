SPATIO-TEMPORAL HIERARCHICAL MATCHING PURSUIT SOFTWARE
=======================================================
This package contains implementation of the Spatio-Temporal Hierarchical Matching Pursuit (ST-HMP) descriptor presented in the following paper:
[1] Marianna Madry, Liefeng Bo, Danica Kragic, Dieter Fox, "ST-HMP: Unsupervised Spatio-Temporal Feature Learning for Tactile Data". In IEEE International Conference on Robotics and Automation (ICRA), May 2014
Download: http://www.nada.kth.se/~madry/publications/madry2014ICRA.pdf

The code was developed by Marianna Madry (marianna.madry@gmail.com) at the Royal Institute of Technology (KTH), Sweden and the University of Washington, WA, USA.
It is released under the BSD license.


DEMO
=================
We provide implementation of a complete classification system in which 3D data matrices (spatio-temporal sequences) are represented using the ST-HMP descriptor. Alternatively, 2D data matrices (spatial signal, such as images) can be represented using the HMP descriptor. 

Demo shows how to use the ST-HMP for an object classification task based on sequences of real tactile data. It consists of two parts: 
- Learning and extracting of:
   -- Hierarchical Matching Pursuit (HMP) descriptor
   -- Spatio-Temporal Hierarchical Matching Pursuit (ST-HMP) descriptor
- Training and testing using SVM classifiers

Running demo: 
  - demo includes two external dependencies: liblinear and ksvdbox. To recompile the mex codes, please follow instructions in these packages
  - in order to run demo, please execute file: ./code/demo_HMP_STHMP.m
  - system parameters are described in files in the directory ./code/parameters
  - generated results will be saved in directory ./output
  - demo was tested for Linux and Matlab R2011b. If any problems occur, please send an email to Marianna Madry (marianna.madry@gmail.com)

The implementation of the HMP descriptor is based on the Multipath Hierarchical Matching Pursuit software by Liefeng Bo (liefengbo@gmail.com) downloaded from: http://research.cs.washington.edu/istc/lfb/software/hmp/mhmp_cvpr.zip

INPUT FILE FORMAT
------------------
* Training and testing list:
  - in each line specify
    class_label path_to_data_file
    
    For example, as in file ./data/Drimus12RAS_schunk_dexterous/format:mat/_setup/train.list
    0 ../data/Drimus12RAS_schunk_dexterous/format:mat/BALL_RUBBER/grasp-1300209406.mat
    1 ../data/Drimus12RAS_schunk_dexterous/format:mat/BALSAM/grasp-1300210231.mat
    
    - 'class_label' should be between 0-9
    - paths to your own train and test list files can be set in: ./code/parameters/set_file_paths.m 

* Sensory data format:
 - example of data file: ./data/Drimus12RAS_schunk_dexterous/format:mat/BALSAM/grasp-1300210231.mat
 - data file contains:
    - input data saved as 3D matrix 
      In the demo: data from six tactile sensors are saved in a structure 'TS' that contains six 3D matricies: TS{1}, TS{2}, .., TS{6} 
		   data from joint angles are saved in 'JS' 3D matrix (but these data are not used in the demo)
    - sequence length 
      In the demo: 'seqLength', it is also equal to 'size(TS{1},3)'
      

DATASET
=================
Tactile data were collected for five objects using the 3-finger Schunk Dexerous hand with three proximal (14x6 pixels) and three distal (13x6 pixels) tactile sensors. 
Data in text format can be found in ./data/Drimus12RAS_schunk_dexterous/format:txt. The same data in Matlab format can be found in ./data/Drimus12RAS_schunk_dexterous/format:mat 

The dataset was collected by Alin Drimus (drimus@mci.sdu.dk). Please directly contact Alin Drimus to obtain the complete database for 10 object categories.
Detailed description of the dataset can be found in:

[2] Alin Drimus, Gert Kootstra, Arne Bilberg, Danica Kragic, "Design of a flexible tactile sensor for classification of rigid and deformable objects", In the Robotics and Autonomous Systems, 2012
.

