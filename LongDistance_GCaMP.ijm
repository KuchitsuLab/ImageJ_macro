//解析したい動画があるフォルダを選択
opendir = getDirectory("Choose a Directory to OPEN")
;
foldername = File.getName(opendir);
//結果を出力するフォルダを選択
savedir = getDirectory("Chopse a Directory to SAVE")+"\\"+foldername;
moviedir = savedir+"\\movie"
;
ROIimagedir = savedir+"\\ROIimage"
ROI = getNumber("Enter the number of ROIs you want to make", 2)
File.makeDirectory(savedir);//保存先フォルダの作成
File.makeDirectory(moviedir);
File.makeDirectory(ROIimagedir);

filelist = getFileList(opendir);//ファルダ内のファイル名リストを参照元ディレクトリから配列で取得
run("Close All");
roiManager("reset");//roimanagerに既に登録されているROIを削除
run("Clear Results");//Result table上の数値をクリア
//フォルダにある動画ファイルを二つずつ開いていく(RFP⇒GFPの順に撮影されている前提)
for (k=0; k<filelist.length; k=k+2) {
	filename = File.getNameWithoutExtension(opendir+"\\"+filelist[k+1]);
	open(opendir+"\\"+filelist[k]);
	rename("RFP");
	run("Z Project...", "projection=[Average Intensity]");
	open(opendir+"\\"+filelist[k+1]);
	rename("GFP");//ImageCalculatorとzprojectで画像処理
	run("Z Project...", "stop=20 projection=[Average Intensity]");
	selectWindow("GFP");
	for (i=0; i<=ROI-1; i++) {
		waitForUser("ROI selection", "Create a ROI");
		roiManager("add");
	}//ROIを手動で選択するとROImanagerに登録してくれる。
	Interval = Stack.getFrameInterval();
	if(Interval==0) {
		Interval = 1;
	}//たまに時間の情報がなくなる時があるのでそのケア
	time = newArray(nSlices);
	for (i=0; i<nSlices; i++) {
		time[i] = i*Interval;
	}
	for (i=0; i<time.length; i++) {
		setResult(filename+":time", i, time[i]);
	}	
	for (i=0; i<=ROI-1; i++) {
		ROInumber = filename+":ROI"+i+1;
		ratio = ratio_calculator(i);
		for(j=0; j<ratio.length; j++) {
			setResult(ROInumber, j, ratio[j]); 
		}
	}
	close("AVG_GFP");
	close("AVG_RFP");
	if (ROI==1) {
		setResult(filename+":distance", 0, 0);
	}
	else {
		for (i=0; i<ROI-1; i++) {
			length = ROI_distance(i);
			setResult(filename+":distance", i, length);
		}	
	}
	ROIimagesave(k);
	roiManager("reset");
	moviesave(k);
	run("Close All");
}

//(ΔF/F)/mCherryを計算ーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーー
function ratio_calculator(a){
	selectWindow("GFP");
	roiManager("select", a);
	GFP = newArray(nSlices);
	for (i=0; i<nSlices; i++) {
		setSlice(i+1);
		getStatistics(area, mean); 
		GFP[i] = mean;
	}
	selectWindow("AVG_GFP");
	roiManager("select", a);
	getStatistics(area, mean1);
	selectWindow("AVG_RFP");
	roiManager("select", a);
	getStatistics(area, mean2);
	ratio = newArray(GFP.length);
	for (i=0; i<GFP.length; i++) {
		ratio[i] = ((GFP[i]-mean1)/mean1)/mean2;
	}
	return ratio;
}
//ROI情報入りの画像を保存ーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーー
function ROIimagesave(a){
	selectWindow("GFP");
	run("Z Project...", "projection=[Average Intensity]");
	setMinAndMax(0, 20);
	run("Apply LUT");
	run("Scale Bar...", "width=3000 height=10 font=30 color=White background=None location=[Lower Right] bold overlay");
	roiManager("deselect");
	roiManager("Set Line Width", 5);
	roiManager("Show All");
    Overlay.flatten
	saveAs("Jpeg", ROIimagedir+"\\"+filelist[a]);
	close();
	close("AVG_GFP");
}

//ROI感の距離を取得ーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーー
function ROI_distance(a) {
	roiManager("select", a);
	Roi.getBounds(x1, y1, width, height);
	roiManager("select", a+1);
	Roi.getBounds(x2, y2, width, height);
	makeLine(x1, y1, x2, y2);
	length = getValue("Length"); 
	return length;
}

//動画を軽量化して保存ーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーー
function moviesave(a){
	selectWindow("GFP");
	setMinAndMax(0, 255);
	makeLine(0, 0, 0, 0);
	run("Size...", "width=400 height=400 constrain average interpolation=Bilinear");
	saveAs("Tiff", moviedir+"\\"+filelist[a+1]);
	selectWindow("RFP");
	run("Size...", "width=400 height=400 constrain average interpolation=Bilinear");
	saveAs("Tiff", moviedir+"\\"+filelist[a]);
}
