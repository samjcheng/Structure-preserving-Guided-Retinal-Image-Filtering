function  Zinit = Fast_Structure_Transfer_Filter(Zinit, VFx,VFy,LAMBDA)

[H, W] = size(Zinit);
T = 3; % Iteration number
lambda = zeros(T,1);
for t=1:T
    lambda(t) = 1.5* 4^(T-t)/(4^T-1)*LAMBDA;
end

%%%parameters along x direction 
row = zeros(1,W);
a = zeros(1,W);
b = zeros(1,W);
c = zeros(1,W);
d = zeros(1,W);
%%%parameters along y direction
col = zeros(1,H);
aa = zeros(1,H);
bb = zeros(1,H);
cc = zeros(1,H);
dd = zeros(1,H);
    
for t=1:T %iteration for separable optimization
%%%definition of matrices coefficients    
    tmp1 = 0-lambda(t);
    tmp2 = 1+2*lambda(t);
    for i=1:W
        a(i) = tmp1;
        c(i) = tmp1;
    end    
    for h = 1: H % for each row, A is a matrix of WxW
       b(1) = tmp2-lambda(t); 
       d(1) = Zinit(h, 1) - lambda(t)* VFx(h,1);        
        for i = 2:W-1
            b(i) = tmp2;
            d(i) = Zinit(h, i) + lambda(t)*(VFx(h,i-1) - VFx(h,i));          
        end
        b(W) = tmp2-lambda(t);
        d(W) = Zinit(h, W) + lambda(t)* VFx(h,W-1);     
       %%%%1D solver along x direction                        
        row(1) = d(1)/b(1);
                     
    %%%%setting values to '\tilde b'
        for i = 2:W
            b(i) = b(i) - a(i-1)*c(i-1)/b(i-1);
            row(i) = (d(i) - a(i-1)*row(i-1))/b(i);
        end
            
        for i=(W-1):-1:1
            row(i) = row(i) - c(i)*row(i+1)/b(i);
        end
             
        Zinit(h,:) = row(:);
    end
%%%Definition of matrix coefficients
    for i=1:H
        aa(i) = tmp1;
        cc(i) = tmp1;
    end        
    for w = 1:W % for each col, A is a matrix is HxH
        bb(1) = tmp2-lambda(t);
        dd(1) = Zinit(1, w) - lambda(t)* VFy(1,w);
        for i = 2:H-1
            dd(i) = Zinit(i, w) + lambda(t)*(VFy(i-1,w) - VFy(i,w)); 
            bb(i) = tmp2;
        end
        bb(H) = tmp2-lambda(t); 
        dd(H) = Zinit(H, w) + lambda(t)* VFy(H-1,w);
  %%%1D solver along y direction
                        
        col(1) = dd(1)/bb(1);
               
            %setting values to '\tilde b'
        for i = 2:H
            bb(i) = bb(i) - aa(i-1)*cc(i-1)/bb(i-1);
            col(i) = (dd(i) - aa(i-1)*col(i-1))/bb(i);
        end
            
        for i=(H-1):-1:1
            col(i) = col(i) - cc(i)*col(i+1)/bb(i);
        end
            
        Zinit(:,w) = col(:);
    end
        
end
    
    
end

