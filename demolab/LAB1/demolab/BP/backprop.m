N_in = 2;       % Antalet in - noder
N_hidden = str2num(get(hidden,'String'));
N_ut = 4;       % Antalet ut - noder
epoch = str2num(get(epochs,'String'));  % Antalet epoker
eta   = str2num(get(learnrate,'String'));  % Lerning rate 

W1 = randn(N_in+1,N_hidden);
W2 = randn(N_hidden+1,N_ut);
data = x;
m = mean(x,2);
x = x - repmat(m,1,800);
x(1,:) = x(1,:)/10;
x = [ones(1,length(x));x];             % Bias - etta
col = d;
d = [d==1;d==2;d==3;d==4];
error = [];
show_iterations = [1:10 12:2:22 25:5:75 80:10:120 150:30:270 300:50:epoch];
it = 1;

tryck = round(data(1,:)-100);
temp = round(10*(data(2,:)-34));
Itryck = find(tryck<1 | tryck>100);
Itemp =  find(temp<1 | temp>100);
Iq = union(Itryck,Itemp);
tryck = tryck(setdiff([1:800],Iq));
temp = temp(setdiff([1:800],Iq));
qcol = col(setdiff([1:800],Iq));
cla reset
colmap = [0.8 0.8 1;
	      1 0.8 0.8;
	      0.8 1 0.8;
	      1 1 0.8;
	      0 0 1;
	      1 0 0;
	      0 1 0;
	      1 1 0];
    
for k = 1:epoch
 
  % Forward (batch)
  s = W1'*x;                    % s - inflöde till gömt lager
  z = tanh(s);                  % z - ut från gömt lager
  z = [ones(1,length(z));z];    % Lägg på bias
  t = W2'*z;                    % t - inflöde till utlager
  y = tanh(t);                  % y - utsignal
  
  % Error calculation
  error(k) = norm(y-d,'fro');   % Felet 

  % Error propagation
  delta = W2*((y-d).*(1-y.^2)); % Propagera felet
  
  % Update weights (batch)
  deltaW1 = x*(delta(2:end,:).* (1-z(2:end,:).^2))'; %Ta bort biasen
  deltaW2 = z*((y-d).* (1-y.^2))';
  
  W1 = W1 - eta*deltaW1;
  W2 = W2 - eta*deltaW2;

  if k == show_iterations(it)
    set(instruktion,'String',['Epoch # ' num2str(k)])
    colormap(colmap)
    it = it+1;
    % Show classes
    [X Y] = meshgrid(100:200,44:-0.1:34);
    qx = [X(:)';Y(:)'];
    qx = qx - repmat(m,1,length(qx));
    qx(1,:) = qx(1,:)/10;
    qx = [ones(1,length(qx));qx];
    s = W1'*qx;
    z = tanh(s);
    z = [ones(1,length(z));z];   
    t = W2'*z;                    
    qy = tanh(t);                  
    [I sjukdom] = max(qy);
    
    bild = flipud(reshape(sjukdom',size(X)));
    for  o = 1:length(temp)
      bild(temp(o),tryck(o)) = 4+qcol(o);
    end
    image(flipud(bild)); axis image
    set(a,'YTick',[1:101/10:101],...
	  'XTick',[1:101/10:101],...
	  'YTickLabel',[44:-1:34],...
	  'XTickLabel',[100:10:200])
    ylabel('Temperature','Fontsize',15,'FontName','Times');
    xlabel('Blood Pressure','Fontsize',15,'FontName','Times');
    drawnow;
  end
end

tryck = round(2*(data(1,:)-100));
temp = round(20*(data(2,:)-34));
Itryck = find(tryck<1 | tryck>200);
Itemp =  find(temp<1 | temp>200);
Iq = union(Itryck,Itemp);
tryck = tryck(setdiff([1:800],Iq));
temp = temp(setdiff([1:800],Iq));
col = col(setdiff([1:800],Iq));
cla reset

colormap(colmap)

% Show classes
[X Y] = meshgrid(100:0.5:200,44:-0.05:34);
qx = [X(:)';Y(:)'];
qx = qx - repmat(m,1,length(qx));
qx(1,:) = qx(1,:)/10;
qx = [ones(1,length(qx));qx];
s = W1'*qx;
z = tanh(s);
z = [ones(1,length(z));z];   
t = W2'*z;                    
qy = tanh(t);                  
[I sjukdom] = max(qy);

bild = flipud(reshape(sjukdom',size(X)));
for  o = 1:length(temp)
  bild(temp(o),tryck(o)) = 4+col(o);
end
image(flipud(bild)); axis image
set(a,'YTick',[1:201/10:201],...
      'XTick',[1:201/10:201],...
      'YTickLabel',[44:-1:34],...
      'XTickLabel',[100:10:200])
ylabel('Temperature','Fontsize',15,'FontName','Times');
xlabel('Blood Pressure','Fontsize',15,'FontName','Times');
drawnow;
