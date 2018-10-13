function t = transmission_map_adjustment(t, SHIFT)
[height,width, color]= size(t);
%%%%Compute the Y component and the minimal color channel of a haze image
for i=1:height
    for j=1:width
%%%the value of dark_channel(i,j)/AAA is usually less than 1. Its value is multiplied by SHIFT such that the LUT can be implemented.            
        t(i,j) = SHIFT-t(i,j); 
        t(i,j) = max(t(i,j),3/8*SHIFT);
    end
end

end

