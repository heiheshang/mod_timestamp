-module(mod_timestamp).

-behaviour(gen_mod).

-export([start/2, stop/1, reload/3, user_send_packet/1,user_receive_packet/1,
	 mod_options/1, depends/2, mod_doc/0]).

-include("logger.hrl").
-include_lib("xmpp/include/xmpp.hrl").
-include("translate.hrl").

start(Host, _Opts) ->
ok=xmpp:register_codec(timestamp),
ejabberd_hooks:add(user_send_packet, Host, ?MODULE,
		       user_send_packet, 75),
ejabberd_hooks:add(user_receive_packet, Host, ?MODULE,
		       user_receive_packet, 76).

stop(Host) ->
    ejabberd_hooks:delete(user_send_packet, Host, ?MODULE,
    user_send_packet, 75),
    ejabberd_hooks:delete(user_receive_packet, Host, ?MODULE,
    user_receive_packet, 76),
    xmpp:unregister_codec(timestamp).

reload(_Host, _NewOpts, _OldOpts) ->
    ok.

-spec user_send_packet({stanza(), ejabberd_c2s:state()}) -> {stanza(), ejabberd_c2s:state()}.
user_send_packet({{message,Id,
                chat,
                Lang,
			    From,
                _To,
                Subject,
                Body,
                 _T,
                Thread,
                Sub
				} = Pkt,State}) ->
    {Mega, Sec, Micro} = os:timestamp(),
    NewTs=(Mega*1000000 + Sec)*1000 + round(Micro/1000),
    Now_local = integer_to_list(NewTs), 
    FromNew = jid:make(<<"">>, <<"localhost">>, list_to_binary(atom_to_list(?MODULE))),
    NewMSG = {message,Id,chat,Lang,FromNew,From,Subject,Body,NewTs,Thread,Sub},
    NewMSG_tag = xmpp:set_subtag(NewMSG,#message_timestamp{ timestamp = NewTs}),
    ?INFO_MSG("~p\n",[NewMSG_tag]),
    ejabberd_router:route(NewMSG_tag),
    {Pkt, State};
user_send_packet({P,_S} = Pkt) ->
    ?INFO_MSG("~p\n",[P]),
    Pkt.

user_receive_packet(P) ->
    P.

depends(_Host, _Opts) ->
    [].

mod_options(_Host) ->
    [].

mod_doc() ->
    #{desc =>
          ?T("an attempt to add a tag to a message")}.
