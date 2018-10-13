function [A_rgb, haze_Y] = Global_Airlight_Estimation(haze_I, TYPE)
[height,width, color]= size(haze_I);
quad_size = 32;%32;
iter = floor(log2(max(height,width)/quad_size));
topleft = [1,1]; %%the star of hierachy
pix_mean = zeros(3,1);
sigma = zeros(3,1); 
for k = 1:iter    
    hh = floor(height/2^k); 
    ww = floor(width/2^k);    
    score = 0;
    x_p = 0; 
    y_p = 0;
    for i = 1:2
        for j = 1:2            
             xx = topleft(1)+(i-1)*hh;
             yy = topleft(2)+(j-1)*ww; 
             for ll=1:3
                 pix_mean(ll) = 0;
                 sigma(ll) = 0;
             end
             for m = 1:hh
                 for n = 1:ww
                     for ll = 1:3                       
                         pix_mean(ll) = pix_mean(ll)+haze_I(xx+m-1,yy+n-1,ll);
                         sigma(ll) = sigma(ll)+haze_I(xx+m-1,yy+n-1,ll)*haze_I(xx+m-1,yy+n-1,ll);
                     end
                 end %for n = 1:ww
             end %for m = 1:hh             
             pix_mean = pix_mean./(hh*ww);  
             sigma = (sigma./(hh*ww)-pix_mean.^2).^0.5;
%              for m = 1:hh
%                  for n = 1:ww
%                      for ll = 1:3                       
%                          sigma(ll) = sigma(ll)+(haze_I(xx+m-1,yy+n-1,ll)-pix_mean(ll))^2;
%                      end
%                  end %for n = 1:ww
%              end %for m = 1:hh             
%            sigma = (sigma./(hh*ww)).^0.5;  
            if TYPE==1
                temp = pix_mean-sigma;
            else
                temp = mean(pix_mean(:))-mean(sigma(:));
            end

             if (temp > score)
                 score = temp;
                 x_p = xx; 
                 y_p = yy;
             end            
        end %for j = 1:2
    end %for i = 1:2    
    topleft(1) = max(x_p,1); 
    topleft(2) = max(y_p,1);
end
xx = topleft(1); 
yy = topleft(2);
DD = 1000000;
A_rgb = zeros(3,1);
for m = 1:hh
    for n = 1:ww        
%         SS = 0;
%         for ll = 1:3                       
%             SS = SS+(255-haze_I(xx+m-1,yy+n-1,ll))^2;        
%         end   
        SS = sum((255-haze_I(xx+m-1,yy+n-1,:)).^2);
        if (SS<DD)
            DD = SS;
%             for ll = 1:3
%                 A_rgb(ll) = haze_I(xx+m-1,yy+n-1,ll);
%             end
            A_rgb(:) = haze_I(xx+m-1,yy+n-1,:);
        end
    end %for n = 1:ww
end %for m = 1:hh
% %%%adjustment on the airlight

haze_Y = zeros(height, width);
for ii=1:height
    for jj=1:width
        haze_Y(ii,jj) = floor((77*haze_I(ii,jj,1)+150*haze_I(ii,jj,2)+29*haze_I(ii,jj,3)+128)/256);       
    end
end

end
