-module(efactor).

%% API exports
-export([main/1]).

%%====================================================================
%% API functions
%%====================================================================

%% escript Entry point
main(Args) ->
    io:format("Args: ~p~n", [Args]),
    {ok, _} = application:ensure_all_started(wrangler),
    case Args of
        [Command | Rest] ->
            Result = process_command(Command, Rest),
            %% io:format("Result = ~p~n", [Result]);
            Result;
        _ ->
            ok
    end,
    erlang:halt(0).

%%====================================================================
%% Internal functions
%%====================================================================

process_command("gen_module_graph", Rest) ->
    [Filename | SearchPaths] = Rest,
    inspec_lib:dependencies_of_a_module(
      filename:absname(Filename),
      [filename:absname(X) || X <- SearchPaths]);
process_command("gen_function_callgraph", Rest) ->
    [OutputDotFilename, Filename | SearchPaths] = Rest,
    inspec_lib:gen_function_callgraph(
      filename:absname(OutputDotFilename),
      filename:absname(Filename),
      [filename:absname(X) || X <- SearchPaths]);
process_command("cyclic_dependent_modules", Rest) ->
    [OutputDotFilename | SearchPaths] = Rest,
    inspec_lib:cyclic_dependent_modules(
      filename:absname(OutputDotFilename),
      [filename:absname(X) || X <- SearchPaths],
      true);
process_command("improper_inter_module_calls", Rest) ->
    [OutputDotFilename | SearchPaths] = Rest,
    inspec_lib:improper_inter_module_calls(
      filename:absname(OutputDotFilename),
      [filename:absname(X) || X <- SearchPaths]);
process_command("large_modules", Rest) ->
    [NumLinesInput | SearchPaths] = Rest,
    NumLines = list_to_integer(NumLinesInput),
    inspec_lib:large_modules(
      [filename:absname(X) || X <- SearchPaths],
      NumLines);
process_command("long_functions", Rest) ->
    [NumLinesInput | SearchPaths] = Rest,
    NumLines = list_to_integer(NumLinesInput),
    inspec_lib:long_functions(
      [filename:absname(X) || X <- SearchPaths],
      NumLines);
process_command("nested_exprs", Rest) ->
    [NestLevelsInput, ExprTypeInput | SearchPaths] = Rest,
    NestLevels = list_to_integer(NestLevelsInput),
    ExprType = list_to_atom(ExprTypeInput),
    inspec_lib:nested_exprs(
      [filename:absname(X) || X <- SearchPaths],
      NestLevels,
     ExprType);
process_command("dependencies_of_a_module", Rest) ->
    [Filename | SearchPaths] = Rest,
    inspec_lib:dependencies_of_a_module(
      filename:absname(Filename),
      [filename:absname(X) || X <- SearchPaths]);
process_command("calls_to_fun", Rest) ->
    [Filename, FunctionNameInput, ArityInput | SearchPaths] = Rest,
    FunctionName = list_to_atom(FunctionNameInput),  %% unsafe
    Arity = list_to_integer(ArityInput),
    inspec_lib:calls_to_fun(
      filename:absname(Filename),
      FunctionName,
      Arity,
      [filename:absname(X) || X <- SearchPaths]);
process_command("find_var_instances", Rest) ->
    [Filename, LineInput, ColumnInput, TabWidthInput] = Rest,
    Line = list_to_integer(LineInput),
    Column = list_to_integer(ColumnInput),
    TabWidthInput = list_to_integer(TabWidthInput),
    inspec_lib:find_var_instances(
      filename:absname(Filename),
      Line,
      Column,
      TabWidthInput);

%% These commands applies real refactoring
process_command("move_fun", Rest) ->
    [FromFilename, FunctionNameInput, FunArityInput, ToFilename | SearchPaths] = Rest,
    FunctionName = list_to_atom(FunctionNameInput),  %% unsafe
    FunArity = list_to_integer(FunArityInput),
    api_wrangler:move_fun(
      filename:absname(FromFilename),
      FunctionName,
      FunArity,
      filename:absname(ToFilename),
      [filename:absname(X) || X <- SearchPaths]);
process_command("rename_fun", Rest) ->
    [Filename, FunctionNameInput, FunArityInput, NewFunctionNameInput | SearchPaths] = Rest,
    FunctionName = list_to_atom(FunctionNameInput),  %% unsafe
    FunArity = list_to_integer(FunArityInput),
    NewFunctionName = list_to_atom(NewFunctionNameInput),  %% unsafe
    api_wrangler:rename_fun(
      filename:absname(Filename),
      FunctionName,
      FunArity,
      NewFunctionName,
      [filename:absname(X) || X <- SearchPaths]);
process_command("rename_mod", Rest) ->
    [Filename, NewModuleInput | SearchPaths] = Rest,
    NewModule = list_to_atom(NewModuleInput),  %% unsafe
    api_wrangler:rename_mod(
      filename:absname(Filename),
      NewModule,
      [filename:absname(X) || X <- SearchPaths]);
process_command("copy_mod", Rest) ->
    [Filename, NewModuleInput | SearchPaths] = Rest,
    NewModule = list_to_atom(NewModuleInput),  %% unsafe
    api_wrangler:copy_mod(
      filename:absname(Filename),
      NewModule,
      [filename:absname(X) || X <- SearchPaths]);
process_command("similar_code", Rest) ->
    [Filename, MinLenInput, MinTokInput, MinFreqInput, MaxVarsInput, SimiScoreInput | SearchPaths] = Rest,
    MinLen = list_to_integer(MinLenInput),
    MinTok = list_to_integer(MinTokInput),
    MinFreq = list_to_integer(MinFreqInput),
    MaxVars = list_to_integer(MaxVarsInput),
    SimiScore = list_to_float(SimiScoreInput),
    api_wrangler:similar_code(
      [filename:absname(Filename)],
      MinLen,
      MinTok,
      MinFreq,
      MaxVars,
      SimiScore,
      [filename:absname(X) || X <- SearchPaths]).

