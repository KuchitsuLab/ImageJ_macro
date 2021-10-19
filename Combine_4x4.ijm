opendir = getDirectory("Choose a open directory");
savedir = getDirectory("Choose a save directory");
filelist = getFileList(opendir);
count = 0;
column = 1+filelist.length/4
for(i=1; i<=column; i=i+1){
	open(opendir+"\\"+filelist[count]);
	rename("Combine");
	depth0 = nSlices;
	run("Size...", "width=250 height=250 depth=depth0 constrain average interpolation=Bilinear");
	for(j=1; j<4; j=j+1){
		count = count + 1;
		if(count>=filelist.length){
			break;
		}
		open(opendir+"\\"+filelist[count]);
		rename(1);
		depth0 = nSlices;
		run("Size...", "width=250 height=250 depth=depth0 constrain average interpolation=Bilinear");
		run("Combine...", "stack1=[Combine] stack2=[1]");
		rename("Combine");
	}
	saveAs("Tiff", savedir+"\\Combine"+i);
	run("Close All");
	count = count + 1;
	if(count>=filelist.length){
		break;
	}

}

