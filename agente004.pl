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
            senti_buraco/1,
            esbarrada/1]).

wumpusworld(pit3, 4). %tipo, tamanho

init_agent:-
    retractall(esbarrada(_)), %variavel pra guardar a lista de açoes caso esbarre
    retractall(senti_buraco(_)), %variavel pra guardar a lista de ações caso sinta uma brisa
    retractall(senti_wumpus(_)),
    retractall(orientacao(_)),
    retractall(posicao(_,_)),
    retractall(volta(_)),
    retractall(casas_seguras(_)),
    retractall(casas_perigosas(_)),
    retractall(casas_visitadas(_)),
    retractall(ouro(_)),
    assert(ouro(0)),
    assert(orientacao( 0 )),
    assert(posicao(1,1)),
    assert(volta( 0 )),
    assert(casas_seguras([])),
    assert(casas_perigosas([])),
    assert(casas_visitadas([])),
    assert(senti_buraco([turnleft,turnleft,goforward])), %ações pra executar caso sinta uma brisa
    assert(senti_wumpus([turnleft,turnleft,goforward])), %ações pra executar caso sinta fedor
    assert(esbarrada([turnright])). %ações para executar caso esbarre

restart_agent:-
   init_agent.

run_agent(P,A):-
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
    visitadas,
    local_agent,
    frente(P),
    cima(P),
    traz(P),
    baixo(P),
    ouro(P,A);
    agente_movimento(P,A).

%ouro([_,_,yes,_,_], grab).

   casas_seguras([]).
    
agente_movimento([no,no,no,no,no],goforward).

agente_movimento([no,yes,no,no,no], A) :-
   senti_buraco([A|S]), %Coloca o A(Acao) como cabeça da lista
   retractall(senti_buraco(_)), %Limpa a variavel
    assert(senti_buraco(S)). %Declara a variavel como a cauda da lista
   
agente_movimento([yes,_,_,_,_], A):- %ao senti um fedor andara uma cassa para trás
    senti_wumpus([A|S]),
   retractall(senti_wumpus(_)),
   assert(senti_wumpus(S)).

agente_movimento([_,_,_,yes,_], A) :- %ao esbarrar mudará sua direcao para direita
    esbarrada([A|S]),
    retractall(esbarrada(_)),
    assert(esbarrada(S)).

agente_movimento([_,_,yes,_,_],grab).

virae :- %virar esquerda
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

local_agent :- 
    orientacao(0),
    posicao(X,Y),
    Z is X + 1,
    X < 4,
    retractall(posicao(_,_)),
    assert(posicao(Z,Y)).

local_agent :-
    orientacao(90),
    posicao(X,Y),
    Z is Y + 1,
    Y < 4,
    retractall(posicao(_,_)),
    assert(posicao(X,Z)).

local_agent :- 
    orientacao(180),
    posicao(X,Y),
    Z is X - 1,
    X  >  1,
    retractall(posicao(_,_)),
    assert(posicao(Z,Y)).

local_agent :- 
    orientacao(270),
    posicao(X,Y),
    Z is Y - 1,
    Y  >  1,
    retractall(posicao(_,_)),
    assert(posicao(X,Z)).

local_agent.

frente([no,no,_,_,_]):- 
    casas_seguras(A),
    posicao(Z,B),
    orientacao(0),
    X is Z + 1,
    Z < 4,
    not(member([X,B], A)),
    append([[X,B]],A, C),
    retractall(casas_seguras(_)),
    assert(casas_seguras(C)).
frente.

cima([no,no,_,_,_]):- 
    casas_seguras(A),
    posicao(Z,B),
    orientacao(90),
    Y is B + 1,
    B < 4,
    not(member([Z,Y],A)),
    append([[Z,Y]],A, D),
    retractall(casas_seguras(_)),
    assert(casas_seguras(D)).
cima.

traz([no,no,_,_,_]):- 
    casas_seguras(A),
    posicao(Z,B),
    orientacao(180),
    X is Z - 1,
    Z > 1,
    not(member([X,B],A)),
    append(A,[[X,B]],C),
    retractall(casas_seguras(_)),
    assert(casas_seguras(C)).
traz.

baixo([no,no,_,_,_]):- 
    casas_seguras(A),
    posicao(Z,B),
    orientacao(270),
    Y is B - 1,
    B > 1,
    not(member([Z,Y],A)),
    append(A,[[Z,Y]],D),
    retractall(casas_seguras(_)),
    assert(casas_seguras(D)).
baixo.

verificar([no,no,_,_,_]):-
    frente(P),cima(P),traz(P),baixo(P),write('Verificacao concluida').

visitadas:-
   casas_visitadas(A),
   posicao(X,Y),
   delete(A,[X,Y],C),
   append(C,[[X,Y]],B),
   retractall(casas_visitadas(_)),
   assert(casas_visitadas(B)).

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

