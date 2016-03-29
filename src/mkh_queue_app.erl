%%%-------------------------------------------------------------------
%% @doc mkh_queue public API
%% @end
%%%-------------------------------------------------------------------

-module(mkh_queue_app).

-ifdef(TEST).
-include_lib("eunit/include/eunit.hrl").
-endif.

-behaviour(application).

%% Application callbacks
-export([start/2, start/0, stop/1, stop/0]).

-ifdef(TEST).
%% EUnit tests
-export([
    mqa_1_test/0
]).
-endif.

%%====================================================================
%% API
%%====================================================================

start()     -> start(ok, ok).
start(_, _) -> mkh_queue_sup:start_link().

%%--------------------------------------------------------------------
stop(_State) -> ok.
stop()       -> stop([]).
%%====================================================================
%% Internal functions
%%====================================================================

-ifdef(TEST).
mqa_1_test() ->
   ?assertEqual(ok, application:start(mkh_queue)),
   ?assertMatch({ok, X} when is_pid(X), mkh_queue_sup:new_queue()),
   {ok, Q1} = mkh_queue_sup:new_queue(),
   ?assertEqual({error, empty}, gen_server:call(Q1, out)),
   ?assertEqual(ok, gen_server:cast(Q1, {in, lalalala1})), 
   ?assertEqual(ok, gen_server:cast(Q1, {in, lalalala2})), 
   ?assertEqual(ok, gen_server:cast(Q1, {in, lalalala3})), 
   ?assertEqual(ok, gen_server:cast(Q1, {in, lalalala4})), 
   ?assertEqual(ok, gen_server:cast(Q1, {in, lalalala5})), 
   ?assertEqual({ok, lalalala1}, gen_server:call(Q1, out)),
   ?assertEqual({ok, lalalala2}, gen_server:call(Q1, out)),
   ?assertEqual({ok, lalalala3}, gen_server:call(Q1, out)),
   ?assertEqual({ok, lalalala4}, gen_server:call(Q1, out)),
   ?assertEqual({ok, lalalala5}, gen_server:call(Q1, out)),
   ?assertEqual({error, empty}, gen_server:call(Q1, out)),
   ?assertEqual(ok, mkh_queue_sup:delete_queue(Q1)),
   ok. 
-endif.
