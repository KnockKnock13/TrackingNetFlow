% KLT_SELFEATS  Select features for KLT tracker
%   [tc,P] = klt_selfeats(tc,I,M,P) selects features from image I for
%   tracking and updates the tracking context tc. M specifies a mask of
%   pixels to consider. If P is omitted, all features are selected, else
%   only features in P which have been lost. See KLT_TRACK for description
%   of P.
%
%   See also KLT_INIT, KLT_TRACK, KLT_PARSE

function [tc,P] = klt_selfeats(tc,I,M,P)

ww=2*tc.winsize+1;

if isempty(M)
    M=true(size(I));
end

if nargin<4
    % first frame: initialize pyramid and clear points
    tc.pyramid=klt_pyramid(tc,I);
    P=zeros(3,tc.nfeats,'single');
    P(1:2,:)=-1;
    P(3,:)=tc.klt_notfound;
else
    % remove tracked points
    for i=find(P(3,:)>=0)
        c=round(P(1,i));
        r=round(P(2,i));
        M(r,c)=false;
    end
end

% remove neighbourhood of mask
M=mre_boxfilter(double(M),tc.winsize,tc.winsize)==(tc.winsize*2+1)^2;

% compute smallest eigenvalue of second moment matrix

GXX=mre_boxfilter(tc.pyramid{1}.GX.*tc.pyramid{1}.GX,tc.winsize,tc.winsize);
GYY=mre_boxfilter(tc.pyramid{1}.GY.*tc.pyramid{1}.GY,tc.winsize,tc.winsize);
GXY=mre_boxfilter(tc.pyramid{1}.GX.*tc.pyramid{1}.GY,tc.winsize,tc.winsize);

EV=klt_goodfeats(M,GXX,GYY,GXY,tc.mineigval);

% select points by decreasing eigenvalue
for i=find(P(3,:)<0)
    [m,mi]=mre_maxelem(EV);
    if m==-inf
        break
    end
    [r,c]=ind2sub(size(EV),mi);
    P(:,i)=[c ; r ; m];
    EV(max(r-tc.mindist+1,1):min(r+tc.mindist-1,size(EV,1)), ...
        max(c-tc.mindist+1,1):min(c+tc.mindist-1,size(EV,2)))=-inf;
end
