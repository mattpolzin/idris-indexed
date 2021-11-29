module Main

import Test.Golden

examples : IO TestPool
examples = testsInDir "examples" (const True) "Example code" [] Nothing
  
main : IO ()
main = runner [!examples]
