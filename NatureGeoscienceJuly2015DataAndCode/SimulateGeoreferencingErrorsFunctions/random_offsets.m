function [ dx dy ] = random_offsets(mn,sd,s,n)
%    1/s goes from meters to pixels
mnpix = mn/s;
sdpix = sd/s;
dx = mn + sdpix * normrnd(0,1,n,1);
dy = mn + sdpix * normrnd(0,1,n,1);

end

