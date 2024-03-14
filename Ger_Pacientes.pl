
:- dynamic patient/5.

%% load_data is det 
%
%  Carrega os dados dos pacientes a partir do arquivo 'pacientes.txt'.
load_data :-
  (exists_file('pacientes.txt') ->
  retractall(patient(_, _, _, _, _)), % clear existing facts
  open('pacientes.txt', read, Str),
  read_file(Str, _),
  close(Str)
  ;
  open('pacientes.txt', write, Str),
  close(Str),
  write('Arquivo pacientes.txt criado.'), nl).

%% read_file(+Stream, -L) is nondet
%
%  Lê um arquivo e retorna uma lista com os dados lidos.
read_file(Stream, []) :-
    at_end_of_stream(Stream), !.
read_file(Stream, [X | L]) :-
    \+ at_end_of_stream(Stream),
    read(Stream, X),
    assert(X),
    read_file(Stream, L).

%% paciente_existe(ID+) is semidet
%
%  Verifica se um paciente com o ID fornecido existe.
paciente_existe(Id) :-
  patient(Id, _, _, _, _).


% Query a patient
query_patient(Id) :-
    patient(Id, Nome, Idade, Sintomas, Doencas),
    write('Id: '), write(Id), nl,
    write('Nome: '), write(Nome), nl,
    write('Idade: '), write(Idade), nl,
    write('Sintomas: '), write(Sintomas), nl,
    write('Doenca: '), write(Doencas), nl.

% Include a new patient
include_patient(Id, Nome, Idade, Sintomas, Doencas) :-
    assert(patient(Id, Nome, Idade, Sintomas, Doencas)),
    tell('pacientes.txt'),
    listing(patient/5),
    told.

% Change a patient's data
change_patient(Id, Nome, Idade, Sintomas, Doencas) :-
    retract(patient(Id, _, _, _, _)),
    assert(patient(Id, Nome, Idade, Sintomas, Doencas)),
    tell('pacientes.txt'),
    listing(patient/5),
    told.

% Exclude a patient
exclude_patient(Id) :-
    retract(patient(Id, _, _, _, _)),
    tell('pacientes.txt'),
    listing(patient/5),
    told.

% add_symptoms(+Id, +Sintomas) is det 
%
% Adiciona um sintoma a um paciente, lembrando que sintoma é uma lista, inicialmente vazia, mas que pode ser alterada.
add_sintoma(Id, Sintoma) :-
  patient(Id, Nome, Idade, OldSintomas, Doencas),
  append(OldSintomas, Sintoma, NewSintomas),
  change_patient(Id, Nome, Idade, NewSintomas, Doencas).

% add_disease(+Id, +Doenca) is det 
%
% Adiciona uma doença a um paciente.
add_doenca(Id, Doenca) :-
  patient(Id, Nome, Idade, Sintomas, OldDoencas),
  append(OldDoencas, Doenca, NewDoencas),
  change_patient(Id, Nome, Idade, Sintomas, NewDoencas).

%% menu_ger_pacientes is det
%
%  Exibe o menu de gerenciamento de pacientes.
menu_ger_pacientes :-
  consult('main.pl'),
  nl,
  write('Gerenciamento de Pacientes'), nl, nl,

  write('1. Pesquisar Paciente'), nl,
  write('2. Incluir Paciente'), nl,
  write('3. Excluir Paciente'), nl,
  write('4. Alterar Paciente'), nl,
  write('5. Voltar'), nl, nl,

  read(Option),
  process_ger_pacientes(Option).

%% process_ger_pacientes(+Option) is det 
%
%  Processa a opção escolhida no menu de gerenciamento de pacientes.
process_ger_pacientes(1) :-
  write('Digite o ID do paciente: '), nl,
  read(Id),
  (paciente_existe(Id) -> query_patient(Id); write('Paciente não encontrado.')), nl,
  menu_ger_pacientes.

% Inclui um novo paciente, e cria listas vazias para sintomas e doenças caso o usuário não queira informar.
process_ger_pacientes(2) :-
  write('Digite o ID do paciente: '), nl,
  read(Id),
  (paciente_existe(Id) -> write('Paciente já cadastrado!'), nl;
  write('Digite o nome do paciente: '), nl,
  read(Nome),
  write('Digite a idade do paciente: '), nl,
  read(Idade), nl,
  include_patient(Id, Nome, Idade, [], []),
  write('Paciente incluído com sucesso.'), nl),
  menu_ger_pacientes.

process_ger_pacientes(3) :-
  write('Digite o ID do paciente: '), nl,
  read(Id),
  (paciente_existe(Id) -> exclude_patient(Id), write('Paciente excluído com sucesso.'); nl, write('Paciente não encontrado!')), nl,
  menu_ger_pacientes.

process_ger_pacientes(4) :-

  write('Digite o ID do paciente: '), nl,
  read(Id),
  (paciente_existe(Id) -> 
    write('Digite o nome do paciente: '), nl,
    read(Nome),
    write('Digite a idade do paciente: '), nl,
    read(Idade),
    write('Digite os sintomas do paciente: '), nl,
    read(Sintomas),
    write('Digite a doença do paciente: '), nl,
    read(Doencas),
    change_patient(Id, Nome, Idade, Sintomas, Doencas),
    write('Paciente alterado com sucesso.'), nl
  ; 
    write('Paciente não encontrado!'), nl
  ), nl,
  menu_ger_pacientes.

process_ger_pacientes(5) :-
  menu.


