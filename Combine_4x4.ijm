opendir = getDirectory("Choose a open directory");
savedir = getDirectory("Choose a save directory");
filelist = getFileList(opendir);
count = 0;
for(i=1; i<=4; i=i+1){
	if(count>=filelist.length){
		break;
	}
	open(opendir+"\\"+filelist[count]);
	rename("Combine");
	depth0 = nSlices;
	run("Size...", "width=400 height=400 depth=depth0 constrain average interpolation=Bilinear");
	for(j=1; j<4; j=j+1){
		count = count + 1;
		if(count>=filelist.length){
			break;
		}
		open(opendir+"\\"+filelist[count]);
		rename(1);
		depth0 = nSlices;
		run("Size...", "width=400 height=400 depth=depth0 constrain average interpolation=Bilinear");
		run("Combine...", "stack1=[Combine] stack2=[1]");
		rename("Combine");
	}
	saveAs("Tiff", savedir+"\\Combine"+i);
	run("Close All");
	count = count + 1;
}
