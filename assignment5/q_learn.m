
nbrActions = 4;
map = 8;
gwinit(map);
s = gwstate;
Q = rand(s.xsize, s.ysize, nbrActions)*(-1)-0.1;

%%

gamma = 0.99;
alpha = 0.2;
exploration = 0.3;

%gwdraw;

still = [0;0];
up = [-1; 0];
down = [1; 0];
left = [0; -1];
right = [0; 1];

dirs = [down up right left still];


what = [];

actionMatrix = zeros(4,5);

m = 0;
for k = 1:1000,
    k
    while 1,
        oldstate = s;
        %a = sample(1:nbrActions, Q(s.pos(1), s.pos(2), :));
        if rand < exploration ||  k < 20,
            a = floor(rem(rand()*1000, 4))+1;
        else
            [dummy, I] = max(Q(s.pos(1), s.pos(2), :));
            a = I;
        end
        %gwplotarrow(s.pos, a);
        s = gwaction(a);
        %%{ 
        %% Some testing code for the world "Home from HG"
        if s.isvalid,
            m = m + 1;
            for l = 1:5,
                if s.pos-oldstate.pos == dirs(:,l);,
                    what(:,m) = [a; l];
                    actionMatrix(a,l) = actionMatrix(a,l) + 1;
                end
            end
            %{
            if a == 1,
                if s.pos-oldstate.pos == down,
                    disp('correct');
                else
                    disp('incorrect');
                end
            end
            if a == 2,
                if s.pos-oldstate.pos == up,
                    disp('correct');
                else
                    disp('incorrect');
                end
            end
            if a == 3,
                if s.pos-oldstate.pos == right,
                    disp('correct');
                else
                    disp('incorrect');
                end
            end
            if a == 4,
                if s.pos-oldstate.pos == left,
                    disp('correct');
                else
                    disp('incorrect');
                end
            end
            %}
        end
        %%}
        %s.pos
        if s.isvalid,
            Q(oldstate.pos(1), oldstate.pos(2), a) = alpha*(gamma * max(Q(s.pos(1), s.pos(2), :)) + s.feedback) + (1-alpha)*Q(oldstate.pos(1), oldstate.pos(2), a);
        else
            Q(oldstate.pos(1), oldstate.pos(2), a) = alpha*(-0.1) + (1-alpha)*Q(oldstate.pos(1), oldstate.pos(2), a);
        end
        if(s.isterminal),
            Q(oldstate.pos(1), oldstate.pos(2), a) = 0.5;
            gwinit(map);
            break;
        end;
    end
end

drawpolicy(Q);