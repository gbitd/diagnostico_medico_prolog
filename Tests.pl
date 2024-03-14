:- use_module(library(plunit)).
:- consult('Ger_Pacientes.pl').
:- consult('Diagnostico.pl').

% Note: Não há testes para as funções interativas como menus e inputs.
% Note: Os testes podem falhar se o arquivo pacientes.txt não puder ser lido.
% Alguns testes estão falhando por falha na elaboração dos próprios testes, mas os predicados estão funcionanco
% corretamente na aplicação.
% Tarefa: corrigir os testes.
% Tarefa: adicionar mais testes.

:- begin_tests(load_data).

test(load_data) :-
    % Cria um arquivo temporário
    open('temp.txt', write, Stream),
    write(Stream, 'patient(444, \'Jooose\', 44, [tosse, coriza, tristeza, desmaios, desanimo], []).'),
    close(Stream),

    % Chama load_data
    load_data,

    % Verifica se os dados foram carregados corretamente
    patient(444, 'Jooose', 44, [tosse, coriza, tristeza, desmaios, desanimo], []),

    % Limpa o arquivo temporário e os fatos
    delete_file('temp.txt'),
    retractall(patient(_, _, _, _, _)).

:- end_tests(load_data).

:- begin_tests(read_file).

test(read_file) :-
    % Cria um arquivo temporário
    open('temp.txt', write, Stream),
    write(Stream, 'patient(444, \'Jooose\', 44, [tosse, coriza, tristeza, desmaios, desanimo], []).'),
    close(Stream),

    % Lê o arquivo de volta
    open('temp.txt', read, Stream2),
    read_file(Stream2, [X]),
    close(Stream2),

    % Verifica se os dados lidos correspondem aos dados escritos
    X = patient(444, 'Jooose', 44, [tosse, coriza, tristeza, desmaios, desanimo], []),

    % Limpa o arquivo temporário
    delete_file('temp.txt').

:- end_tests(read_file).


:- begin_tests(paciente_existe).

test(paciente_existe) :-
    assert(patient(123, 'João', 30, [tosse, febre, coriza], [])),

    paciente_existe(123),

    retractall(patient(_, _, _, _, _)).

test(paciente_nao_existe, fail) :-
    paciente_existe(456).

:- end_tests(paciente_existe).

:- begin_tests(add_sintoma).

test(add_sintoma) :-
    assert(patient(123, 'João', 30, [tosse, febre, coriza], [])),
    add_sintoma(123, [dor_de_cabeca]),
    patient(123, 'João', 30, [tosse, febre, coriza, dor_de_cabeca], []),
    retractall(patient(_, _, _, _, _)).

:- end_tests(add_sintoma).

:- begin_tests(add_doenca).

test(add_doenca) :-
    assert(patient(123, 'João', 30, [tosse, febre, coriza], [])),
    add_doenca(123, [covid]),
    patient(123, 'João', 30, [tosse, febre, coriza], [covid]),
    retractall(patient(_, _, _, _, _)).

:- end_tests(add_doenca).

:- begin_tests(contar_elementos_iguais).

test(contar_elementos_iguais) :-
    contar_elementos_iguais([1, 2, 3], [1, 2, 3], 3),
    contar_elementos_iguais([1, 2, 3], [4, 5, 6], 0),
    contar_elementos_iguais([1, 2, 3], [1, 2], 2),
    contar_elementos_iguais([1, 2, 3], [3, 2, 1], 3),
    contar_elementos_iguais([], [1, 2, 3], 0),
    contar_elementos_iguais([1, 2, 3], [], 0),
    contar_elementos_iguais([], [], 0).

:- end_tests(contar_elementos_iguais).

:- begin_tests(diagnostico).

test(diagnostico) :-
    assert(patient(1, 'João', 30, [tosse, febre, coriza], [])),
    assert(sintoma(covid, tosse)),
    assert(sintoma(covid, febre)),
    assert(sintoma(covid, coriza)),
    assert(sintoma(gripe, tosse)),
    assert(sintoma(gripe, coriza)),
    diagnostico(1, X),
    X = [(covid, 3), (gripe, 2)],
    retractall(patient(_, _, _, _, _)),
    retractall(sintoma(_, _)).

:- end_tests(diagnostico).

:- begin_tests(encontrar_diagnostico).

test(encontrar_diagnostico) :-
    assert(sintoma(covid, tosse)),
    assert(sintoma(covid, febre)),
    assert(sintoma(covid, coriza)),
    assert(sintoma(gripe, tosse)),
    assert(sintoma(gripe, coriza)),
    encontrar_diagnostico([tosse, febre, coriza], [covid, gripe], Diagnostico),
    Diagnostico = [(covid, 3), (gripe, 2)],
    retractall(sintoma(_, _)).

:- end_tests(encontrar_diagnostico).
