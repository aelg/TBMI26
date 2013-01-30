disp('********************************************************************');
disp('Visa hur dåligt maskinen spelar innan den tränats.');
disp('1. Öppnar inte i mitten, lätt att slå.');
disp('2. Tar inte chanser den bjuds på (123).');
disp('********************************************************************');
pause;

play(2,'kass');		% 1. Lätt att slå 2. Tar inte erbjuden chans

disp('********************************************************************');
disp('Visa när systemet lär sig genom att spela mot sig självt.');
disp('********************************************************************');
pause;

demotrain(10,1,'kass');	% Snabba partier i början

disp('********************************************************************');
disp('Visa hur systemet spelar när det spelat mot sig självt 20000 gånger.');
disp('Spelar bra när den får öppna (svår + tar chanser).');
disp('********************************************************************');
pause

play(2,'bra');		% Spelar bra när den får öppna

disp('********************************************************************');
disp('Spelar skapligt när den inte får öppna (543).');
disp('********************************************************************');
pause;

play2(2,'bra');		% Spelar skapligt när den inte öppnar

