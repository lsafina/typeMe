Class {
	#name : 'ASTHelper',
	#superclass : 'Object',
	#category : 'TypeMe',
	#package : 'TypeMe'
}

{ #category : 'as yet unclassified' }
ASTHelper class >> getClassFromReturnNew: aReturn [
	"assuming that necessary checks of ifReturnReturnsClassNew has been made"

	^ aReturn value variable name
]

{ #category : 'as yet unclassified' }
ASTHelper class >> getClassNameFromReturnNew: aReturn [
	"assuming that necessary checks of ifReturnReturnsClassNew has been made"

	^ aReturn value receiver variable name
]

{ #category : 'as yet unclassified' }
ASTHelper class >> getReturnLiteralNode: aReturn [

	^ aReturn value value
]

{ #category : 'as yet unclassified' }
ASTHelper class >> getSingleReturn: aMethod [
	"assuming that necessary checks of ifReturnReturnsClassNew has been made"

	^ (aMethod ast allStatements select: [ :st | st isReturn ]) first
]

{ #category : 'testing' }
ASTHelper class >> ifMethodHasOneReturnStatement: methodAST [

 ^ (methodAST allStatements select: [ :st | st isReturn ]) size = 1
	
]

{ #category : 'testing' }
ASTHelper class >> ifMethodHasReturnStatements: methodAST [

	^ (methodAST allStatements select: [ :st | st isReturn ]) isNotEmpty
]

{ #category : 'testing' }
ASTHelper class >> ifMethodReturnOnlyNil: methodAST [

	| res anASTHelper |
	anASTHelper := self new.
	res := methodAST allStatements select: [ :st | st isReturn ].
	res size = 1 ifTrue: [ ^ anASTHelper isNilValue: res first value ].

	^ false
]

{ #category : 'as yet unclassified' }
ASTHelper class >> ifReturnReturnsClass: aReturn [

	| value |
	value := aReturn value.
	value class = RBVariableNode ifFalse: [ ^ false ].	
	value variable class = GlobalVariable ifFalse: [ ^ false ].
	^ value variable isGlobalClassNameBinding
]

{ #category : 'as yet unclassified' }
ASTHelper class >> ifReturnReturnsClassNew: aReturn [

	| value |

	value := aReturn value.
	value class = RBMessageNode ifFalse: [ ^ false ].
	value receiver class = RBVariableNode ifFalse: [ ^ false ].
	value selector = 'new' ifFalse: [ ^ false ].
	value receiver variable class = GlobalVariable ifFalse: [ ^ false ].
	^ value receiver variable isGlobalClassNameBinding
]

{ #category : 'as yet unclassified' }
ASTHelper class >> ifReturnReturnsLiteralNode: aReturn [

	^ aReturn value class = RBLiteralValueNode
	 
]

{ #category : 'as yet unclassified' }
ASTHelper class >> ifReturnReturnsSelfNew: aReturn [

	| value |
	value := aReturn value.
	value class = RBMessageNode ifFalse: [ ^ false ].
	value receiver class = RBVariableNode ifFalse: [ ^ false ].
	value selector = 'new' ifFalse: [ ^ false ].
	^ value receiver variable class = SelfVariable
	
]

{ #category : 'testing' }
ASTHelper class >> isLiteralNode: astNode [

	^ astNode class = RBLiteralValueNode
]

{ #category : 'testing' }
ASTHelper class >> isNilValue: aReturnValue [

	^ aReturnValue class = RBLiteralValueNode and:
		  aReturnValue value isNil 
]

{ #category : 'as yet unclassified' }
ASTHelper >> getClassFromReturnNew: aReturn [ 
	^ self class getClassFromReturnNew: aReturn 
]

{ #category : 'as yet unclassified' }
ASTHelper >> getClassNameFromReturnNew: aReturn [ 
	^ self class getClassNameFromReturnNew: aReturn 
]

{ #category : 'as yet unclassified' }
ASTHelper >> getReturnLiteralNode: aReturn [ 
	^ self class getReturnLiteralNode: aReturn 
]

{ #category : 'as yet unclassified' }
ASTHelper >> getSingleReturn: aMethod [ 
	^ self class getSingleReturn: aMethod 
]

{ #category : 'testing' }
ASTHelper >> ifMethodHasOneReturnStatement: methodAST [ 
	^ self class ifMethodHasOneReturnStatement: methodAST 
]

{ #category : 'testing' }
ASTHelper >> ifMethodHasReturnStatements: methodAST [ 
	^ self class ifMethodHasReturnStatements: methodAST 
]

{ #category : 'testing' }
ASTHelper >> ifMethodReturnOnlyNil: methodAST [ 
	^ self class ifMethodReturnOnlyNil: methodAST 
]

{ #category : 'as yet unclassified' }
ASTHelper >> ifReturnReturnsClass: aReturn [ 
	^ self class ifReturnReturnsClass: aReturn 
]

{ #category : 'as yet unclassified' }
ASTHelper >> ifReturnReturnsClassNew: aReturn [ 
	^ self class ifReturnReturnsClassNew: aReturn 
]

{ #category : 'as yet unclassified' }
ASTHelper >> ifReturnReturnsLiteralNode: aReturn [ 
	^ self class ifReturnReturnsLiteralNode: aReturn 
]

{ #category : 'as yet unclassified' }
ASTHelper >> ifReturnReturnsSelfNew: aReturn [ 
	^ self class ifReturnReturnsSelfNew: aReturn 
]

{ #category : 'testing' }
ASTHelper >> isLiteralNode: astNode [ 
	^ self class isLiteralNode: astNode 
]

{ #category : 'testing' }
ASTHelper >> isNilValue: aReturnValue [ 
	^ self class isNilValue: aReturnValue 
]
