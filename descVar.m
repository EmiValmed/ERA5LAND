function [DescVar] = descVar(Var,time,nlon,nlat)

DescVar   = NaN(nlon,nlat,time,size(Var,3)/time);
Var       = reshape(Var,nlon,nlat,24,[]);
Ptdiff    = diff(Var,1,3);

DescVar(:,:,1,:)     = Var(:,:,1,:);
DescVar(:,:,2:end,:) = Ptdiff;
DescVar = reshape(DescVar,nlon,nlat,[]);
end
