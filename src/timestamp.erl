%% Created automatically by XML generator (fxml_gen.erl)
%% Source: xmpp_codec.spec

-module(timestamp).

-compile(export_all).

do_decode(<<"message_timestamp">>,
          <<"urn:xmpp:message:timestamp">>, El, Opts) ->
    decode_message_timestamp(<<"urn:xmpp:message:timestamp">>,
                             Opts,
                             El);
do_decode(Name, <<>>, _, _) ->
    erlang:error({xmpp_codec, {missing_tag_xmlns, Name}});
do_decode(Name, XMLNS, _, _) ->
    erlang:error({xmpp_codec, {unknown_tag, Name, XMLNS}}).

tags() ->
    [{<<"message_timestamp">>,
      <<"urn:xmpp:message:timestamp">>}].

do_encode({message_timestamp, _} = Message_timestamp,
          TopXMLNS) ->
    encode_message_timestamp(Message_timestamp, TopXMLNS).

do_get_name({message_timestamp, _}) ->
    <<"message_timestamp">>.

do_get_ns({message_timestamp, _}) ->
    <<"urn:xmpp:message:timestamp">>.

pp(message_timestamp, 1) -> [timestamp];
pp(_, _) -> no.

records() -> [{message_timestamp, 1}].

decode_message_timestamp(__TopXMLNS, __Opts,
                         {xmlel, <<"message_timestamp">>, _attrs, _els}) ->
    Timestamp = decode_message_timestamp_attrs(__TopXMLNS,
                                               _attrs,
                                               undefined),
    {message_timestamp, Timestamp}.

decode_message_timestamp_attrs(__TopXMLNS,
                               [{<<"timestamp">>, _val} | _attrs],
                               _Timestamp) ->
    decode_message_timestamp_attrs(__TopXMLNS,
                                   _attrs,
                                   _val);
decode_message_timestamp_attrs(__TopXMLNS, [_ | _attrs],
                               Timestamp) ->
    decode_message_timestamp_attrs(__TopXMLNS,
                                   _attrs,
                                   Timestamp);
decode_message_timestamp_attrs(__TopXMLNS, [],
                               Timestamp) ->
    decode_message_timestamp_attr_timestamp(__TopXMLNS,
                                            Timestamp).

encode_message_timestamp({message_timestamp, Timestamp},
                         __TopXMLNS) ->
    __NewTopXMLNS =
        xmpp_codec:choose_top_xmlns(<<"urn:xmpp:message:timestamp">>,
                                    [],
                                    __TopXMLNS),
    _els = [],
    _attrs =
        encode_message_timestamp_attr_timestamp(Timestamp,
                                                xmpp_codec:enc_xmlns_attrs(__NewTopXMLNS,
                                                                           __TopXMLNS)),
    {xmlel, <<"message_timestamp">>, _attrs, _els}.

decode_message_timestamp_attr_timestamp(__TopXMLNS,
                                        undefined) ->
    <<>>;
decode_message_timestamp_attr_timestamp(__TopXMLNS,
                                        _val) ->
    _val.

encode_message_timestamp_attr_timestamp(<<>>, _acc) ->
    _acc;
encode_message_timestamp_attr_timestamp(_val, _acc) ->
    [{<<"timestamp">>, _val} | _acc].
