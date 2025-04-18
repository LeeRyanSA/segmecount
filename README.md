SegmeCount by Ryan M Lee

Tentative Description. 

Automatic Cell Counter for use in ImageJ Fiji

Structure of Github repository:
Macrocode
~All version of the macro. Includes original macro and final macro, marked alonviruscounter and segmecount_final respectively.  
testimages  
~Contains raw image test files, along with the resulting counts and processed images.  
Comparisons.xlsx  
~Comparisons between each version of the Macro Codes  
README.md  
~This file.  
V5 Vs V7 Comparison Counts.xlsx  
~Using a larger set of data, comparison of processed values between the V5 and the V7.  
counter.py  
~Program to open one directory and compile each .csv count file along with the file name into a single file.  

Procedure:
1. Utilize any imaging program for your sample data, and name the files appropriately. I would recommend utilizing .tif files due to their versatility in image processing.
2. Using the imaging program, measure the scale of the image. For example, how much is 10 pixels equivalent to?
3. Open ImageJ Fiji, or install if not already. Go to Plugins/Macros/Edit, and select segmecount_final.ijm from wherever it was placed on your file system.
4. Go to line 27, and change the scale values. In the original code, it is noted to be 222.6 micrometers per 10 pixels.
5. If you know the range of size thresholds for your image, please refer to lines 55 and 56 and change the thresholds to your liking, in micrometers squared.
6. Run the Macro from the current screen. (Edit screen). Select your largest directory containing all the files you wish to count.
7. After the macro finished running, open counter.py. On the bottom, where it notes "directory_path = "/Users/orphanlab/Downloads/240829_Counts"", please change this to the path of your largest directory from step 6.
8. Run counter.py, and you will obtain a cellcounts.csv file with the associated paths of each file and the number of cells.
