The toolchain
=============

Let's assume you have inserted in your RFC a well-formed JSON-encoded
RESTCONF document (shortly the JSON document).  
You want the document to be self-descriptive so it has been annotated
with the relevant YANG models using pseudo-comments.  
Pseudo-comments are valid JSON elements where the key starts with '//'.
This is a convention and may change without invalidating the method.  
Finally your JSON is folded to fit the canonical RFC width.  
How can you be sure that your JSON document represent a valid instance
of the cited models ?

The method
----------

In our view a useful toolchain performs these steps:

  1 *extract* the JSON document from RFC
  2 *unfold* the JSON document
  3 *download* the models referenced in the pseudo-comments
  4 *strip* the pseudo-comments
  5 *validate* the stripped document against the models according to a strategy

In the opposite direction, starting from a valid RESTCONF document:
  6 *annotate* the JSON document with the relevant models using pseudo-comments
  7 *fold* the document

Steps 1 is currently done by a tool like `rfcstrip` that can be found at
https://github.com/mbj4668/rfcstrip

For steps 2 and 7 you can use the approach proposed in
https://tools.ietf.org/html/draft-ietf-netmod-artwork-folding-10

Step 6 is done manually by the RFC authors.

This toolchain currently comprises steps 3, 4 and 5.  
The validation strategy, described in `validation.md` can be based on `pyang`
or `yanglint` libraries that can be found respectively 
at https://github.com/mbj4668/pyang and https://github.com/CESNET/libyang.

Some details
------------

This table describes the text as it pass through the toolchain:

|    Step           |  is valid JSON  | is valid RESTCONF instance    |
| ----------------- | --------------- | ----------------------------- |
| extract           | no: just text within the RFC width | see left   |
| unfold & download | yes             | no because of pseudo-comments |
| strip & validate  | yes             | yes                           |
