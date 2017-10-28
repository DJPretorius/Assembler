# Binary  Tree
This is a Binary search tree for 32-bit integers implemented in ASM using some C functions to allocate and free memory.

**Functions include**:
* Create empty tree with `Tree* asm_Tree()`
* Insert an integer whith `Node* insert(Tree*, int)`
* Find a node with looked for value with `Node* find(Tree*, int)`
* Delete a node from the tree with `void removeNode(Tree*, int)`
* Delete the whole tree with `void deleteTree(Tree*)`
