function n = maxdraw(v)

% MAXDRAW finds the index of the maximum number in v.
%         If multiple maxima, a random chose among the maxima is made.

n=find(max(v)==v);
while length(n) > 1
  v=v+0.001*randn(size(v));
  n=find(max(v)==v);
end