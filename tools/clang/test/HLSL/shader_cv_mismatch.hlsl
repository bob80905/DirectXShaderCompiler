// RUN: %clang_cc1 -fsyntax-only -ffreestanding -verify %s


[shader("compute")]/* expected-note {{conflicting attribute is here}} */
[shader("vertex")] /* expected-error {{invalid shader stage attribute combination}} */ /* expected-note {{conflicting attribute is here}} */
[ numthreads( 64, 2, 2 ) ] 

void CVMain() {
}
