Slice = 1;
setSlice(1);
while (true) {
	waitForUser("ROI selection", "移動前");
	Roi.getBounds(x1, y1, width1, height1);
	slice1 = getSliceNumber();
	waitForUser("ROI selection", "移動後");
	Roi.getBounds(x2, y2, width2, height2);
	slice2 = getSliceNumber();
	Num_of_Slice = slice2-slice1+1;
	x_step = (x2-x1)/(Num_of_Slice-1);
	y_step = (y2-y1)/(Num_of_Slice-1);
	x = x1; y = y1; 
	for (i=0; i<Num_of_Slice; i++) {
		setSlice(Slice);
		makeRectangle(x, y, width1, height1);
		roiManager("add");
		x = x + x_step;	y = y + y_step;
		Slice = Slice + 1;
	}
	waitForUser("ROIをチェック!");
	Checknum = getNumber("OK→1, 追加→2, やり直し→3", 1);
	if (Checknum==1) {
		break;
	} 
	if (Checknum==2) {
		setSlice(Slice+1);
	}
	if (Checknum==3) {
		roiManager("deselect");
		roiManager("delete");
		setSlice(1);
		Slice = 1;
	}
}