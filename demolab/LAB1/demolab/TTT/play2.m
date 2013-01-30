function play2(ngames,filename)
% PLAY  Play tic-tac-toe. You make the first move.
%
% PLAY(NGAMES,FILENAME)
%      NGAMES   - number of games
%      FILENAME - file to use
%
% See also  PLAY2 TRAINB TRAINPB TRAINQ


load(filename)               % If so, load filname

n_max = 3^9;      % maximum number of states

if exist('Q_table')==0
%  disp('Jag har ingen aning om vad jag ska göra!')
%  disp('Träna mig eller använd gamla träningsdata.')
tmp = ['Jag har ingen aning om vad jag ska göra! Träna mig eller använd gamla träningsdata.'];
tictactoe('info',gcbo,gcbf,tmp)

return
end

trace_state = zeros(50,1);
trace_move = zeros(50,1);
trace_select = zeros(50,1);

s = 0;
b = [  100000000
        10000000
         1000000
          100000
           10000
            1000
             100
              10
               1 ];			% base for state numbering

index = 1:n_max;




% --- play game ---
for game = 1:ngames
  %fprintf('Omgång %i: ',game)
  draw_grid('Machine','You');
  handle = zeros(1,9);
  step = 1;
  d = zeros(1,9);

  % --- first move ---
  move = get_choise;
  d(move) = 2;				% change state description
  h(move)=draw_mark(2,move);
  trace_state(1) = 2;
  trace_move(1) = move;

  while  step < 9	       % play game 9 steps
    step = step + 1;			% step counter

    select = 0;
    
    % --- machine ---
    if ~rem(step,2) 
      
      % --- flip side ---
%      d = 3*(d&d) - d;			% flip state description
      s = d*b;				% calculte state number
      state_nr = (s == state_list')*index';
      
      % --- if novel state create new state ---
      if state_nr == 0
	n_states = n_states + 1;
	state_nr = n_states;
	state_list(state_nr) = s;	% create new state
	Q_table(state_nr,:) = ones(size(1:9));% init move vector
      end
      
      % --- make move ---
      move = maxdraw(Q_table(state_nr,:));
      while d(move) > 0			% while move not correct
	Q_table(state_nr,move) = 0;	% zero probability for incorrect move
	move = maxdraw(Q_table(state_nr,:));		% new move
      end
      d(move) = 1;			% insert new position
      h(move)=draw_mark(1,move);
      
      if winner2(d)
	break
      end
      
      % --- human opponent ---
    else % if rem ...

      % --- flip side ---
%      d = 3*(d&d) - d;			% flip state description
      s = d*b;				% calculte state number
      state_nr = (s == state_list')*index';
      
      % --- if novel state create new state ---
      if state_nr == 0
	n_states = n_states + 1;
	state_nr = n_states;
	state_list(state_nr) = s;	% create new state
	Q_table(state_nr,:) = ones(size(1:9));% init move vector
      end
      
      % --- make move ---
      move = get_choise;
      while d(move) > 0			% while move not correct
	Q_table(state_nr,move) = 0;	% zero probability for incorrect move
	%disp('Felaktigt drag!');
	tmp = 'Felaktigt drag!';
	tictactoe('info',gcbo,gcbf,tmp)
	pause(2)
	tmp = [''];
	tictactoe('info',gcbo,gcbf,tmp)
	hf=text(2,0,':-0','Rotation',-90);
	pause(1)
	delete(hf)
	move = get_choise;
      end
      d(move) = 2;			% insert new position
      h(move)=draw_mark(2,move);
      pause(0.5)
    end % if rem... else...

    if winner2(d)
      break
    end
      

    % --- trace game ---
    trace_state(step) = state_nr;
    trace_select(step) = select;
    trace_move(step) = move;
    
  end % while winner ...
  
  w = winner2(d);
  switch w
    case 1

%      % --- flip side ---
%      d = 3*(d&d) - d;			% flip state description
%      s = d*b;				% calculte state number
%      state_nr = (s == state_list')*index';

      %disp('Jag vann!')
      tmp = ['I won!'];
      tictactoe('info',gcbo,gcbf,tmp)
      pause(2)
	tmp = [''];
	tictactoe('info',gcbo,gcbf,tmp)
      %hf=text(2,0,':-)','Rotation',-90);
 
    case 2

      %disp('Du vann!')
      tmp = ['You won!'];
      tictactoe('info',gcbo,gcbf,tmp)
      pause(2)
	tmp = [''];
	tictactoe('info',gcbo,gcbf,tmp)
      %hf=text(2,0,':-(','Rotation',-90);
      
    case 0
      
      %disp('Oavgjort!')
      tmp = ['Even!'];
      tictactoe('info',gcbo,gcbf,tmp)
      pause(2)
	tmp = [''];
	tictactoe('info',gcbo,gcbf,tmp)
      %hf=text(2,0,':-o','Rotation',-90);
  end
  %pause(1)
  %delete(hf)
end % for game ...

