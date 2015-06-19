function depth_file = depth_extract_v3( yr,mo,day,B )
%   Used in Nature Geoscience paper, July, 2015
%   Rob Wesson
%   B is matlab Nmea file
nrec= length(B);
irec = 1;
for i=1:nrec
    if B(i,1) == 1 | B(i,1) == 2 | B(i,1) == 5 | B(i,1) == 3
        A(irec,:) = B(i,:);
        irec = irec + 1;
    end
end
idep = find(A(:,1)==3);
ndep = length(idep)
for j=1:ndep
    if idep(j)~=1 && idep(j)~=idep(ndep)
        t1 = datenum(yr,mo,day,A(idep(j)-1,2),A(idep(j)-1,3),A(idep(j)-1,4));
        t2 = datenum(yr,mo,day,A(idep(j)+1,2),A(idep(j)+1,3),A(idep(j)+1,4));
        depth_file(j,1) = (t1 + t2)/2;
        depth_file(j,2) = (A(idep(j)-1,5) + A(idep(j)+1,5))/2;
        depth_file(j,3) = (A(idep(j)-1,6) + A(idep(j)+1,6))/2;
        depth_file(j,4) = A(idep(j),7);
    else
        depth_file(j,1) = NaN;
        depth_file(j,2) = NaN;
        depth_file(j,3) = NaN;
        depth_file(j,4) = NaN;

    end
end
depth_file(1,:) = [];
depth_file(length(depth_file),:) = [];