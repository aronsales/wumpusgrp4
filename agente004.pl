%  Some simple test agents.
% 
%  To define an agent within the navigate.pl scenario, define:
%    init_agent
%    restart_agent
%    run_agent
% 
%  Currently set up to solve the wumpus world in Figure 6.2 of Russell and
%  Norvig.  You can enforce generation of this world by changing the
%  initialize(random,Percept) to initialize(fig62,Percept) in the
%  navigate(Actions,Score,Time) procedure in file navigate.pl and then run
%  navigate(Actions,Score,Time).
%
%  Lista de Percepcao: [Stench,Breeze,Glitter,Bump,Scream]
%  Traducao: [Fedor,Vento,Brilho,Trombada,Grito]
%  Acoes possiveis:
%  goforward - andar
%  turnright - girar sentido horario
%  turnleft - girar sentido anti-horario
%  grab - pegar o ouro
%  climb - sair da caverna
%  shoot - atirar a flecha
%
%  Copie wumpus1.pl e agenteXX.pl onde XX eh o numero do seu agente (do grupo)
%  para a pasta rascunhos e depois de pronto para trabalhos
%  Todos do grupo devem copiar para sua pasta trabalhos, 
%  com o mesmo NUMERO, o arquivo identico.
%
%  Para rodar o exemplo, inicie o prolog com:
%  swipl -s agente007.pl
%  e faca a consulta (query) na forma:
%  ?- start.

:- load_files([wumpus3]).
:- dynamic([orientacao/1,
            posicao/2,
            volta/1,
            casas_seguras/1,
            casas_perigosas/1,
            casas_visitadas/1,
            numero_giros/1]). 

        wumpusworld(pit3, 4). %tipo, tamanho

init_agent:-
    retractall(orientacao(_)),
    retractall(posicao(_)),
    retractall(volta(_)),
    retractall(casas_seguras(_)),
    retractall(casas_perigosas(_)),
    retractall(casas_visitadas(_)),
    retractall(numero_giros(_)),
    assert(numero_giros(0)),
    assert(orientacao( 0 )),
    assert(posicao([1,1])),
    assert(volta( 0 )),
    assert(casas_seguras([])),
    assert(casas_perigosas([])),
    assert(casas_visitadas([[1,1]])).

restart_agent:-
    init_agent.
    
run_agent(P,Acao):-
    write('Percebi: '),
    writeln( P ),
    casas_seguras( X ),
    write('Casas Seguras: '),
    writeln( X ),
    casas_perigosas( Z ),
    write('Casas Perigosas: '),
    writeln( Z ),
    casas_visitadas(I),
    write('Casas Visitadas: '),
    writeln(I),
    posicao(Pos),
    write('Posicao: '),
    writeln(Pos),
    orientacao(O),
    write('Orientacao: '),
    writeln(O),
    %%%%%%%%%%%%%%%%%%%%%% 
    verificar(P),
    agente_movimento(P,Acao),
    visitadas,
    retirar_seguras.

girei:-
    numero_giros(Ng),
    Ng1 is Ng+1,
    retractall(numero_giros(_)),
    assert(numero_giros(Ng1)).
    
agente_movimento([no,no,no,no,no],goforward):-
    local_agent.

agente_movimento([_,_,_,_,_], goforward):-
    numero_giros(Ng),
    Ng==2,
    retractall(numero_giros(_)),
    assert(numero_giros(0)),
    local_agent.

%agente_movimento([no,yes,no,no,no], turnleft):-
%    girei,
%    viraesquerda.

%agente_movimento([yes,_,_,_,_], turnleft):-
    %girei,
    %viraesquerda.
   %senti_wumpus([Acao|S]),
   %retractall(senti_wumpus(_)),
   %assert(senti_wumpus(S)).

   %agente_movimento([_,_,_,yes,_], turnright):- %ao esbarrar mudará sua direcao para direita
   %viradireita.
    %esbarrada([Acao|S]),
    %retractall(esbarrada(_)),
    %assert(esbarrada(S)).

%flecha:-  % Depois de disparar a flecha, o agente decrementa 1 flecha.
%    flecha(X),
%    X > 0,
%    Z is X - 1,
%    retractall(flecha(_)),
%    assert(flecha(Z)).
%
viraesquerda :- %virar esquerda
    orientacao(O),
    B is O + 90,
    C is B mod 360,
    retractall(orientacao(_)),
    assert(orientacao(C)).
    
viradireita :- %virar direita
    orientacao(O),
    B is O - 90,
    C is B mod 360,
    retractall(orientacao(_)),
    assert(orientacao(C)).

local_agent:- 
    orientacao(0),
    posicao([X,Y]),
    X < 4,
    Z is X+1,
    retractall(posicao(_)),
    assert(posicao([Z,Y])).
    
local_agent:-
    orientacao(90),
    posicao([X,Y]),
    Y < 4,
    Z is Y+1,
    retractall(posicao(_)),
    assert(posicao([X,Z])).
    
local_agent:- 
    orientacao(180),
    posicao([X,Y]),
    X > 1,
    Z is X - 1,
    retractall(posicao(_)),
    assert(posicao([Z,Y])).
    
local_agent:- 
    orientacao(270),
    posicao([X,Y]),
    Y > 1,
    Z is Y-1,
    retractall(posicao(_)),
    assert(posicao([X,Z])).

verificar([no,no,_,_,_]):-
    frente,
    cima,
    tras,
    baixo.

frente:- 
    casas_seguras(A),
    posicao([X,Y]),
    X < 4,
    Z is X+1,
    not(member([Z,Y], A)),
    append(A,[[Z,Y]],C),
    retractall(casas_seguras(_)),
    assert(casas_seguras(C)).
frente.

cima:- 
    casas_seguras(A),
    posicao([X,Y]),
    Y < 4,
    Z is Y+1,
    not(member([X,Z],A)),
    append(A,[[X,Z]], C),
    retractall(casas_seguras(_)),
    assert(casas_seguras(C)).
cima.

tras:- 
    casas_seguras(A),
    posicao([X,Y]),
    X > 1,
    Z is X-1,
    not(member([Z,Y],A)),
    append(A,[[Z,Y]],C),
    retractall(casas_seguras(_)),
    assert(casas_seguras(C)).
tras.

baixo:- 
    casas_seguras(A),
    posicao([X,Y]),
    Y > 1,
    Z is Y-1,
    not(member([X,Z],A)),
    append(A,[[X,Z]],C),
    retractall(casas_seguras(_)),
    assert(casas_seguras(C)).
baixo.


visitadas:-
   casas_visitadas(A),
   posicao([X,Y]),
   delete(A,[X,Y],C),
   append(C,[[X,Y]],B),
   retractall(casas_visitadas(_)),
   assert(casas_visitadas(B)).

retirar_seguras:-
    casas_seguras(A),
    posicao([X,Y]),
    delete(A,[X,Y],D),
    delete(D,[1,1],C),
    retractall(casas_seguras(_)),
    assert(casas_seguras(C)).

%perigosas_S:-
%   casas_perigosas(A),
%   posicao(X,Y),
%   delete(A,[X,Y],C),
%   append(C,[[X,Y]],B),
%   retractall(casas_perigosas(_)),
%   assert(casas_perigosas(B)).

%perigosas_B:-
%   casas_perigosas(A),
%   posicao(X,Y),
%   delete(A,[X,Y],C),
%   append(C,[[X,Y]],B),
%   retractall(casas_perigosas(_)),
%   assert(casas_perigosas(B)).
 
