;Binary tree structure
section .data
struc Tree
	.root resq 1
endstruc

struc Node
	.value resd 1
	align 8
	.left resq 1
	.right resq 1
endstruc

section .text
extern malloc, printf, free
global asm_Tree, insert, find, deleteTree, print, removeNode

asm_Tree:
	push rbp
	mov rbp,rsp

	mov rdi, Tree_size
	call malloc
	mov r8,0
	mov [rax + Tree.root], r8

	leave
	ret

;Node* find(Tree, int )
find:
	push rbp
	mov rbp,rsp

	mov r8, [rdi + Tree.root]	;get root
.more:
	xor rax, rax
	cmp r8, 0						;if root is null then done.
	je .done
	mov r9,  [r8 + Node.value]
	cmp r9, rsi						;cmp node value with param
	jg .left
	jl .right
	mov rax, r8						;Node with value to find is found
	jmp .done

.left:
	mov r8,[r8 + Node.left]
	jmp .more

.right:
	mov r8, [r8 + Node.right]
	jmp .more

.done:
	leave
	ret

;Node* insert(Tree, int )
insert:
	push rbp
	mov rbp,rsp
	sub rsp, 16
.t equ 0
.n equ 8
	mov [rsp + .t], rdi
	mov [rsp + .n], rsi

	call find
	cmp rax, 0
	jne .done

	mov rdi, Node_size
	call malloc
	mov r8,[rsp + .n]
	mov [rax + Node.value], r8
	xor r8, r8
	mov [rax + Node.left], r8
	mov [rax + Node.right], r8

;GetParent
	mov r8, [rsp + .t]						;get Tree
	mov r9, [r8 + Tree.root]			;get root
	cmp r9,0									;if root is null
	jne .GetParent								;else get parent
	mov [r8+ Tree.root], rax			;root = newNode
	jmp .done

.GetParent:
	cmp r9,0
	je .found
	mov rcx, [r9 + Node.value]
	cmp rcx, [rsp + .n]
	jg .left
	mov r8,r9						;r8 is prev. prev = node.
	mov r9, [r8 + Node.right]
	jmp .GetParent

.left:
	mov r8,r9
	mov r9,[r8+ Node.left]
	jmp .GetParent

.found:
	cmp rcx, [rsp+ .n]
	jg .addleft
	mov [r8 +Node.right], rax
	jmp .done
.addleft:
	mov [r8 + Node.left], rax

.done:
	leave
	ret

;void removeNode(Tree*,int)
;I use the delete by merging strategy. Nodes are added to the right child's
;leftmost node.
removeNode:
	push rbp
	mov rbp,rsp
	sub rsp, 16
.t equ 0
.n equ 8
	mov [rsp + .t], rdi
	mov [rsp + .n], rsi
	mov rdi, [rdi + Tree.root]
	xor rax, rax			;xor incase tree was Empty. Return 0
	cmp rdi, 0
	je .done					;if tree is empty return
	mov rdi, [rsp + .t]
	call find				;try to find int
	cmp rax, 0
	je .done					;if not found then return. Return 0

	mov r10, [rsp + .t]
	mov r10, [r10 + Tree.root]
	mov r8, [rsp + .n]
.while:						;find node that contains int and its parent
	cmp r8, [r10 + Node.value]
	jl .left
	jg .right
	jmp .end_while

.left:
	mov r9,r10				;r9 is parent of target node
	mov r10, [r9 + Node.left]
	jmp .while
.right:
	mov r9,r10
	mov r10, [r9 + Node.right]
	jmp .while
.end_while:
	
;At this point r10 is the target node and r9 is its parent.
	mov rdi,[r10 + Node.right]
	cmp rdi,0							;if target has right
	jne .hassRight
	mov r11, [r10 + Node.left]		;r11 = target.left

	cmp r10, [r9 + Node.left]		;if target is parent's left
	jne .parentsRight
	mov [r9 + Node.left], r11
	jmp .done
.parentsRight:
	mov [r9 + Node.right], r11		;parent.right = target.left
	jmp .done

;At this point we are done if target has no right children.

.hassRight:
	cmp r10, [r9 + Node.left]		;if target is parent's left
	jne .changeParentsRight
	mov [r9 + Node.left], rdi		;parent.left = target.right
	jmp .connectChildren
.changeParentsRight:
	mov [r9 + Node.right], rdi		;parent.right = target.right

.connectChildren:
	call findLeftmostNode			;findLeftmostNode only change r11, rax
	mov r11, [r10+ Node.left]
	mov [rax + Node.left], r11

;free the node you want to delete
	xor r8,r8
	mov [r10 + Node.left], r8
	mov [r10 + Node.right], r8
	mov rdi, r10
	call free
	mov rax, [rsp + .t]
.done:
	leave
	ret

;Returns leftmost child of the passed Node.
findLeftmostNode:
	mov r11, [rdi + Node.left]
	mov rax, rdi						;if node has no left then return node
.while:
	cmp r11, 0
	je .done
	mov rax, r11
	mov r11, [r11 + Node.left]
	jmp .while
.done
	ret

section.data
fmt: db "%d ",0
nln: db 0xa,0
Empty: db "EMPTY",0xa,0
section .text

; void print(Tree)
print:
	push rbp
	mov rbp,rsp
	.t equ 0
	sub rsp, 16
	mov [rsp + .t], rdi

	mov rdi, [rdi+ Tree.root]
	cmp rdi, 0
	jne .a
	mov rdi, Empty
	call printf
	jmp .done
.a:
	call rec_print
	mov rdi, nln
	call printf
.done:
	leave
	ret

;void rec_print(Node*)
rec_print:
	push rbp
	mov rbp, rsp
	sub rsp,16
	mov [rsp], rdi
	cmp rdi,0
	je .done				;if(node == 0) return

	mov rdi, [rdi+ Node.left]
	call rec_print
	mov rdi, [rsp]
	mov rsi, [rdi + Node.value]
	mov rdi, fmt
	call printf
	mov rdi, [rsp]
	mov rdi, [rdi+ Node.right]
	call rec_print

.done:
	leave
	ret

;void deleteTree(Tree*)
deleteTree:
	push rbp
	mov rbp,rsp
	cmp rdi, 0
	je .done

	sub rsp, 16
	mov [rsp], rdi

	mov rdi, [rdi + Tree.root]
	call rec_del
	xor rax,rax
	mov rdi, [rsp]
	mov [rdi + Tree.root], rax
.done:
	leave
	ret

rec_del:
	push rbp
	mov rbp, rsp
	cmp rdi, 0
	je .done
	sub rsp, 16
	mov [rsp], rdi

	mov rdi,[rdi + Node.left]
	call rec_del
	mov rdi,[rsp]
	mov rdi, [rdi+ Node.right]
	call rec_del
	mov rdi, [rsp]
	mov r8,0
	mov [rdi + Node.left],r8
	mov [rdi + Node.right], r8
	call free

.done
	leave
	ret
