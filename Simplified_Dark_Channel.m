
function [dark_channel,haze_m] = Simplified_Dark_Channel(haze_I,A_rgb,SHIFT)

[height,width, color]= size(haze_I);
haze_m = zeros(height,width);
for i = 1:height
    for j = 1:width
        haze_m(i,j) = floor(SHIFT*haze_I(i,j,1)/A_rgb(1));
        tmp = floor(SHIFT*haze_I(i,j,2)/A_rgb(2));
        if tmp<haze_m(i,j)
            haze_m(i,j) =  tmp;
        end
        tmp = floor(SHIFT*haze_I(i,j,3)/A_rgb(3));
        if  tmp<haze_m(i,j)
            haze_m(i,j) =  tmp;
        end
    end
end

%%%%Compute the simplified dark channel
rho = 15; 
dark_channel = zeros(height,width);


for i=1:height   
    [min_array]=LocalMinValue_Search(haze_m(i,:), width, rho);
    for j=1:width
        dark_channel(i,j)=min_array(j);
    end
end

for j=1:width    
    [min_array]=LocalMinValue_Search(dark_channel(:,j), height, rho);
    for i=1:height
        dark_channel(i,j)=min_array(i);
    end
end

