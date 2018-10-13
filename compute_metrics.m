  function [global_index global_var]=compute_metrics(image)
%  image= (imread(filename));
[row col dim]=size(image);
% if dim>1
%     image=rgb2gray(image);
% end
if dim>1
    image=image(:,:,2);
end
new_row=round(row/5)*5;
  new_col=round(col/5)*5;
  image=imresize(image, [new_row, new_col]);
  step=floor([new_row new_col]/5);
image=double(image);
u_img=mean(image(:));
image=image-u_img;
sigma_img=std(image(:));
  image=image/sigma_img;
  
  
  for i=1:5
      for j=1:5
          tmp=image((i-1)*step(1)+1:i*step(1), (j-1)*step(2)+1:j*step(2));
          local_mean(i,j)=mean(mean(tmp));
          
          local_sigma(i,j)=std(tmp(:));
      end
  end
  
     global_index=sqrt(sum(sum(local_mean.^2))/25);
     global_var = mean(local_sigma(:));
  
  end
