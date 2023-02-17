# Lecture2 - IMAGE RESTORATION

[**Benchmark Results**](https://docs.google.com/spreadsheets/d/1a3iMYhNRNZ-bUII9PrgccbaaRurPIpaP/edit?usp=sharing&ouid=112211468254352441667&rtpof=true&sd=true)

## Preparation

1. Run Git bash.
2. Set username by: `$ git config --global user.name "name_of_your_GitHub_profile"`
3. Set email by: `$ git config --global user.email "email@example.com"`
4. Select some MAIN folder with write permision.
5. Clone the **Lecture2_23** repository from GitHub by: `$ git clone https://github.com/MPA-AB2/Lecture2_23.git`
6. In the MAIN folder should be new folder **Lecture2_23**.
7. In the **Lecture2_23** folder create subfolder **NAME_OF_YOUR_TEAM**.
8. In the **NAME_OF_YOUR_TEAM** folder create two subfolders: **TASK1** and **TASK2**
9. Run Git bash in **Lecture2_23** folder (should be *main* branch active).
10. Create a new branch for your team by: `$ git checkout -b NAME_OF_YOUR_TEAM`
11. Check that  *NAME_OF_YOUR_TEAM* branch is active.
12. Continue to First task...

## Tasks to do

### First task – experimentally defined PSF – NON-BLIND deconvolution

1. Download the image in a zip folder from [here](https://www.vut.cz/www_base/vutdisk.php?i=309172af5d). Extract the content of the zip folder into **Lecture2_23** folder. The zip folder contains an encrypted ground truht image and PSF (*GTencr.mat* for MATLAB) and the blurred version (*image_blurred.png*).
2. Make a script in **Lecture2_23\NAME_OF_YOUR_TEAM\TASK1** folder to estimate experimentally direction in which the object is moving and design an unknown PSF of degrading linear system. Try to create PSF as much precise as possible considering both angular orientation, shape and length of the motion blur. Consider that the matrix must be of size 477x477 pixels. The sum of PSF values has to be equal to 1.
3. Apply any of deconvolution methods on the blurred image using the experimentally designed PSF. You can choose an arbitrary “non-blind” deconvolution method (e.g. inverse filter, Wiener filter, Richardson-Lucy deconvolution, Total Variation deconvolution or their modifications). Visually evaluate the result and adapt the PSF to get the sufficient output.

Tip:
* Segment the moving object and perform image fusion of the sharp background from the input image and the deblurred moving object in order to get sharp image. You can choose an arbitrary method to fuse the images.

4. Evaluation:
Use the provided MATLAB function for evaluation of the results and submit the output to lecturer. The function *evaluateMotion.p* called as:

`[NRMSE_PSF, RMSE_Image, PSNR] = evaluateMotion(deblurredPathName)`,

which has the following inputs and outputs:
* deblurredPathName (full path including name of the .mat file – two variables inside: estimatedPSF and deblurredImage),
  * estimatedPSF (designed/estimated PSF of the degrading system – 477x477, double/float64, sum = 1),
  * deblurredImage (deblurred image – original image size, uint8, RGB),
* NRMSE_PSF (Normalized Root Mean Squre Error between true and estimated PSF – lower is better),
* RMSE_Image (Root Mean Square Error between true and deblurred image - lower is better)
* PSNR (PSNR value of the estimated image – higher is better).

5. Calculate above-mentioned evaluation criteria. Save one **TIFF** image as a joined figure consisted of 2 subfigures showing the best achieved results of reconstruction method and PSF designed image (also with evaluation criteria values). **Push** your program script into GitHub repository **Lecture2_23** using the **branch of your team** (stage changed -> fill commit message -> sign off -> commit -> push -> select *NAME_OF_YOUR_TEAM* branch -> push -> manager-core -> web browser -> fill your credentials).
6. Submit the best-obtained result of your method evaluated on the competition dataset using the evaluation function (i.e. submit the calculated evaluation values) into a shared [Excel table](https://docs.google.com/spreadsheets/d/1a3iMYhNRNZ-bUII9PrgccbaaRurPIpaP/edit?usp=sharing&ouid=112211468254352441667&rtpof=true&sd=true). The evaluation of results from each team will be presented at the end of the lecture.

### Second task – automatically estimated PSF – BLIND deconvolution

1. Make a script in **Lecture2_23\NAME_OF_YOUR_TEAM\TASK2** folder and search for an arbitrary blind deconvolution method and use this method to estimate an unknown PSF of the degrading linear system. Apply the same steps as before using the estimated PSF instead of the experimentally designed one.
2. Use the same evaluation function and compare the results.
3. Save one **TIFF** image as a joined figure consisted of 2 subfigures showing the best achieved results of reconstruction method and PSF designed image (also with evaluation criteria values). **Push** your program script into GitHub repository **Lecture2_23** using the **branch of your team** (stage changed -> fill commit message -> sign off -> commit -> push -> select *NAME_OF_YOUR_TEAM* branch -> push -> manager-core -> web browser -> fill your credentials).
4. Submit the best-obtained result of your method evaluated on the competition dataset using the evaluation function (i.e. submit the calculated evaluation values) into a shared [Excel table](https://docs.google.com/spreadsheets/d/1a3iMYhNRNZ-bUII9PrgccbaaRurPIpaP/edit?usp=sharing&ouid=112211468254352441667&rtpof=true&sd=true). The evaluation of results from each team will be presented at the end of the lecture.

The output of the Challenge will be six evaluating values – three for each of two approaches (experimentally determined PSF and obtained by some of blind methods).
