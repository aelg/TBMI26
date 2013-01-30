figure(1)
resolution = 0.01;

if ~exist('alphabet')

% --- learn each letter ---
    %alphabet = 'abcdefghijklmnopqrstuvxyz';
    alphabet = '0123456789';

    for k = 1:length(alphabet)
	clf
	axis([0 1 0 1]); axis square
	set(gca,'XTick',[])
	set(gca,'YTick',[])
	char = alphabet(k); % aktuellt tecken
	p=[];
	while size(p,1) < 3
	    disp(['write "' char '"']);
	    p = draw(1); % rita aktuell tecken
	end
	
% --- interpolera ---
	diff = p(2:end,:)-p(1:end-1,:); % differens mellan koordinater
	dist = sqrt(sum(diff.^2,2));    % Euklidiska avstånd mellan punkterna
	t = [0 cumsum(dist)']/sum(dist); % Normaliserade kurvaparametrar
% (0-1)
	duplets = t(1:end-1)==t(2:end); % find non-distinct data points
	ind = find(~duplets);          % Index till icke-duplets
	ind = [ind ind(end)+1];        % lägg till sista punkten
	tt = 0:resolution:1;
	x(1,:) = spline(t(ind),p(ind,1),tt);
	x(2,:) = spline(t(ind),p(ind,2),tt);
%     hold on; plot(x(1,:),x(2,:),'-g')
%     pause(2)
	base{k}.data = x;
	base{k}.class = k;
	
% --- mät proportion (höjd/bredd) ---
	v = var(x');
	base{k}.proportion = v(2)/v(1);
    end
    NPrototypes = k;
end

% --- Test recognition ---
while 1
    figure(1)
    clf
    axis([0 1 0 1]); axis square
    set(gca,'XTick',[])
    set(gca,'YTick',[])
    disp(['write a character']);
    p = draw(1); % rita tecken
    
    % --- interpolera ---
    diff = p(2:end,:)-p(1:end-1,:); % differens mellan koordinater
    dist = sqrt(sum(diff.^2,2));    % Euklidiska avstånd mellan punkterna
    t = [0 cumsum(dist)']/sum(dist); % Normaliserade kurvaprametrar (0-1)
    duplets = t(1:end-1)==t(2:end); % find non-distinct data points
    ind = find(~duplets);          % Index till icke-duplets
    ind = [ind ind(end)+1];        % lägg till sista punkten
    tt = 0:resolution:1;
%    x(1,:) = spline(t(ind),p(ind,1),tt);
%    x(2,:) = spline(t(ind),p(ind,2),tt);
    x = [spline(t(ind),p(ind,1),tt); spline(t(ind),p(ind,2),tt)];
    hold on
    plot(x(1,:),x(2,:),'g-')
    hold off

    % --- Jämför med alla prototyper ---
    for k = 1:NPrototypes
	y = base{k}.data;
	w1 = (y(1,:)/x)'; % basvektorn som korrelerar med x1
	w1 = w1/norm(w1);            % Normalisera basvektorn w1
	w2 = [0;1] - w1(2)*w1;       % Hitta ortogonal basvektor w2
	w2 = w2 / norm(w2);
	proj = [w1 w2]'*x;
	C = corrcoef([proj' y']);
	v = var(proj');               % Varians längs axlarna
	prop = v(2)/v(1);             % Proportion      
	propprop = prop/base{k}.proportion;
	ang = atan2(w1(2),w1(1));     % Vinkel jämfört med prototypen (0);
	r = max(0,[C(1,3); C(2,4)]);
	r(3) = exp(-abs(log(propprop)));     % Relativ likhet i
                                             % proportion
	r(4) = (abs(ang)<pi/2)*cos(ang).^2; % Vinkellikhet med prototypen
%	s(k) = sum(log(1./(1-r.^2)));
	s(k) = prod(abs(r));
    end

    % --- plotta S ---
    figure(2)
    stem(s)
    xt = 0:NPrototypes;
    T{1} = ' ';
    for c = 1:NPrototypes
	T{c+1} = alphabet(c);
    end
    %set(gca, 'xtick', T);
    xtick(xt, T);
    axis([0 NPrototypes 0 1]);
    title('similarity');

    % --- välj klass ---
    [tmp,ind] = max(s); % index till maximal korrelation
    char = alphabet(base{ind}.class);

    % --- Fråga om det var rätt ---
    disp(['Did you draw "' char '"? [y(es), n(ow), s(kip)]']);
    q = input('Was it correct? (y/n)','s');
    switch q
	
     case 'n' % --- Om fel, lägg in som ny prototyp ---
      NPrototypes = NPrototypes + 1;
      base{NPrototypes}.data = x;
      v = var(x');
      base{NPrototypes}.proportion = v(2)/v(1);
      base{NPrototypes}.class = NPrototypes;
      char = input('Enter the correct letter!','s');
      alphabet(NPrototypes) = char;
     
     case 'y' % --- Om rätt, lägg till om det är ett gränsfall
      s(ind) = 0; % Nollställ maxklassen
      [tmp,nind] = max(s); % index till näst högst korrelation
      if alphabet(base{ind}.class) ~= alphabet(base{nind}.class)
	  % --- Om olika klasser (gränsfall) lägg till samplet
	  NPrototypes = NPrototypes + 1
	  base{NPrototypes}.data = x;
	  v = var(x');
	  base{NPrototypes}.proportion = v(2)/v(1);
	  base{NPrototypes}.class = NPrototypes;
	  alphabet(NPrototypes) = char;
      end
    
    end
end
