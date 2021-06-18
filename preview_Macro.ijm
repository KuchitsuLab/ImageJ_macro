inputDir = getDirectory("Choose the input directory");
outputDir = getDirectory("Choose the output directory");
setBatchMode(true);
listdir = getFileList( inputDir );
for (i = 0; i < listdir.length; i++) {
        path = inputDir + listdir[i];
        if ( File.isDirectory(  path  )  ) {
                run("Image Sequence...", "open=" + path + " sort");
                run("8-bit"); 
                run("Make Composite", "display=Composite");
                run("Next Slice [>]");
                run("Green");
                run("Enhance Contrast", "saturated=0.35");
                run("Next Slice [>]");
                run("Magenta");
                run("Enhance Contrast", "saturated=0.35");
                Stack.setActiveChannels("011");
                str=listdir[i];
                str2=replace(str,"/", "_prev");
                saveAs("JPEG", outputDir + str2);
                close();
        }
}