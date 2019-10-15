% Author: Nicolas Basty 

function newscimat = scimat_reorientation(scimat,S)

% this function repositions a scimat stack, 
% so that the selected slice (S) is paralell with the XY plane
% make sure that the axis(3).min field is actually the slice thickness

newscimat = scimat; %initialise
R = pinv(scimat(S).rotmat); 
% S is the slice index of the slice you want 
% to have rotated into the plane.

for i = 1:numel(scimat)
    [x,y,z] = scimat_ndgrid(scimat(i));
    new = [x(:),y(:),z(:)];
    new = new*R;     
    % apply rotation to the coordinates and the rotation matrix
    newscimat(i).rotmat = scimat(i).rotmat * R;    
    newscimat(i).axis(1).min = new(1,2); 
    newscimat(i).axis(2).min = new(1,1); %X Y flip...
    newscimat(i).axis(3).min = new(1,3);
    newscimat(i).data = scimat(i).data;
end

