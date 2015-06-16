function abcd = find_transformations_v3(r,s,r0,s0,r1,s1,p0,p1,q0,q1,xim,yim)
%
%   Find transformation from pixel to utm  by
%   solving lsq matrix equation 


b= [r1;s1]
n = length(p1)
A = [p1' -q1';q1' p1']
ab = lsqr(A,b)
eps - b - A*ab
rms = sqrt((b - A*ab)'*(b-A*ab))/length(b)
abcd = [ab;0;0];

%   Transform pixel coords to utm
[ xutm yutm ] = simtrans_v2(xim,yim,p0,q0,r0,s0,abcd);

end

