disp('********************************************************************');
disp('Visa hur d�ligt maskinen spelar innan den tr�nats.');
disp('1. �ppnar inte i mitten, l�tt att sl�.');
disp('2. Tar inte chanser den bjuds p� (123).');
disp('********************************************************************');
pause;

play(2,'kass');		% 1. L�tt att sl� 2. Tar inte erbjuden chans

disp('********************************************************************');
disp('Visa n�r systemet l�r sig genom att spela mot sig sj�lvt.');
disp('********************************************************************');
pause;

demotrain(10,1,'kass');	% Snabba partier i b�rjan

disp('********************************************************************');
disp('Visa hur systemet spelar n�r det spelat mot sig sj�lvt 20000 g�nger.');
disp('Spelar bra n�r den f�r �ppna (sv�r + tar chanser).');
disp('********************************************************************');
pause

play(2,'bra');		% Spelar bra n�r den f�r �ppna

disp('********************************************************************');
disp('Spelar skapligt n�r den inte f�r �ppna (543).');
disp('********************************************************************');
pause;

play2(2,'bra');		% Spelar skapligt n�r den inte �ppnar

