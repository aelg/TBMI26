function n = get_choise

[x y] = ginput(1);
while max(abs([x-2,y-2])) >= 1.5
   [x y] = ginput(1);
end

n=1 + 3*round(x) - round(y);
