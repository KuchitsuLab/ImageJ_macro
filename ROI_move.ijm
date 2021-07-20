roiManager("reset")
while (true) {
	Slice_count = 1;
	setSlice(1);
	waitForUser("ROI selection", "Set the start point!");
	Roi.getBounds(x1, y1, width1, height1);
	slice1 = 1;
	while(true) {
		waitForUser("ROI selection", "Set the end point!");
		Roi.getBounds(x2, y2, width2, height2);
		slice2 = getSliceNumber();
		Num_of_Slice = slice2-slice1+1;
		x_step = (x2-x1)/(Num_of_Slice-1);
		y_step = (y2-y1)/(Num_of_Slice-1);
		x = x1; y = y1; 
		for (i=0; i<Num_of_Slice; i++) {
			setSlice(Slice_count);
			makeRectangle(x, y, width1, height1);
			roiManager("add");
			x = x + x_step;	y = y + y_step;
			Slice_count = Slice_count + 1;
		}
		ROIselect = newArray(Num_of_Slice);
		for(i=0; i<ROIselect.length; i++) {
			ROIselect[i] = slice1-1+i;
		}
		if (slice1==1) {
			if(slice2==nSlices) {
				waitForUser("Check the ROI manager!");
				Checknum = getNumber("OK!=>1, Don't like it...=>2", 1);
				if (Checknum==1) {
					break;
				}
				if (Checknum==2) {
					roiManager("select", ROIselect);
					roiManager("delete");
					break;
				}
			}
			else{
				waitForUser("Check the ROI manager!");
				Checknum = getNumber("OK!=>1, Don't like it...=>2", 1);
				if (Checknum==1) {
					setSlice(slice2+1);
				}
				if (Checknum==2) {
					roiManager("select", ROIselect);
					roiManager("delete");
					break;
				}
			}
		}
		else {
			if(slice2==nSlices) {
				waitForUser("Check the ROI manager!");
				Checknum = getNumber("OK!=>1, Don't like it...=>2 Reset all!!=>3", 1);
				if (Checknum==1) {
					break;
				}
				if (Checknum==2) {
					roiManager("select", ROIselect);
					roiManager("delete");
					setSlice(slice1);
					Slice_count = slice1;
				}
				if (Checknum==3) {
					roiManager("deselect");
					roiManager("delete");
					break;
				}

			}
			else{
				waitForUser("Check the ROI manager!");
				Checknum = getNumber("OK!=>1, Don't like it...=>2, Reset all!!=>3", 1);
				if (Checknum==1) {
					setSlice(slice2+1);
				}
				if (Checknum==2) {
					roiManager("select", ROIselect);
					roiManager("delete");
					setSlice(slice1);
					Slice_count = slice1;
				}
				if (Checknum==3) {
					roiManager("deselect");
					roiManager("delete");
					break;
				}
			}
		}
		if (Checknum==1) {
		slice1=Slice_count; x1=x2; y1=y2;
		}
	}
	if (slice2==nSlices && Checknum==1) {
		break;
	}
}
