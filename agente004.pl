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
% ?- starti.

:- load_files([wumpus3]).

wumpusworld(pit3, 4). %tipo, tamanho

agentesperto([turnleft,turnleft,goforward,turnright,goforward]).

init_agent :-% se nao tiver nada para fazer aqui, simplesmente termine com um ponto (.)
    retractall(agenteesperto(_)),
	assert(agenteesperto([turnleft,turnleft,goforward,turnright,goforward])),
    writeln('Agente iniciando...').% apague esse writeln e coloque aqui as acoes para iniciar o agente
    

% esta funcao permanece a mesma. Nao altere.
restart_agent :- 
	init_agent.

% esta e a funcao chamada pelo simulador. Nao altere a "cabeca" da funcao. Apenas o corpo.
% Funcao recebe Percepcao, uma lista conforme descrito acima.
% Deve retornar uma Acao, dentre as acoes validas descritas acima.
run_agent(Percepcao, Acao) :-
  write('percebi: '), % pode apagar isso se desejar. Imprima somente o necessario.
  writeln(Percepcao), % apague para limpar a saida. Coloque aqui seu codigo.
  cabeca_dura(Percepcao, Acao).

cabeca_dura([no,yes,no,no,no],A) :-
    agenteesperto([A|F]),
    retractall(agenteesperto(_)),
    assert(agenteesperto(_)).

cabeca_dura([no,no,no,no,no],goforward).


