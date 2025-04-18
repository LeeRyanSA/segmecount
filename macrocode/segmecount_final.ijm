//V1: Changed upper_Size and lower_Size from 1.1 to 100 and 0.03 to 0.05 respectively.
//V2: Measured Scale and set a distance of 222.6 um given 10 pixels, determined through Oculus. Originally 167.7517 um to 10 pixels.
//V3: Maintained and Tested Triangle White and Black thresholding techniques. 
//V4: Changed auto threshold method to Otsu's white method from Triangle white method. Implementation of watershed segmentation. Cleaned up Code and added Comments. Added 8 bit and 16 bit channel changing to make sure file is standardized.
//V5: Removal of Top Hat Filter and Testing Gaussian Filter cardinality. 
//V6:Removal of the Dilation Function
//V7: Changing of Gaussian Values (utilization of Sigma 0.75 and Sigma 1.75)

setBatchMode(true);

// Function to process a directory and its subdirectories
function processDirectory(dir, outdir) {
    names_list = getFileList(dir); 

    for (i = 0; i < names_list.length; i++) {
        image = names_list[i];
        currentPath = dir + image;
       
        if (endsWith(image, ".tif")) {
            processedImagePath = outdir + substring(image, 0, lastIndexOf(image, ".tif")) + "_processed.tif"; // Define processed file path

           
            if (File.isDirectory(currentPath)) {
                processDirectory(currentPath + "/", outdir);  // Recursively process subdirectories
            } else {  
                if (File.exists(processedImagePath)) {
                    print("Skipping already processed file: " + image);
                    continue;  
                }

                open(currentPath);

                run("8-bit"); // Convert the image to 8-bit first (for grayscale images) 
                run("16-bit"); // Convert the image to 16-bit;
                run("Set Scale...", "distance=222.6 known=10 unit=um");
                run("Gaussian Blur...", "sigma=0.75"); // Run Gaussian filter with sigma = 0.75
                run("Subtract Background...", "rolling=10 sliding");
                run("Gaussian Blur...", "sigma=1.75"); // Run Gaussian filter with sigma = 1.75
                run("Convert to Mask");
                run("Watershed"); // Separation (experimental)
                run("Analyze Particles...", "size=" + lower_Size + "-" + upper_Size + " circularity=0.2-1 show=[Overlay Masks] display record add");
                run("Set Measurements...", "area mean min centroid display add nan redirect=None decimal=3");
                
                name = getTitle();
                shortname = substring(image, 0, lastIndexOf(image, ".tif"));
                saveAs("Results", outdir + shortname + "_counts" + ".csv");  // Save result CSV to the processed folder
                saveAs("Tiff", outdir + shortname + "_processed.tif");  // Save processed image to the processed folder
                roiManager("reset");
                run("Clear Results");
                close(name);
            }
        }
    }
}


Dialog.create("Open folder containing images");
indir = getDirectory("Choose Input Directory"); 
outdir = indir + "/processed/";  
File.makeDirectory(outdir);
print(outdir);

lower_Size = 0.05;
upper_Size = 100;

processDirectory(indir, outdir);

setBatchMode(false);
