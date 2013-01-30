function trainq(ngames,filename)
% TRAINQ  Train with batch learning
%
% TRAINQ(NGAMES,FILENAME)
%        NGAMES   - number of games
%        FILENAME - file to save result on
%

%  clear
%  ngames=10000
%  filename = 'test'
 alpha = 0.5;
 gamma = 0.9;

novel = 0;

fid = fopen([filename,'.mat']); % check if filename exist
if fid>0
  load(filename)               % If so, load filname
end

n_max = 3^9;      % maximum number of states

%novel = 1

% --- if novel initiate move list and select list ---
if (exist('state_list') == 0)
  novel = 1;
end

if novel
  novel = 0;
  state_list = zeros(n_max,1);          % list of known states
  Q_table = 0.1*ones(n_max,9);          % list of Q-values / state
  n_states = 1;                         % number of states in list
end
trace_state = zeros(9,1);
trace_move = zeros(9,1);

s = 0;                                  % state number (e.g. 112201200)
b = [  100000000
        10000000
         1000000
          100000
           10000
            1000
             100
              10
               1 ];                     % base for state numbering
index = 1:n_max;                         % base for state indexing


% --- play game ---
for game = 1:ngames
  step = 1;
  d = zeros(1,9);			% state description (e.g. 1 1 2 ...)
  %fprintf('\romgång: %i ',game)

  if(mod(game,50)==0)
      tmp = ['game nr ' int2str(game)];
      tictactoe('info',gcbo,gcbf,tmp)
  end;
  % --- first move ---
  move = randdraw(Q_table(1,:));	% Integer between 1 and 9	
  %move=input('move:')   
  d(move) = 1;				% change state description, place 1 for player 1
  trace_state(1) = 1;
  trace_move(1) = move;
  
  %draw_grid;
  %draw_mark(mod(step,2)+1,move);

  
  while (winner2(d) == 0) & step<9	% play game until winner > 0
    % or until 9 draws are made
    step = step + 1;			% step counter

    % --- flip side ---
    d = 3*(d>0) - d;			% flip state description, 1->2 and 2->1
    s = d*b;				% calculate state number
    state_nr = (s == state_list')*index';
    
    % --- if novel state create new state ---
    if state_nr == 0
      n_states = n_states + 1;
      state_nr = n_states;
      state_list(state_nr) = s;	% create new state
      Q_table(state_nr,:) = 0.1*ones(1,9);% init move vector
    end

    % --- make move ---
    
    old_move = move;
    move = randdraw(Q_table(state_nr,:));
    %move = input('move:')   
     if sum(Q_table(state_nr,:))==0
      %disp('Fel 1')
      tmp = ['Error 1'];
      tictactoe('info',gcbo,gcbf,tmp)
      %pause
    end
    while d(move) > 0			% while move not correct
      if sum(Q_table(state_nr,move))==0
	%disp('fel 3')
	tmp = ['Error 3'];
	tictactoe('info',gcbo,gcbf,tmp)
	%pause
      end
      if sum(Q_table(state_nr,:))==0
	%disp('Fel 2')
	tmp = ['Error 2'];
	tictactoe('info',gcbo,gcbf,tmp)
	%pause
      end
      Q_table(state_nr,move) = 0;	% zero probability for incorrect
                                        % move
       move = randdraw(Q_table(state_nr,:));		% new move
    end
    d(move) = 1;			% insert new position

    %draw_mark(mod(step,2)+1,move);

    % --- update Q-table (två steg tillbaka)

    if step > 2
       Q_table(trace_state(step-2),trace_move(step-2)) = ...
 	  (1-alpha)*Q_table(trace_state(step-2),trace_move(step-2)) + ...
 	  alpha*gamma*max(Q_table(state_nr,:));
%      Q_table(trace_state(step-2),trace_move(step-2)) = ...
%	  Q_table(trace_state(step-2),trace_move(step-2)) + ...
%	  learnq(Q_table,trace_state(step-2),trace_move(step-2),state_nr);
    end
    
    
    % --- trace game ---
    trace_state(step) = state_nr;
    trace_move(step) = move;
    
    %reshape(d,3,3)
    %Q_table(1:n_states,:)
  end % while winner ...
  
  % --- update Q-table for winner state ---

  if winner2(d)
    Q_table(state_nr,move) = 1; % Reward winner
    Q_table(trace_state(step-1),old_move) = 0.001; % Punish looser
  else
    % --- update Q-table if equal ---

    Q_table(trace_state(step-1)) = 0.2; % Small reward for not loosing

  end
    
  
end % for game ...
%fprintf('\n')

eval(['save ' filename ' state_list Q_table  n_states novel'])

tmp = ['Training finish'];
tictactoe('info',gcbo,gcbf,tmp)
pause(2)
tmp = [''];
tictactoe('info',gcbo,gcbf,tmp)



