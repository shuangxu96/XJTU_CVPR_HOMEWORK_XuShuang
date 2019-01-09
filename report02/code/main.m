clear
clc

flag = 0;
if flag
    str = 'eval-data\';
else
    str = 'sky_castle\';
end
file_path = ['D:\cvpr-class\report2\img\eval-color-twoframes\',str];
file_name = dir(file_path);
file_name = {file_name.name};
file_name = file_name(3:end);
str1='\frame10.png';
str2='\frame11.png';



for i=1:length(file_name)
    imfile1 = [file_path,file_name{i},str1];
    imfile2 = [file_path,file_name{i},str2];
    im1=imread(imfile1); img1 = rgb2gray(im1);
    im2=imread(imfile2); img2 = rgb2gray(im2);
    imwrite(imfuse(im1,im2,'method','blend'),['pair_',file_name{i},'.png'],'png')
    
    verbose=0;
    [p,q,~]=size(im1);
    para=get_para_flow(p,q);
    % LDOF
    [F,c1,c2]=LDOF(imfile1,imfile2,para,verbose);
    % LK, HS
    LK = opticalFlowLK;
    HS = opticalFlowHS('MaxIteration',250,'Smoothness',1);
    [F2, F3] = deal([],[]);
    estimateFlow(LK, img1); flow2 = estimateFlow(LK, img2);F2(:,:,1)=flow2.Vx; F2(:,:,2)=flow2.Vy;
    estimateFlow(HS, img1); flow3 = estimateFlow(HS, img2);F3(:,:,1)=flow3.Vx; F3(:,:,2)=flow3.Vy;

    %imwrite(flowToColor(F1),[pwd '\view1_',file_name{i},'.png'],'png');
    imwrite(flowToColor(F2),[pwd '\view2_',file_name{i},'.png'],'png');
    imwrite(flowToColor(F3),[pwd '\view3_',file_name{i},'.png'],'png');
end

