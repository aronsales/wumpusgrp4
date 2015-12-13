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
    retractall(orientacao(_)),
    retractall(posicao(_,_)),
    retractall(volta(_)),
    retractall(casas_seguras(_)),
    retractall(casas_perigosas(_)),
    retractall(casas_visitadas(_)),
    assert(orientacao( 0 )),
    assert(posicao(1,1)),
    assert(volta( 0 )),
    assert(casas_seguras([])),
    assert(casas_perigosas([])),
    assert(casas_visitadas([])),
    assert(senti_buraco([turnleft,turnleft,goforward])), %ações pra executar caso sinta uma brisa
    assert(esbarrada([turnleft,turnleft,goforward])). %ações para executar caso esbarre

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

ouro([_,_,yes,_,_], grab).

vazei(_, climb) :- 
   posicao(1,1).
   /*casas_seguras([]).*/

agente_movimento([no,no,no,no,no],goforward).

agente_movimento([no,yes,no,no,no], A) :-
    senti_buraco([A|S]), %Coloca o A(Acao) como cabeça da lista
    retractall(senti_buraco(_)), %Limpa a variavel
    assert(senti_buraco(S)). %Declara a variavel como a cauda da lista

agente_movimento([yes,_,_,_,_], shoot). %ao senti um fedor atira

agente_movimento([_,_,_,yes,_], A) :- %ao esbarrar andará uma casa para trás
    esbarrada([A|S]),
    retractall(esbarrada(_)),
    assert(esbarrada(S)).

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
