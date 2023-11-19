-module(hdv).
-export([random_vector/0, permute/1, add/1, hamming_distance/2]).
-compile(export_all).

-attribute([nbits/0]).

example() ->
    NAME = random_vector(),
    CAPITAL = random_vector(),
    CURRENCY = random_vector(),

    SWE = random_vector(),
    USA = random_vector(),
    MEX = random_vector(),

    STOCKHOLM = random_vector(),
    WDC = random_vector(),
    CDMX= random_vector(),

    USD = random_vector(),
    MPE = random_vector(),
    SKR = random_vector(),

    WORDS=[{swe,SWE}, {usa,USA}, {mex,MEX}, {stockholm,STOCKHOLM},
           {wdc,WDC}, {cdmx,CDMX}, {usd,USD}, {mpe,MPE}, {skr,SKR}],

    USTATES= add([multiply(NAME,USA),
                  multiply(CAPITAL,WDC),
                  multiply(CURRENCY,USD)]),

    SWEDEN = add([multiply(NAME,SWE),
                  multiply(CAPITAL,STOCKHOLM),
                  multiply(CURRENCY,SKR)]),

    MEXICO= add([multiply(NAME,MEX),
                  multiply(CAPITAL,CDMX),
                  multiply(CURRENCY,MPE)]),

    FMU = multiply(MEXICO,USTATES),
    X = multiply(FMU,USD),
    erlang:display("MEXICO*USTATES*USD"),
    distances(X,WORDS),
    ok.

distances(V, []) -> ok;
distances(V, [H|T]) ->
    {WORD,X} = H,
    D=hamming_distance(V,X),
    erlang:display({WORD,D}),
    distances(V,T).

nbits() ->
    100000.

random_vector() ->
    H = 1 bsl nbits() - 1,
    RandomNumber = rand:uniform(H), % [0;H[
    %io:format("Random number with ~B bits: ~.2B~n", [nbits(), RandomNumber]),
    RandomNumber.

permute(X) ->
    Mask = 1 bsl nbits() - 1,
    ((X bsl 1) band Mask) bor (X bsr (nbits()-1)).

multiply(A,B) ->
    A bxor B.

add(Integers) when is_list(Integers) ->
    % for each bit position, combine by calculating majority value
    BitsList = lists:map(fun(Integer) -> integer_to_bits(Integer) end, Integers),
    %erlang:display(BitsList),

    CountsList = transpose(BitsList),
    %erlang:display(CountsList),
    MajorityValues = lists:map(fun(Counts) -> determine_majority(Counts) end, CountsList),

    SignOperator = binary_to_decimal(MajorityValues),
    %io:format("Combined sign operator: ~B~n", [SignOperator]),
    SignOperator.

transpose([[]|_]) -> [];
transpose(M) ->
  [lists:map(fun hd/1, M) | transpose(lists:map(fun tl/1, M))].

binary_to_decimal(BinaryDigits) when is_list(BinaryDigits) ->
    binary_to_decimal(BinaryDigits, 0).
binary_to_decimal([], Acc) ->
    Acc;
binary_to_decimal([Digit | Rest], Acc) ->
    binary_to_decimal(Rest, Acc * 2 + Digit).

% Helper function to convert an integer to a list of bits
integer_to_bits(Integer) when is_integer(Integer) ->
    lists:reverse([(Integer bsr N) band 1 || N <- lists:seq(0, nbits()-1)]).

count1([]) -> 0;
count1([1 | T]) ->
    1+count1(T);
count1([0 | T]) ->
    count1(T).

% Helper function to determine the majority value at a position
determine_majority(Counts) ->
    N=count1(Counts),
    if 
        N>length(Counts)/2 -> 1;
        true -> 0
    end.

hamming_distance(BitVector1, BitVector2) when is_integer(BitVector1), is_integer(BitVector2) ->
    XORResult = BitVector1 bxor BitVector2,
    hamming_weight(XORResult).

hamming_weight(0) -> 0;
hamming_weight(N) when N band 1 =:= 1 -> 1 + hamming_weight(N bsr 1);
hamming_weight(N) -> hamming_weight(N bsr 1).
