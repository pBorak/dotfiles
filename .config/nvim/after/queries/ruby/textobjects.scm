; extends
((call
   method: (identifier) @func_name (#match? @func_name "^context$")
   )) @rspec.context

((call
   method: (identifier) @func_name (#match? @func_name "^it$")
   )) @rspec.it
