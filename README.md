# DICOM_resampling
Use this code to resample 2D and 3D medical images in matlab

The matlab code in this repository is used to resample 2D and 3D medical imaging data (raw DICOM). Either insert slices into a volume or extract slices from a volume. It was developed for MRI but should works with others too. I have used it on MRI (cardiac, pre-clinical cardiac, abdominal, whole body, multiecho single slice) as well as abdominal CT.

You will need the gerardus toolbox https://github.com/vigente/gerardus to run the files.
It is all based in scimat format, used in the Gerardus repository. 

## Files

### scimat_insert_extract.m
This function resamples data. If a 2D (stack or single) image is used as output and a 3D as its output, the function will generate a synthetic acquisition based on the metadata of both files.

### scimat_squeeze_time.m
This function removes the time dimension. Needed because this works with static frames only.

### scimat_make3Dframe.m
This function created an empty 3D scimat array. Needed when 2D data is to be inserted into an empty 3D array. 

### scimat_dcm2scimat.m
I correct an error in the file on gerardus that populates the slice thickness (z-resolution) with a wrong value. 

The code was developed for the optimisation algorithm in the following paper. 

* Basty, N., McClymont, D., Teh, I., Schneider, J.E. and Grau, V., 2017. Reconstruction of 3D Cardiac MR Images from 2D Slices Using Directional Total Variation. In Molecular Imaging, Reconstruction and Analysis of Moving Body Organs, and Stroke Imaging and Treatment (pp. 127-135). Springer, Cham.

At every iteration, the resampling function (scimat_insert_extract.m) is used to generate synthetic slices to be compared with the ground truth as well as inserting 2D data back into the 3D volume that is being reconstructed.

# To do
* Find freely available data
* add test.m file that works with that data
