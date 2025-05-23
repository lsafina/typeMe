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
ASTHelper class >> getReturns: aMethodNode [
	"assuming that necessary checks of ifReturnReturnsClassNew has been made"

	| returns |
	returns := aMethodNode allStatements select: [ :st | st isReturn ].
	aMethodNode lastIsReturn ifTrue: [ ^ returns ].
	^ returns , { ((OCReturnNode value: (OCVariableNode selfNode
				     variable: SelfVariable new;
				     yourself))
		   parent: aMethodNode body;
		   yourself) }
]

{ #category : 'accessing' }
ASTHelper class >> getSingleReturn: aMethod [
	"assuming that necessary checks of ifReturnReturnsClassNew has been made"

	^ (aMethod ast allStatements select: [ :st | st isReturn ]) first
]

{ #category : 'accessing' }
ASTHelper class >> ifAllReturnsOf: aMethodNode satisfy: conditionBlock do: actionBlock [

	| returns matchingReturn |
	returns := self getReturns: aMethodNode.

	matchingReturn := returns detect: conditionBlock ifNone: [ ^ self ].
	returns do: [ :eachReturn |
			((conditionBlock value: eachReturn) or: [
				 self isNilValue: eachReturn value ]) ifTrue: [
				^ actionBlock value: matchingReturn ] ]
]

{ #category : 'testing' }
ASTHelper class >> ifMethodHasReturnStatements: methodAST [

	^ (methodAST allStatements select: [ :st | st isReturn ]) isNotEmpty
]

{ #category : 'testing' }
ASTHelper class >> ifMethodReturnOnlyNil: aMethodNode [

	^ (self getReturns: aMethodNode) allSatisfy: [ :each |
		  self isNilValue: each value ]
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

	^ aReturn value isLiteralNode and: [ aReturn value value isNotNil ]
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
