% Author: Nicolas Basty 

function [scimatfile] = scimat_squeeze_time(scimatfile,frame)
% squeeze obsolete time dimension 
       for k = 1:numel(scimatfile)
           scimatfile(k).axis(4) = [];
           scimatfile(k).axis(3).size = 1;
           scimatfile(k).data = squeeze(scimatfile(k).data(:,:,frame));
       end
end
