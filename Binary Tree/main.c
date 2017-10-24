#include <stdio.h>
#include <stdlib.h>

struct Tree{
	struct Node* root;
};

struct Node{
	int value;
	struct Node* left;
	struct Node* right;
};

extern struct Tree* asm_Tree();
extern struct Node* find(struct Tree*, int);
extern struct Node* insert(struct Tree*, int);
extern void print(struct Tree*);

int main(){
	struct Tree* myTree = asm_Tree();
	int numbers[] = {5,3,4,2,1,7,6,9,8,10};
	for(int c= 0; c< 10; c++){
		insert(myTree,numbers[c]);
	}
	if(find(myTree, 8)){
		printf("%s\n","found" );
	}else{
		printf("%s\n", "NOT found");
	}
	// printf("%d\n", myTree->root->value );
	// printf("%d\n", myTree->root->left->value );

	print(myTree);
	deleteTree(myTree);
	// free(myTree);
	print(myTree);

	return 0;
}
