mex -I/meleze/data0/local/include ...
    -lz -ldl ...
    /meleze/data0/local/lib/libmediainfo.a ...
    /meleze/data0/local/lib/libzen.a ...
    -D_UNICODE ...
    -outdir mex mex/mexMediaInfo.cpp
mex -O -outdir klt klt/klt_goodfeats.cxx
mex -O -outdir klt klt/klt_trackfeat.cxx
mex -O -outdir klt klt/klt_mextrack.cxx
mex -O -outdir klt klt/mre_boxfilter.cxx
mex -O -outdir klt klt/mre_maxelem.cxx
compile_ubdetector
compile_faceDetector
