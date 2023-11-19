hdv_erl
=====

An escript

Following [1], this script uses Erlang's big integers to implement "Hyper Dimensional" bit vectors and answers the question "What's the Dollor of Mexico?" by searching for the nearest word to the product:
```
MEXICO*USA*USD
``` 

References:
[1] "What We Mean When We Say 'What’s the Dollar of Mexico?': Prototypes and Mapping in Concept Space" by Pentti Kanerva, Quantum Informatics for Cognitive, Social, and Semantic Processes: Papers from the AAAI Fall Symposium (FS-10-08)

Build
-----

    $ rebar3 escriptize

Run
---

    $ _build/default/bin/hdv_erl
