opendir = getDirectory("出力フォルダ");
filelist = getFileList(opendir);
savedir = getDirectory("保存フォルダ");
run("Clear Results");//ROImanagerに動くROIを登録
for (i=0; i<filelist.length; i++) {
	open(opendir+"\\"+filelist[i]);
	title = getTitle();
	rename("original");
	run("*8-bit");
	run("Duplicate...", "title=RFP duplicate channels=1");
	run("Magenta");
	selectWindow("original");
	run("Duplicate...", "title=GFP duplicate channels=2");
	run("Green");
	setMinAndMax(0, 100);
	selectWindow("original");
	close();
	run("Merge Channels...", "c2=GFP c6=RFP create keep");
		getLocationAndSize(x, y, width0, height0);
	rewidth = width0/4 ; reheight = height0/4;
	run("Size...", "width=rewidth height=reheight constrain average interpolation=Bilinear");
	run("*Scale Bar...","width=10 height=8 font=14 color=White background=None location=[Lower Right] overlay");
	Stack.setFrameRate(50);
	saveAs("AVI", savedir+"//"+title);
	selectWindow("Merged");
	close();
	//ここから測定------------------------------------------------
	run("ROI move");
	selectWindow("RFP");
	time = 0;
	for (j=0; j<nSlices; j++) {
		setResult(title+":Time(s)", j, time);
		selectWindow("RFP");
		roiManager("select", j);
		getStatistics(area1, mean1, min1, max1, std1, histogram1);
		setResult(title+"RFP", j, mean1);
		selectWindow("GFP");
		roiManager("select", j);
		getStatistics(area2, mean2, min2, max2, std2, histogram2);
		setResult(title+"GFP", j, mean2);
		ratio = mean2/mean1;
		setResult(title+"ratio", j, ratio);
		time = time + Interval;
	}//roi内のgray value測定
	roiManager("deselect");
	roiManager("delete");
	run("Close All");
	setBatchMode(false);
}
