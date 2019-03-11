These two tests should fail because from RFC7951:
" A namespace-qualified member name MUST be used for all members of a
  top-level JSON object and then also whenever the namespaces of the
  data node and its parent node are different.  In all other cases, the
  simple form of the member name MUST be used. "
