function drawpolicy(Q),

gwdraw;
[V, I] = max(Q, [], 3);
for x = 1:size(Q, 1),
    for y = 1:size(Q, 2),
        gwplotarrow([x;y], I(x, y));
    end
end