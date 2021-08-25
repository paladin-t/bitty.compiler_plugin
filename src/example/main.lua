require 'bf/compiler'               -- Require the compiler.

local f = compile('hello world.bf') -- Compile something.
f()                                 -- Run the compiled chunk.
