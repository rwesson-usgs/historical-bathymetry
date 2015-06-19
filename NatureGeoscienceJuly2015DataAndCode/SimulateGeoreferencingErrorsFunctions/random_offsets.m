function [ dx dy ] = random_offsets(mn,sd,s,n)
%   Used in Nature Geoscience paper, July, 2015
%   Rob Wesson
%    1/s goes from meters to pixels
mnpix = mn/s;
sdpix = sd/s;
dx = mn + sdpix * normrnd(0,1,n,1);
dy = mn + sdpix * normrnd(0,1,n,1);

end

