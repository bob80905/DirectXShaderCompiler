// RUN: %dxc -Tlib_6_5 -verify %s 
// This file tests several things at once:
// Firstly, recursive functions with external linkage should be tested
// and diagnosed for recursion. So, exported_recurse should throw an error
// since it is recursive. 
// Secondly, functions with external linkage may not call recursive 
// functions with internal linkage. exported_recurse_2 calls 
// unexported_recurse, so we expect an error.
// Thirdly, unreachable functions with internal linkage should not 
// be tested for recursion in library shaders. 
// In this case, unreachable_unexported_recurse is an example, and we 
// do not expect any compilation errors for that function.
// Finally, functions with unspecified linkage will default to external
// for library shaders, so we expect errors on unreachable functions
// that are recursive

// expected-error@+1{{recursive functions are not allowed: entry function calls recursive function 'unreachable_unexported_recurse_external'}}
void unreachable_unexported_recurse_external(inout float4 f, float a) 
{
    if (a > 1)
      unreachable_unexported_recurse_external(f, a-1);
    f = abs(f+a);
}

static void unreachable_unexported_recurse(inout float4 f, float a) 
{
    if (a > 1)
      unreachable_unexported_recurse(f, a-1);
    f = abs(f+a);
}

// expected-error@+1{{recursive functions are not allowed: entry function calls recursive function 'unexported_recurse'}}
static void unexported_recurse(inout float4 f, float a) 
{
    if (a > 1)
      unexported_recurse(f, a-1);
    f = abs(f+a);
}

// expected-error@+1{{recursive functions are not allowed: entry function calls recursive function 'exported_recurse'}}
export void exported_recurse(inout float4 f, float a) 
{
    if (a > 1)
      exported_recurse(f, a-1);
    f = abs(f+a);
}

export void exported_recurse_2(inout float4 f, float a) 
{
    if (a > 1)
      unexported_recurse(f, a-1);
    f = abs(f+a);
}

float4 main(float a : A, float b:B) : SV_TARGET
{
  float4 f = b;
  return f;
}
