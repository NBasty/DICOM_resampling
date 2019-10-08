function scimat = scimat_make3dframe(scimat2d,factor)
% SCIMAT_MAKE3DFRAME Generates an empty 3D scimat grid from a 2D scimat input (single image or stack) for
% use with the scimat_insert_extract.m function. The resolution will depend on the "factor" input and
% z is the resolution in the z axis in the 2D image

imsize1 = size(scimat2d(1).data,1);
imsize2 = size(scimat2d(1).data,2);
xi = zeros(imsize1,imsize2,numel(scimat2d));% initialise arrays storing the real world coordinates of each pixel of each slice
yi = xi;
zi = xi;

for sn = 1:numel(scimat2d)
   [xi(1:size(scimat2d(sn).data,1),1:size(scimat2d(sn).data,2),sn)...
       ...
   ,yi(1:size(scimat2d(sn).data,1),1:size(scimat2d(sn).data,2),sn)...
       ...
       ,zi(1:size(scimat2d(sn).data,1),1:size(scimat2d(sn).data,2),sn)] = scimat_ndgrid(scimat2d(sn));
   [x(sn),y(sn),z(sn)] = scimat2d(sn).axis.spacing;
   
end

% the ranges of xyz in real world coordinates of all images stacked together
rangex = [min(xi(:)) max(xi(:))];
rangey = [min(yi(:)) max(yi(:))];
rangez = [min(zi(:)) max(zi(:))];
% vectors with real world coordinates and stepsize by factor is the resolution
xRW = rangex(1):x(end)/factor:rangex(2);
yRW = rangey(1):y(end)/factor:rangey(2);
zRW = rangez(1):z(end)/factor:rangez(2);
[xx,yy,zz] = ndgrid(xRW,yRW,zRW);
rotation_mat = eye(3);
res = [x(end),y(end),z(end)]/factor;
offset = [yy(1,1,1),xx(1,1,1),zz(1,1,1)];
scimat = scimat_im2scimat(zeros(size(xx)),res,offset,rotation_mat);
