//V1: Changed upper_Size and lower_Size from 1.1 to 100 and 0.03 to 0.05 respectively.

//Measured Scale and set a distance of 222.6 um given 10 pixels, determined through Oculus. Originally 167.7517 um to 10 pixels. 

setBatchMode(true);
//create an array of file/image names
run("Clear Results");
roiManager("reset");
Dialog.create("Open folder containing images");
indir = getDirectory("Choose Input Directory"); 
names_list = getFileList(indir);
outdir = indir + "/masked/"
File.makeDirectory(outdir);
print(outdir);
lower_Size = 0.05;
upper_Size = 100;
for(i = 0; i < names_list.length; i++1){
    //Ensure that the file is a tif
    image = names_list[i];
    
    if (endsWith(image, ".tif")){
        open(indir + image);
        run("Set Scale...", "distance=222.6 known=10 unit=um");
        //run gaussian filter with sigma = 1
        run("Gaussian Blur...", "sigma=1");
        //run substract background 
        run("Subtract Background...", "rolling=10 sliding");
        //run gaussian filter with sigma = 2
        run("Gaussian Blur...", "sigma=2");
        //run substract background 
        run("Top Hat...", "radius=5");
        run("Auto Threshold", "method=Triangle white");
        run("Dilate");
        run("Convert to Mask");
        ///run("Analyze Particles...", "size="+ lower_Size + "-" + upper_Size + " circularity=0.2-1 show=Ellipses display add");
        run("Analyze Particles...", "size="+ lower_Size + "-" + upper_Size + " circularity=0.2-1 show=[Overlay Masks] display record add");
        run("Set Measurements...", "area mean min centroid display add nan redirect=None decimal=3");
        //Opening dialogue box to save
        //Dialog.create("Save location")
        //directory = getDirectory("Choose Output Directory");
        name = getTitle();
        //Save results, then new image; remove the .tif from original name
        shortname = substring(image, 0, lastIndexOf(image, ".tif"));
        saveAs("Results", outdir + shortname + "_counts" + ".csv");
        saveAs("tiff", outdir + shortname + "_masked");
        //save rois coordinates
        //https://forum.image.sc/t/save-xy-coordinates-for-multiple-rois/22148/9
        //numROIs=roiManager("count");
        //print(numROIs);
        
        //for (n=0; n<numROIs; n++) {
        //    nr=0;
        //  roiManager("Select", n);
        //  Roi.getCoordinates(x, y);
        //  
        //  for (j=0; j<x.length; j++) {
        //      //setResult("Label", j+nr, n);
        //      setResult("X", j+nr, x[j]);
        //      setResult("Y", j+nr, y[j]);
        //       //print("Y");
        //  }
        //nr+=x.length;
        //updateResults();
        
        //}
        //saveAs("Results", outdir + shortname + "_rois_coords" + ".csv");
        //close("ROI-Manager");
  
        
        //Clear and reset all results before running next image
        run("Clear Results");
        
        
        close(shortname + "_masked.tif");
    }
    //roiManager("deselect");
    //run("Clear Results");
    
    //roiManager("delete");
    //roiManager("reset");
}
setBatchMode(false); 
