% Author: Nicolas Basty 
% This file shows how to use the scimat_insert_extract function, 
% as well as how to load DICOM into the scimat format. 

% addpath '/home/user/gerardus/' 
% make sure the gerardus library has been added

% this particular dataset can be downloaded from here by anybody with an account
% https://www.kaggle.com/c/second-annual-data-science-bowl/data

% cd('Kaggle_test_directory')
cd('test\1000\study')

series = dir; % list all the series
  % every subject has several series (acquisitions) 
  % 2ch_ and 4ch_ are the two- and four-channel long axis slices
  % sax_ are short axis slices
  % Normally there are 1-3 long axis slices and around 10 short axis slices
  % The kaggle data is very noisy, unfortunately

ct = 0;

for s = 3:length(series)

    cd(series(s).name)
    filenames = dir; 
      % get all filenames in current series directory
      % here every file is a frame the cine MRI movie 
    ct = ct+1;
    dicom(ct).data = dicomread(filenames(3).name); 
    dicom(ct).info = dicominfo(filenames(3).name); % 3 corresponds to the 1st frame
    
    dummy = dcm2scimat(dicom(ct).data,dicom(ct).info,'slice');
    cardiac_scimat(ct).axis = dummy.axis;
    cardiac_scimat(ct).data = (mat2gray(dummy.data));
    cardiac_scimat(ct).rotmat = dummy.rotmat;
    cardiac_scimat(ct) = scimat_squeeze_time(cardiac_scimat(ct),1);
    
    cd .. %move out of the series folder
    
    cardiac_scimat_iso(ct) = cardiac_scimat(ct);
    cardiac_scimat_iso(ct).axis(3).spacing = cardiac_scimat(ct).axis(1).spacing;
      % For anisotropic data like cardiac MRI, the 3rd spacing field (z)  
      % is several times the the through plane (xy) resolution
      % Here I want an isotropic volume therefore we have to
      % manually set the z resolution to the x or y resolution.
    
end

%% to view 2D slices in 3D context
  % scimat_slice_GUI(cardiac_scimat) 

  % generate scimat file with empty 3D array 
out3D = scimat_make3dframe(cardiac_scimat_iso,1); 
  % Here we make an isotropic volume, which is why we use "cardiac_scimat_iso"
  % size(out3D.data) should have 3 pretty similar numbers, depending on the
  % orientation of the object. The scimat can be rotated by altering the
  % rotation matrix and the spacing.min fields

%% resampling 
  % let's say we want to extract the long axis = slices (1:2)
  % from the short axis stack = slices (3:end)
cardiac_3D = scimat_insert_extract(cardiac_scimat(3:end),out3D,1);
extracted_2D = scimat_insert_extract(cardiac_3D,cardiac_scimat(1:2),1);

%% in case you want to reorient the entire data
  % To have the short axis slices be in the XY plane,
  % you have to select 3 (or any short axis slice index)
  % as the second input to this function.
rotated_scimat = scimat_reorientation(cardiac_scimat,3);

  % There you go, I hope it helps. Let me know if you have any questions. Nic.
