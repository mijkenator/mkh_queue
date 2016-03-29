%%%-------------------------------------------------------------------
%% @doc mkh_queue top level supervisor.
%% @end
%%%-------------------------------------------------------------------

-module(mkh_queue_sup).

-behaviour(supervisor).

%% API
-export([start_link/0, new_queue/0, delete_queue/1]).

%% Supervisor callbacks
-export([init/1]).

-define(SERVER, ?MODULE).

%%====================================================================
%% API functions
%%====================================================================

start_link() ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, []).

new_queue()  ->
    supervisor:start_child(?MODULE, []).

delete_queue(CPid) ->
    supervisor:terminate_child(?MODULE, CPid).
%%====================================================================
%% Supervisor callbacks
%%====================================================================

%% Child :: {Id,StartFunc,Restart,Shutdown,Type,Modules}
init([]) ->
    {ok, { {simple_one_for_one, 10, 60}, [
        {fifo_worker, {fifo_worker, start_link, []}, temporary, brutal_kill, worker, [fifo_worker]}
    ]} }.

%%====================================================================
%% Internal functions
%%====================================================================
