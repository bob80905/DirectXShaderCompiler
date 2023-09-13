// RUN: %clang_cc1 -fsyntax-only -verify %s
// ==================================================================
// zero-sized-node-record (expected error)
// An error diagnostic is generated for a zero sized record used in
// a node input/output record declaration.
// ==================================================================

struct EMPTY { // expected-note +{{zero sized record defined here}}
};

struct EMPTY2 { // expected-note +{{zero sized record defined here}}
  EMPTY empty;
};

struct EMPTY3 { // expected-note +{{zero sized record defined here}}
  EMPTY2 empty;
};

[Shader("node")]
[NodeLaunch("Broadcasting")]
[NumThreads(1,1,1)]
[NodeMaxDispatchGrid(64, 1, 1)]
void node01(DispatchNodeInputRecord<EMPTY> input) // expected-error {{record used in DispatchNodeInputRecord may not have zero size}}
{}

[Shader("node")]
[NodeLaunch("Broadcasting")]
[NumThreads(1,1,1)]
[NodeMaxDispatchGrid(64, 1, 1)]
void node02(RWDispatchNodeInputRecord<EMPTY> input) // expected-error {{record used in RWDispatchNodeInputRecord may not have zero size}}
{}

[Shader("node")]
[NodeLaunch("Coalescing")]
[NumThreads(1,1,1)]
void node03(GroupNodeInputRecords<EMPTY> input) // expected-error {{record used in GroupNodeInputRecords may not have zero size}}
{}

[Shader("node")]
[NodeLaunch("Coalescing")]
[NumThreads(1,1,1)]
void node04(RWGroupNodeInputRecords<EMPTY> input) // expected-error {{record used in RWGroupNodeInputRecords may not have zero size}}
{}

[Shader("node")]
[NodeLaunch("Thread")]
[NumThreads(1,1,1)]
void node05(ThreadNodeInputRecord<EMPTY> input) // expected-error {{record used in ThreadNodeInputRecord may not have zero size}}
{}

[Shader("node")]
[NodeLaunch("Thread")]
[NumThreads(1,1,1)]
void node06(RWThreadNodeInputRecord<EMPTY2> input) // expected-error {{record used in RWThreadNodeInputRecord may not have zero size}}
{}

[Shader("node")]
[NodeLaunch("Broadcasting")]
[NumThreads(1,1,1)]
[NodeMaxDispatchGrid(64, 1, 1)]
void node07(NodeOutput<EMPTY> output) // expected-error {{record used in NodeOutput may not have zero size}}
{}

[Shader("node")]
[NodeLaunch("Broadcasting")]
[NumThreads(1,1,1)]
[NodeMaxDispatchGrid(64, 1, 1)]
void node08(NodeOutputArray<EMPTY3> output) // expected-error {{record used in NodeOutputArray may not have zero size}}
{}
