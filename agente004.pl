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

% Lista de Percepcao: [Stench,Breeze,Glitter,Bump,Scream]
% Traducao: [Fedor,Vento,Brilho,Trombada,Grito]
% Acoes possiveis:
% goforward - andar
% turnright - girar sentido horario
% turnleft - girar sentido anti-horario
% grab - pegar o ouro
% climb - sair da caverna
% shoot - atirar a flecha

% Copie wumpus1.pl e agenteXX.pl onde XX eh o numero do seu agente (do grupo)
% para a pasta rascunhos e depois de pronto para trabalhos
% Todos do grupo devem copiar para sua pasta trabalhos, 
% com o mesmo NUMERO, o arquivo identico.

% Para rodar o exemplo, inicie o prolog com:
% swipl -s agente007.pl
% e faca a consulta (query) na forma:
% ?- start

:- load_files([wumpus3]).
:- dynamic ([sentiburaco/1,esbarrada/1,sentiwumpus/1,numeroflechas(X),minhafrente]).
wumpusworld(pit3, 4). %tipo, tamanho

init_agent :- % se nao tiver nada para fazer aqui, simplesmente termine com um ponto (.)
    writeln('Agente iniciado em conjunto com as funcoes'),
    retractall(sentiburaco(_)),
    assert(sentiburaco([turnleft,turnleft,goforward,turnright,goforward])),
    retractall(esbarrada(_)),
    assert(esbarrada([turnright,goforward,turnright,goforward,turnright,goforward,turnright,goforward,turnright,goforward])),
    retractall(sentiwumpus(_)),
    assert(sentiwumpus([turnleft,goforward]))
    retractall(numeroflechas(X)),
    assert(numeroflechas(1)).


% esta funcao permanece a mesma. Nao altere.
restart_agent:- 
	init_agent.

% esta e a funcao chamada pelo simulador. Nao altere a "cabeca" da funcao. Apenas o corpo.
% Funcao recebe Percepcao, uma lista conforme descrito acima.
% Deve retornar uma Acao, dentre as acoes validas descritas acima.
run_agent(Percepcao, Acao) :-
    write('Percebi: '), % pode apagar isso se desejar. Imprima somente o necessario.
    writeln(Percepcao), % apague para limpar a saida. Coloque aqui seu codigo.
    cabeca_dura(Percepcao,Acao),
    frente(Posicao,Posicao1).

sentiburaco([turnleft,turnleft,goforward,turnright,goforward]).
cabeca_dura([_,yes,no,no,no], A) :- 
    sentiburaco([A|S]),
    retractall(sentiburaco(_)),
    assert(sentiburaco(S)).

cabeca_dura([no,no,no,no,no], goforward).
cabeca_dura([yes,no,no,no,no], shoot).
cabeca_dura([_,_,yes,_,_], grab).
cabeca_dura([yes,yes,no,no,no], shoot).

esbarrada([turnright,goforward,turnright,goforward,turnright,goforward,turnright,goforward,turnright,goforward]).
cabeca_dura([no,no,no,yes,no], A) :-
    esbarrada([A|E]),
    assert(esbarrada(E)).

sentiwumpus([turnleft,goforward]).
cabeca_dura([yes,_,no,no,no], A) :-
    sentiwumpus([A|W]),
    retractall(sentiwumpus(_)),
    assert(sentiwumpus(W)).

%frente([1,1], 0, [2,1]).
    

