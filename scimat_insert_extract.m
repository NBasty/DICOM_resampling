% Author: Nicolas Basty 

function out = scimat_insert_extract(scimat_in,scimat_out,init_rec)
   % ascimat_insert_extract either extracts synthetic MRI 2D acquisitions when given a 3D
   % image as input and 2D as ouput, or inserts 2D images into a 3D array in the other case. 
   % The third, optional, input variable is to be added (just put 1) when you want overlapping
   % slices to be averaged(say for example to initialise).

%% case 1, 2D input 2D and 3D output
   % Insert slicesThis 
   % For context of the paper, this to either  initialise the image using 
   % a set of LR slices to put the residuals back into 3D space in optimisation

if numel(size(scimat_in(1).data)) == 2
   Sci_HR = scimat_out;
   out = scimat_out;
   out_size = size(Sci_HR.data); 
   out_rotmat = Sci_HR.rotmat;
   out_spacing_x = Sci_HR.axis(1).spacing;
   out_spacing_y = Sci_HR.axis(2).spacing;
   out_spacing_z = Sci_HR.axis(3).spacing;
   out_spacing = [out_spacing_x, out_spacing_y, out_spacing_z];
   out_min_x = Sci_HR.axis(1).min;
   out_min_y = Sci_HR.axis(2).min;
   out_min_z = Sci_HR.axis(3).min;
   out_min = [out_min_x, out_min_y, out_min_z];
   out_min = out_min - out_spacing/2;
   scimat_out.axis(1).min = out_min(1);
   scimat_out.axis(2).min = out_min(2);
   scimat_out.axis(3).min = out_min(3);
    for i = 1:numel(scimat_in)
       Sci_LR = scimat_in(i); %2D input
       in_size_x = Sci_LR.axis(1).size;
       in_size_y = Sci_LR.axis(2).size;
       in_size_z = Sci_LR.axis(3).size;
       in_spacing_x = Sci_LR.axis(1).spacing;
       in_spacing_y = Sci_LR.axis(2).spacing;
       in_spacing_z = Sci_LR.axis(3).spacing;
       in_spacing = [in_spacing_x, in_spacing_y, in_spacing_z];
       in_min_x = Sci_LR.axis(1).min;
       in_min_y = Sci_LR.axis(2).min;
       in_min_z = Sci_LR.axis(3).min;
       in_min = [in_min_x, in_min_y, in_min_z];
       in_min= in_min + in_spacing/2;
       in_size = round([in_size_x, in_size_y, in_size_z] ...
           .* [in_spacing_x, in_spacing_y, in_spacing_z] ./ out_spacing);
       slice_thickness = round((in_spacing_z)/(out_spacing_z));
       LR_slice_3D  = repmat(Sci_LR.data,[1 1 slice_thickness]);
       scim = scimat_in(i);
       scim.axis(1).spacing = scimat_out.axis(1).spacing;
       scim.axis(2).spacing = scimat_out.axis(2).spacing;
       scim.axis(3).spacing = scimat_out.axis(3).spacing;
       scim.axis(1).min = in_min(1);
       scim.axis(2).min = in_min(2);
       scim.axis(3).min = in_min(3);
       scim.data = real(LR_slice_3D);
       scimat_back = scimat_tformarray( scim, out_rotmat, out_size, out_spacing, out_min);
if exist('init_rec')
           % this is when I want to initialise the data at the beginning
           % of the reconstruction. It averages places where there is
           % overlap, which I don't want for the residuals at later stage.
           a = double(out.data) + double(scimat_back.data);
           la = scimat_back.data~=0;
           sa = out.data~=0;
           lsa = sa+la;
           av = a./(lsa);
           av(isnan(av))=0;
           out.data = av;
       else
           out.data = out.data + scimat_back.data;
       end
   end
end
%% case 2, 3D input 2D output  
   %  Extract slices.
if numel(scimat_in) == 1 && numel(size(scimat_in.data)) == 3
   out = scimat_out;
   out_spacing_x = scimat_in.axis(1).spacing;
   out_spacing_y = scimat_in.axis(2).spacing;
   out_spacing_z = scimat_in.axis(3).spacing;
   out_spacing = [out_spacing_x, out_spacing_y, out_spacing_z];
   out_min_x = scimat_in.axis(1).min;
   out_min_y = scimat_in.axis(2).min;
   out_min_z = scimat_in.axis(3).min;
   out_min = [out_min_x, out_min_y, out_min_z];
   out_min = out_min - out_spacing/2;
   scimat_in.axis(1).min = out_min(1);
   scimat_in.axis(2).min = out_min(2);
   scimat_in.axis(3).min = out_min(3);
  for i = 1:numel(scimat_out)
       out(i).data = [];
       Sci_LR = scimat_out(i);
       new_rotmat = Sci_LR.rotmat; % new is the LR
       in_size_x = Sci_LR.axis(1).size;
       in_size_y = Sci_LR.axis(2).size;
       in_size_z = Sci_LR.axis(3).size;
       in_spacing_x = Sci_LR.axis(1).spacing;
       in_spacing_y = Sci_LR.axis(2).spacing;
       in_spacing_z = Sci_LR.axis(3).spacing;
       in_spacing = [in_spacing_x, in_spacing_y, in_spacing_z];
       in_min_x = Sci_LR.axis(1).min;
       in_min_y = Sci_LR.axis(2).min;
       in_min_z = Sci_LR.axis(3).min;
       in_min = [in_min_x, in_min_y, in_min_z];
       in_min = in_min + in_spacing/2;
       in_spacing = out_spacing;
       in_size = round([in_size_x, in_size_y, in_size_z] ...
           .* [in_spacing_x, in_spacing_y, in_spacing_z] ./ out_spacing);
       [ slab ] = scimat_tformarray( scimat_in, new_rotmat, in_size, in_spacing, in_min);
       av = sum(slab.data,3)./sum(slab.data~=0,3);
       av(isnan(av))=0;
       out(i).data =  real(av);
   end
end
