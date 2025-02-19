Class {
	#name : 'ASTHelper',
	#superclass : 'Object',
	#category : 'TypeMe',
	#package : 'TypeMe'
}

{ #category : 'accessing' }
ASTHelper class >> getClassFromReturnNew: aReturn [
	"assuming that necessary checks of ifReturnReturnsClassNew has been made"

	^ aReturn value variable name
]

{ #category : 'accessing' }
ASTHelper class >> getClassNameFromReturnNew: aReturn [
	"assuming that necessary checks of ifReturnReturnsClassNew has been made"

	^ aReturn value receiver variable name
]

{ #category : 'accessing' }
ASTHelper class >> getReturnLiteralNode: aReturn [

	^ aReturn value value
]

{ #category : 'accessing' }
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

	| res  |
	
	res := methodAST allStatements select: [ :st | st isReturn ].
	res size = 1 ifTrue: [ ^ self isNilValue: res first value ].

	^ false
]

{ #category : 'accessing' }
ASTHelper class >> ifReturnReturnsClass: aReturn [

	| value |
	value := aReturn value.
	value class = OCVariableNode ifFalse: [ ^ false ].
	value variable class = GlobalVariable ifFalse: [ ^ false ].
	^ value variable isGlobalClassNameBinding
]

{ #category : 'accessing' }
ASTHelper class >> ifReturnReturnsClassNew: aReturn [

	| value |
	value := aReturn value.
	value class = OCMessageNode ifFalse: [ ^ false ].
	value receiver class = OCVariableNode ifFalse: [ ^ false ].
	value selector = 'new' ifFalse: [ ^ false ].
	value receiver variable class = GlobalVariable ifFalse: [ ^ false ].
	^ value receiver variable isGlobalClassNameBinding
]

{ #category : 'accessing' }
ASTHelper class >> ifReturnReturnsLiteralNode: aReturn [

	^ aReturn value class = OCLiteralValueNode
]

{ #category : 'accessing' }
ASTHelper class >> ifReturnReturnsSelfNew: aReturn [

	| value |
	value := aReturn value.
	value class = OCMessageNode ifFalse: [ ^ false ].
	value receiver class = OCVariableNode ifFalse: [ ^ false ].
	value selector = 'new' ifFalse: [ ^ false ].
	^ value receiver variable class = SelfVariable
]

{ #category : 'testing' }
ASTHelper class >> isLiteralNode: astNode [

	^ astNode class = OCLiteralValueNode
]

{ #category : 'testing' }
ASTHelper class >> isNilValue: aReturnValue [

	^ aReturnValue class = OCLiteralValueNode and:
		  aReturnValue value isNil
]
