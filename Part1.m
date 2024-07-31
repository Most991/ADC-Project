clear;
clc;
close all;

%get message from user
[M] = input('Enter the input signals: ');
[row,column] = size (M);
U = zeros (row,column);
energy = zeros(row,1);
Time_duration = [];

% to get first basis function
U(1,:) = M(1,:) / sqrt(sum(M(1,:).^2));


% to get other basis function
for_constellation = zeros (row , column+1);
% for calculation the s11 for all possible siganls
for_constellation(1,1) =sqrt(sum(M(1,:).^2));

for h=2:row
    
        g(h-1,:)=M(h,:);
   for v=1:h-1
            coeff=0;
            for j=1:column
                x= M(h,j).*U(v,j);
                coeff = coeff + x;
            end
%% this for s21 and s31 and s32 and s41 and s42 and so on
               for_constellation(h,v)=coeff;
               g(h-1,:)=g(h-1,:)-coeff.*U(v,:);

   end
         
   U(h,:)= g(h-1,:)./sqrt(sum(g(h-1,:).^2));


 %% this for putting the s22 and s33 and s44 and so on in this matrix
         for_constellation(h,h)=sqrt(sum(g(h-1,:).^2));
        
end

%% for plotting constsellation_diagram
[row_of_basis_fn,columns_of_basis_fn]=size(U);
if  row_of_basis_fn==2
plot(for_constellation(:,1) , for_constellation(:,2),'o');
grid on;
else
 scatter3(for_constellation(:,1),for_constellation(:,2),for_constellation(:,3)); 
end 
xlim([-6 6]);
ylim([-6 6]);
zlim ([-6 6]);



%%Calculate distance and energy
distance =0;
for dis=1:row
   point = for_constellation(dis,:);
   distance = norm(point); 
   energy(dis,1) = ((distance)^2);
end




%%array for plot duration time
for x=0:column
    Time_duration(1 , 1+x) = x ;
end 

%%ploting input
figure('Name','input signals');
title('input signals');
for i=1:row
subplot(2,2,i);
stairs ([Time_duration(1,:)] , [M(i,:) 0] , 'LineWidth',2);
xlabel('time');
ylabel(sprintf('S%d(t)' , i));
end

%%ploting basis function
figure('Name','basis function');
title('basis functions');
for basis=1:row
subplot(2,2,basis);
stairs ([Time_duration(1,:)] , [U(basis,:) 0] , 'LineWidth',2);
xlabel('time');
ylabel(sprintf('basis%d(t)' , basis));
end



