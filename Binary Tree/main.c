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
extern void removeNode(struct Tree*, int);
extern void deleteTree(struct Tree*);

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
	if(find(myTree, 0)){
		printf("%s\n","found" );
	}else{
		printf("%s\n", "NOT found");
	}

	print(myTree);
	// removeNode(myTree,8);
	// removeNode(myTree,2);
	removeNode(myTree,3);
	removeNode(myTree,9);
	// removeNode(myTree,5);	//This is the root and cannot be deleted so far

	print(myTree);
	deleteTree(myTree);
	// free(myTree);
	print(myTree);

	return 0;
}
