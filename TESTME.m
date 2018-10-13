clear all;
close all;
 %%%vpss_grp0_chn1_w1920_h1080_p422_defogoff_1.jpg
   filename='MS10064_001_007.bmp';
 
 
    haze_I = double(imread(filename));
    ouput_file = ['result.jpg'];
    ini_depth_file = 'Hongkong_ini_depth.png';
    trans_depth_file = 'Hongkong_trans_depth.png';
    ref_depth_file = 'Hongkong_ref_depth.png';
    final_depth_file = 'Hongkong_2017_Map.png';

%     tic
    TYPE = 1; %%%1: haze & normal; 2: underwater; 3: rain 

    [height,width, color]= size(haze_I);

    [A_rgb, haze_Y] = Global_Airlight_Estimation(haze_I,TYPE);

    %%%Estimate of the transmission map
    % AAA = min(A_rgb(:));
    SHIFT = 256;
    %%%%Compute the Y component and the normalized minimal colr channel of a haze image

    %%%compute the initial value of the simplified dark channel
    [dark_channel, haze_m] = Simplified_Dark_Channel(haze_I,A_rgb,SHIFT);


    %%%transfer the structure of the mininal color channel to the simplified
    %%%dark channel
    LAMBDA = 2048;%2048;
    VFx = zeros(height,width);
    VFy = zeros(height,width);
    for i=1:height-1
        for j=1:width
             VFy(i,j) = haze_m(i+1,j)-haze_m(i,j);
        end
    end
    for i=1:height
        for j=1:width-1
            VFx(i,j) = haze_m(i,j+1)-haze_m(i,j);
        end
    end
    t = Fast_Structure_Transfer_Filter(dark_channel,VFx,VFy,LAMBDA);
    imwrite((SHIFT-t)/SHIFT,trans_depth_file,'png');
    %%%Edge-preserving decomposition of the transmission map
    GAMMA = 64;
    lambda = 2048; %%%8192; for rho = 15;
    THETA = lambda*GAMMA;
    t = Fast_Edge_Preserving_Smoothing(t,VFx,VFy,THETA,GAMMA);


    t = transmission_map_adjustment(t, SHIFT);


    %%%%%%%%%%output dehazed image%%%%%%%%%%%%%%%%%%%

    %%%Recover the haze free image
    % GAMMA = 0.75; %%%for NUS_Decom_Enh
    for i = 1:height
        for j = 1:width
            for k = 1:color
      %%%Remark: the value of t(i,j) is the real value of t(i,j) multiplying SHIFT 
    %              haze_I(i,j,k) = floor((SHIFT*(haze_I(i,j,k)-A_rgb(k))/(t(i,j)*GAMMA+1)+A_rgb(k))+0.5); %%%1.125 for papers]   
                 haze_I(i,j,k) = floor((SHIFT*(haze_I(i,j,k)-A_rgb(k))/min(t(i,j)+1,SHIFT)+A_rgb(k))+0.5); %%%1.125 for papers]           

            end
        end
    end




%     time = toc 
    clear pix_mean;
    clear sigma;
    clear haze_m_log;
    clear haze_m;
    clear A_rgb;

%     figure; imshow(haze_I/255);

    imwrite(haze_I/255,ouput_file,'jpg');
 
