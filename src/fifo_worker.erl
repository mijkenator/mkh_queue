-module(fifo_worker).

-behaviour(gen_server).

-export([init/1,
         handle_call/3,
         handle_cast/2,
         handle_info/2,
         terminate/2,
         code_change/3]).

-export([start_link/0]).

-record(state, {ets, num}).

start_link() ->
     gen_server:start_link(?MODULE, [], []).

init(_Args) ->
     Ets=ets:new(list_to_atom(erlang:ref_to_list(make_ref())), [ordered_set, private]),
     {ok, #state{ets=Ets, num=0}}.

handle_cast({in, Elem}, #state{ets=Ets, num=N} = State) ->
     M = N + 1,
     ets:insert(Ets, {M, Elem}),
     {noreply, State#state{num=M}}.

handle_call(out, _, #state{ets=Ets}=State) ->
    Reply = case ets:first(Ets) of
        N when is_integer(N) -> 
            [{N, Ele}] = ets:lookup(Ets, N),
            ets:delete(Ets, N),
            {ok, Ele};
        '$end_of_table' -> {error, empty}
    end,
    {reply, Reply, State};
handle_call(_Request, _From, State) ->
    {reply, ignored, State}.

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

