waitForUser("ROI selection", "移動前");
Roi.getBounds(x1, y1, width1, height1);
waitForUser("ROI selection", "移動後");
Roi.getBounds(x2, y2, width2, height2);
Interval = Stack.getFrameInterval();
x_step = (x2-x1)/nSlices;
y_step = (y2-y1)/nSlices;
x = x1; y = y1; time = 0;
run("Clear Results");
for (i=0; i<nSlices; i++) {
	setResult("Time(s)", i, time);
	setSlice(i+1);
	makeRectangle(x, y, width1, height1);
	roiManager("add");//ROIの位置が後から確認できるだけ。特に意味なし。
	getStatistics(area, mean, min, max, std, histogram);
	setResult("gray scale", i, mean);
	x = x + x_step;	y = y + y_step; time = time + Interval;
}
	
