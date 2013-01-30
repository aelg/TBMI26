function n = winner2(d)

% WINNER(s) gives checks if d is a winer state and if so gives number of
%           the winner. If no a winner stat WINNER returns 0.

w = [1 1 1 0 0 0 0 0 0
     0 0 0 1 1 1 0 0 0
     0 0 0 0 0 0 1 1 1
     1 0 0 1 0 0 1 0 0
     0 1 0 0 1 0 0 1 0
     0 0 1 0 0 1 0 0 1
     1 0 0 0 1 0 0 0 1
     0 0 1 0 1 0 1 0 0];

e1 = (d==1);
e2 = (d==2);

n = 0;
if max(sum(repmat(e1,8,1) & w,2)) ==3
  n = 1;
else
  if max(sum(repmat(e2,8,1) & w,2)) ==3
    n = 2;
  end
end 
    