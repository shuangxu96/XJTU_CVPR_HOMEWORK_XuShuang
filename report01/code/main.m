clear
clc
% detect points
file_path = 'D:\cvpr-class\report1\img\';
file_name = dir(file_path);
file_name = {file_name.name};
file_name = file_name(4:15);
file_name = cellfun(@strcat, cellstr(repmat(file_path,12,1))', file_name,...
    'UniformOutput',false);
[imagePoints, boardSize, imagesUsed] = detectCheckerboardPoints(file_name);
imageFileNames = file_name(imagesUsed);

% calibration
squareSize = 30;  
worldPoints = generateCheckerboardPoints(boardSize, squareSize);
[cameraParams, imagesUsed, estimationErrors] = estimateCameraParameters(imagePoints, worldPoints, ...
    'EstimateSkew', true, 'EstimateTangentialDistortion', true, ...
    'NumRadialDistortionCoefficients', 2, 'WorldUnits', 'millimeters', ...
    'InitialIntrinsicMatrix', [], 'InitialRadialDistortion', [], ...
    'ImageSize', [2320,2320]);

% display result
displayErrors(estimationErrors, cameraParams); 
showExtrinsics(cameraParams, 'CameraCentric');
saveas(gcf,'Extrinsics1.eps','epsc')
showExtrinsics(cameraParams, 'PatternCentric');
saveas(gcf,'Extrinsics2.eps','epsc')

% display undistorted image 
for i=1:3
    I = imread(file_name{i});
    Iu = undistortImage(I, cameraParams);
    imwrite(Iu,['img0',num2str(i),'_undistorted.png'],'png')
end