dir = getDirectory("Choose a Directory ");//入力フォルダを指定。
savedir = getDirectory("Choose a Directory ");//出力フォルダを指定。
filelist = getFileList(dir);//入力フォルダ内のファイルリストを取得。
for (i = 0; i < filelist.length; i++){ //リストアップされたファイルに対し、以下の括弧{...}で括られた命令を行う。
	open(dir+"\\"+filelist[i] );//ファイルを開く。
	run("Size...", "width=400 height=400 constrain average interpolation=Bilinear");
	saveAs("Tiff", savedir+"\\"+filelist[i]); //合成された画像をJpegとして出力フォルダに保存。
	run("Close All");
}
