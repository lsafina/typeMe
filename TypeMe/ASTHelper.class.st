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

	| res |
	
	res := methodAST allStatements select: [ :st | st isReturn ].
	res size = 1 ifTrue: [ ^ self isNilValue: res first value ].

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
