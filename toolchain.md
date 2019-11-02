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

The toolchain performs these steps:

  1 *extract* the JSON document from RFC
  2 *unfold* the JSON document
  3 *download* the models referenced in the pseudo-comments
  4 *override* the downloaded models with other having local modifications
  5 *prepare* the target directory with used models and scripts
  6 *strip* the pseudo-comments from the document and put it in the target directory
  7 *validate* the stripped document against the models according to a strategy
  8 *clean* the target directory unless we want to keep it

In the opposite direction, starting from a valid RESTCONF document:
  9 *annotate* the JSON document with the relevant models using pseudo-comments
 10 *fold* the document

Steps 1 is currently done by a tool like `rfcstrip` that can be found at
https://github.com/mbj4668/rfcstrip

For steps 2 and 10 you can use the approach proposed in
https://tools.ietf.org/html/draft-ietf-netmod-artwork-folding-10

Step 9 is done manually by the RFC authors.

This toolchain currently comprises steps 3 to 8.  
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
