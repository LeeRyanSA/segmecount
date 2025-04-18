//V1: Changed upper_Size and lower_Size from 1.1 to 100 and 0.03 to 0.05 respectively.
//V2: Measured Scale and set a distance of 222.6 um given 10 pixels, determined through Oculus. Originally 167.7517 um to 10 pixels.
//V3: Maintained and Tested Triangle White and Black thresholding techniques. 

//Changed auto threshold method to Otsu's white method from Triangle white method. Implementation of watershed segmentation. Cleaned up Code and added Comments. Added 8 bit and 16 bit channel changing to make sure file is standardized.

setBatchMode(true);
//create an array of file/image names
run("Clear Results");
roiManager("reset");
Dialog.create("Open folder containing images");
indir = getDirectory("Choose Input Directory"); 
names_list = getFileList(indir);
outdir = indir
File.makeDirectory(outdir);
print(outdir);
lower_Size = 0.05;
upper_Size = 100;
for(i = 0; i < names_list.length; i++1){
    //Ensure that the file is a tif
    image = names_list[i];
    
    if (endsWith(image, ".tif")){
        open(indir + image);


        run("8-bit"); // Convert the image to 8-bit first (for grayscale images) // Convert back to RGB stack if required (for multi-channel images)
        run("16-bit"); // Convert the image to 16-bit;
        run("Set Scale...", "distance=222.6 known=10 unit=um");
        //run gaussian filter with sigma = 1
        run("Gaussian Blur...", "sigma=1");
        //run substract background 
        run("Subtract Background...", "rolling=10 sliding");
        //run gaussian filter with sigma = 2
        run("Gaussian Blur...", "sigma=2");
        run("Top Hat...", "radius=5");
        run("Auto Threshold", "method=Otsu white");
        run("Dilate");
        run("Convert to Mask");
        run("Watershed"); //Separation (experimental)
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
        saveAs("tiff", outdir + shortname);
       
        run("Clear Results");
        close(shortname);
    }
}
setBatchMode(false); 
