% Some simple test agents.
%
% To define an agent within the navigate.pl scenario, define:
%   init_agent
%   restart_agent
%   run_agent
%
% Currently set up to solve the wumpus world in Figure 6.2 of Russell and
% Norvig.  You can enforce generation of this world by changing the
% initialize(random,Percept) to initialize(fig62,Percept) in the
% navigate(Actions,Score,Time) procedure in file navigate.pl and then run
% navigate(Actions,Score,Time).
%   init_agent
%   restart_agent
%   run_agent
%
% Currently set up to solve the wumpus world in Figure 6.2 of Russell and
% Norvig.  You can enforce generation of this world by changing the
% initialize(random,Percept) to initialize(fig62,Percept) in the
% navigate(Actions,Score,Time) procedure in file navigate.pl and then run
% navigate(Actions,Score,Time).
%
% Lista de Percepcao: [Stench,Breeze,Glitter,Bump,Scream]
% Traducao: [Fedor,Vento,Brilho,Trombada,Grito]
% Acoes possiveis:
% goforward - andar
% turnright - girar sentido horario
% turnleft - girar sentido anti-horario
% grab - pegar o ouro
% climb - sair da caverna
% shoot - atirar a flecha
%
% Copie wumpus1.pl e agenteXX.pl onde XX eh o numero do seu agente (do grupo)
% para a pasta rascunhos e depois de pronto para trabalhos
% Todos do grupo devem copiar para sua pasta trabalhos,
% com o mesmo NUMERO, o arquivo identico.
%
% Para rodar o exemplo, inicie o prolog com:
% swipl -s agente007.pl
% e faca a consulta (query) na forma:
% ?- start

:- load_files([wumpus3]).
:- dynamic([orientcao/1,posicao/2,volta/1, casas_seguras/1,casas_perigosas/1, casas_visitadas/1]).
wumpusworld(pit3, 4). %tipo, tamanho

init_agent:-
    retractall(orientancao(_)),
    retractall(posicao(,)),
    retractall(volta(_)),
    retractall(casas_seguras(_)),
    retractall(casas_perigosas(_)),
    retractall(casas_visitadas(_)),
    assert(orientacao( 0 )),
    assert(posicao(1,1)),
    assert(volta( 0 )),
    assert(casas_seguras([])),
    assert(casas_perigosas([])),
    assert(casas_visitadas([])).

restart_agent:-
    init_agent.

run_agent(P,_):-
    write('Percebi: '),
    writeln( P ),
    casas_seguras( X ),
    write('Casas Seguras :'),
    writeln( X ),
    casas_perigosas( Z ),
    write('Casas Perigosas: '),
    writeln( Z ),
    casas_visitadas(I),
    write('Casas Visitadas :'),
    writeln(I),
    casa_segura(P).

ouro([_,_,yes,_,_], grab).
sair(_, climb) :- 
    posicao(1,1),
    casas_seguras([]).

virare :- %virar esquerda
    orientacao(A),
    B is A + 90,
    C is B mod 360,
    retractall(orientacao(_)),
    assert(orientacao(C)).

virad :- %virar direita
    orientacao(A),
    B is A - 90,
    C is B mod 360,
    retractall(orientacao(_)),
    assert(orientacao(C)).

local_agent :- %andar frente direita
    orientacao(0),
    posicao(X,Y),
    Z is X + 1,
    X < 4,
    retractall(posicao(_,_)),
    assert(posicao(Z,Y)).

local_agent :- %andar cima
    orientacao(90),
    posicao(X,Y),
    Z is Y + 1,
    Y < 4,
    retractall(posicao(_,_)),
    assert(posicao(X,Z)).

local_agent :- %andar tras esquerda
    orientacao(180),
    posicao(X,Y),
    Z is X - 1,
    X  >  1,
    retractall(posicao(_,_)),
    assert(posicao(Z,Y)).

local_agent :- %andar baixo
    orientacao(270),
    posicao(X,Y),
    Z is Y - 1,
    Y  >  1,
    retractall(posicao(_,_)),
    assert(posicao(X,Z)).

local_agent.

casa_segura([no,no,_,_,_]) :- %direita
    casas_seguras(A),
    posicao(Z,B),
    orientacao(0),
    X is Z + 1,
    Z < 4,
    not(member([X,B], A)),
    append(A,[[X,B]], C),
    retractall(casas_seguras(_)),
    assert(casas_seguras(C)).

casa_segura([no,no,_,_,_]) :- %cima
    casas_seguras(A),
    posicao(Z,B),
    orientacao(90),
    Y is B + 1,
    B < 4,
    not(member([Z,Y], A)),
    append(A,[[Z,Y]], D),
    retractall(casas_seguras(_)),
    assert(casas_seguras(D)).

casa_segura([no,no,_,_,_]) :- %esquerda
    casas_seguras(A),
    posicao(Z,B),
    orientacao(180),
    X is Z - 1,
    Z > 1,
    not(member([X,B],A)),
    append(A,[[X,B]],C),
    retractall(casas_seguras(_)),
    assert(casas_seguras(C)).

casa_segura([no,no,_,_,_]) :- %baixo
    casas_seguras(A),
    posicao(Z,B),
    orientacao(270),
    Y is B - 1,
    B > 1,
    not(member([Z,Y],A)),
    append(A,[[Z,Y]],D),
    retractall(casas_seguras(_)),
    assert(casas_seguras(D)).
    

