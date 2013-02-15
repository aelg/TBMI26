%% MoG Prototype
%  -----------------
% close all
clear all

N=100;
X1=mvnrnd([-1 0],[0 1]*[0 1]'+0.001*eye(2),N)';
X2=mvnrnd([1 0],[0 1]*[0 1]'+0.001*eye(2),N)';
X = [X1 X2];
%X = [-1 -1 -1 1 1 1; -1 0 1 -1 0 1];

p1 = [-0.5 ; 0];
p2 = [ 0.5 ; 0];

C  = [1 0; 0 1];
C1  = C;
C2  = C;
e = 0.001;

%p1 = [1 ; 0.5];
%p2 = [1 ; -0.5];

figure(2);

for cnt=1:4
   %Just plot stuff
   plot(X(1,:),X(2,:),'kx')
   axis([-3 3 -3 3])
   hold on;
   h1=plot_gaussian_ellipsoid(p1',C1,2);set(h1,'color','red');
   h2=plot_gaussian_ellipsoid(p2',C2,2);set(h2,'color','green');
   hold off;
   
   %Find nearest (pdf-metric) prototype! (Phase 1)
   y1 = mvnpdf(X',p1',C1);
   y2 = mvnpdf(X',p2',C2);
   yt = [y1 y2];
   [D I]=max(yt,[],2);
   ind1 = (I==1); %Cluster 1
   ind2 = (I==2); %Cluster 2
   pause;
    
   %Just plot stuff
   plot(X(1,ind1),X(2,ind1),'rx')
   axis([-3 3 -3 3])
   hold on;
   plot(X(1,ind2),X(2,ind2),'gx')
   h1=plot_gaussian_ellipsoid(p1',C1,2);set(h1,'color','red');
   h2=plot_gaussian_ellipsoid(p2',C2,2);set(h2,'color','green');
   pause;
   
   %Calc new prototypes(Phase 2)
   p1 = mean(X(:,ind1),2);
   p2 = mean(X(:,ind2),2);
   
   newC=zeros(2,2);
   for i=find(ind1')
      newC = newC + (X(:,i)-p1)*(X(:,i)-p1)';
   end
   C1=newC/sum(ind1)+e*C;
   
   newC=zeros(2,2);
   for i=find(ind2')
      newC = newC + (X(:,i)-p2)*(X(:,i)-p2)';
   end
   C2=newC/sum(ind2)+e*C;
   
   %Just plot stuff
   h1=plot_gaussian_ellipsoid(p1',C1,2);set(h1,'color','red');
   h2=plot_gaussian_ellipsoid(p2',C2,2);set(h2,'color','green');
   hold off;
   pause;beep
   
end
