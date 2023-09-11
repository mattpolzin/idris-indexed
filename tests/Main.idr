module Main

import Test.Golden

examples : IO TestPool
examples = testsInDir "examples" "Example code"
  
main : IO ()
main = runner [!examples]
