Class {
	#name : 'TypeMeTest',
	#superclass : 'TestCase',
	#instVars : [
		'typer',
		'testEnvironment',
		'testConfiguration',
		'testConfigurationCollection'
	],
	#category : 'TypeMe-Tests',
	#package : 'TypeMe-Tests'
}

{ #category : 'tests' }
TypeMeTest >> setUp [

	super setUp.

	testEnvironment := SystemEnvironment new.
	typer := TypeMe new setEnvironment: testEnvironment.
]

{ #category : 'tests' }
TypeMeTest >> tearDown [ 

	TypeMeTestHelper cleanTestConfigurations
]

{ #category : 'tests' }
TypeMeTest >> testMethodsReturnBoolean [

	| result |
	
	TypeMeTestHelper
		installTestMethods: (OrderedCollection newFrom:
				 { 'hasName ^ true'. 'isUsed ^nil'. 'includes ^nil'.
				 '= other ^nil' })
		onTestClass: (TypeMeTestHelper
				 createTestClass: #TypeMeReturnBoolean
				 package: 'TypeMe-TestPackage-ReturnBoolean'
				 instVariables: {  }
				 onEnvironment: testEnvironment).


	typer extractTypesForPackage: 'TypeMe-TestPackage-ReturnBoolean'.
	result := typer methodsReturnBoolean.

	self assert: result size equals: 4.
	self assert:
		((result collect: [ :a | a third ]) allSatisfy: [ :methodName |
			 { 'hasName'. 'isUsed'. 'includes'. '=' } includes: methodName ]).
	self assert: (result collect: [ :a | a fourth ]) asSet size equals: 1.
	self
		assert: (result collect: [ :a | a fourth ]) asSet atRandom
		equals: 'Boolean'.

	TypeMeTestHelper cleanTestEnvironment: testEnvironment
]

{ #category : 'tests' }
TypeMeTest >> testMethodsReturnClass [

	| result |
	
	TypeMeTestHelper
		installTestMethods: (OrderedCollection newFrom:
				 { 'returnClass ^ TypeMeReturnClass'. 'returnNil  ^ nil'})
		onTestClass: (TypeMeTestHelper
				 createTestClass: #TypeMeReturnClass
				 package: 'TypeMe-TestPackage-ReturnClass'
				 instVariables: {  }
				 onEnvironment: testEnvironment).


	typer extractTypesForPackage: 'TypeMe-TestPackage-ReturnClass'.
	result := typer methodsReturnClass.

	self assert: result size equals: 1.
	self
		assert: (result collect: [ :a | a third ]) first
		equals: 'returnClass'.
	self
		assert: (result collect: [ :a | a fourth ]) first
		equals: 'TypeMeReturnClass class'.

	TypeMeTestHelper cleanTestEnvironment: testEnvironment
]

{ #category : 'tests' }
TypeMeTest >> testMethodsReturnClassNew [

	| result |
	TypeMeTestHelper
		installTestMethods: (OrderedCollection newFrom:
				 { 'returnClassNew ^ TypeMeReturnClassNew new'. 'returnClass ^ TypeMeReturnClassNew'.
				 'returnNil ^nil' })
		onTestClass: (TypeMeTestHelper
				 createTestClass: #TypeMeReturnClassNew
				 package: 'TypeMe-TestPackage-ReturnClassNew'
				 instVariables: {  }
				 onEnvironment: testEnvironment).

	typer extractTypesForPackage: 'TypeMe-TestPackage-ReturnClassNew'.
	result := typer methodsReturnClassNew.

	self assert: result size equals: 1.
	self
		assert: (result collect: [ :a | a third ]) first
		equals: 'returnClassNew'.
	self
		assert: (result collect: [ :a | a fourth ]) first
		equals: 'TypeMeReturnClassNew'.

	TypeMeTestHelper cleanTestEnvironment: testEnvironment
]

{ #category : 'tests' }
TypeMeTest >> testMethodsReturnLiteralNode [

	| result |
	TypeMeTestHelper
		installTestMethods: (OrderedCollection newFrom:
				 { 'returnNumber ^5'. 'returnString ^ ''BFS'''.
				 'returnBoolean ^ true'. 'returnNil ^ nil' . 'returnNotLiteral ^ a'})
		onTestClass: (TypeMeTestHelper
				 createTestClass: #TypeMeReturnLiteral
				 package: 'TypeMe-TestPackage-ReturnLiteral'
				 instVariables: { 'a' }
				 onEnvironment: testEnvironment).

	typer extractTypesForPackage: 'TypeMe-TestPackage-ReturnLiteral'.
	result := typer methodsReturnLiteralNode.

	self assert: result size equals: 4.
	self assert:
		((result collect: [ :a | a third ]) allSatisfy: [ :methodName |
			 { 'returnNumber'. 'returnString'. 'returnBoolean' . 'returnNil' } includes:
				 methodName ]).
	self
		assert: ((result collect: [ :a | a fourth ]) allSatisfy: [ :type |
			 { 'SmallInteger'. 'UndefinedObject'. 'ByteString' . 'True' } includes:
				 type ]).


	TypeMeTestHelper cleanTestEnvironment: testEnvironment
]

{ #category : 'tests' }
TypeMeTest >> testMethodsReturnNil [

	| result |

	TypeMeTestHelper
		installTestMethods:
			(OrderedCollection newFrom: { 'returnOneNil self yourself. ^ nil'.
				 'returnTwothings self ifNil: [^ nil] ifNotNil: [^nil]'.
				 'noExplicitReturn self yourself' })
		onTestClass: (TypeMeTestHelper
				 createTestClass: #TypeMeReturnOneNil
				 package: 'TypeMe-TestPackage-ReturnOneNil'
				 instVariables: {  }
				 onEnvironment: testEnvironment).

	typer extractTypesForPackage: 'TypeMe-TestPackage-ReturnOneNil'.
	result := typer methodsReturnNil.

	self assert: result size equals: 1.
	self
		assert: (result collect: [ :a | a third ]) first
		equals: 'returnOneNil'.
	self assert: (result collect: [ :a | a fourth ]) first equals: nil.

	TypeMeTestHelper cleanTestEnvironment: testEnvironment
]

{ #category : 'tests' }
TypeMeTest >> testMethodsReturnNumber [

	| result |
	
	TypeMeTestHelper
		installTestMethods: (OrderedCollection newFrom:
				 { 'size ^5'. 'priority ^100'. 'returnNotNumber ^nil' })
		onTestClass: (TypeMeTestHelper
				 createTestClass: #TypeMeReturnNumber
				 package: 'TypeMe-TestPackage-ReturnNumber'
				 instVariables: {  }
				 onEnvironment: testEnvironment).

	typer extractTypesForPackage: 'TypeMe-TestPackage-ReturnNumber'.
	result := typer methodsReturnNumber.

	self assert: result size equals: 2.
	self assert:
		((result collect: [ :a | a third ]) allSatisfy: [ :methodName |
			 { 'size'. 'priority' } includes: methodName ]).

	self assert: (result collect: [ :a | a fourth ]) asSet size equals: 1.
	self
		assert: (result collect: [ :a | a fourth ]) asSet atRandom
		equals: 'Number'.

	TypeMeTestHelper cleanTestEnvironment: testEnvironment
]

{ #category : 'tests' }
TypeMeTest >> testMethodsReturnSelf [

	| result |
	
	TypeMeTestHelper
		installTestMethods:
			(OrderedCollection newFrom:
				 { 'returnOneSelf self yourself. ^ self'.
				 'returnTwoSelf true ifTrue: [^ self] ifFalse: [^self]'.
				 'returnNotSelf self yourself. ^ nil' })
		onTestClass: (TypeMeTestHelper
				 createTestClass: #TypeMeReturnSelf
				 package: 'TypeMe-TestPackage-ReturnSelf'
				 instVariables: {  }
				 onEnvironment: testEnvironment).

	typer extractTypesForPackage: 'TypeMe-TestPackage-ReturnSelf'.
	result := typer methodsReturnSelf.

	self assert: result size equals: 1.
	self
		assert: (result collect: [ :a | a third ]) first
		equals: 'returnOneSelf'.
	self
		assert: (result collect: [ :a | a fourth ]) first
		equals: 'TypeMeReturnSelf'.

	TypeMeTestHelper cleanTestEnvironment: testEnvironment
]

{ #category : 'tests' }
TypeMeTest >> testMethodsReturnSelfNew [

	| result |
	TypeMeTestHelper
		installTestMethods: (OrderedCollection newFrom:
				 { 'returnOneSelf self yourself. ^ self new'.
				 'returnTwoSelf true ifTrue: [^ self] ifFalse: [^self]'.
				 'returnNotSelf self yourself. ^ nil' })
		onTestClass: (TypeMeTestHelper
				 createTestClass: #TypeMeReturnSelf
				 package: 'TypeMe-TestPackage-ReturnSelf'
				 instVariables: {  }
				 onEnvironment: testEnvironment).

	typer extractTypesForPackage: 'TypeMe-TestPackage-ReturnSelf'.
	result := typer methodsReturnSelfNew.

	self assert: result size equals: 1.
	self
		assert: (result collect: [ :a | a third ]) first
		equals: 'returnOneSelf'.
	self
		assert: (result collect: [ :a | a fourth ]) first
		equals: 'TypeMeReturnSelf'.

	TypeMeTestHelper cleanTestEnvironment: testEnvironment
]

{ #category : 'tests' }
TypeMeTest >> testMethodsReturnString [

	| result |
	
	TypeMeTestHelper
		installTestMethods: (OrderedCollection newFrom:
				 { 'asString ^nil'. 'withString ^nil'. 'includeString ^nil' })
		onTestClass: (TypeMeTestHelper
				 createTestClass: #TypeMeReturnString
				 package: 'TypeMe-TestPackage-ReturnString'
				 instVariables: {  }
				 onEnvironment: testEnvironment).

	typer extractTypesForPackage: 'TypeMe-TestPackage-ReturnString'.
	result := typer methodsReturnString.

	self assert: result size equals: 3.
	self assert:
		((result collect: [ :a | a third ]) allSatisfy: [ :methodName |
			 { 'asString'. 'withString'. 'includeString'. '=' } includes:
				 methodName ]).

	self assert: (result collect: [ :a | a fourth ]) asSet size equals: 1.
	self
		assert: (result collect: [ :a | a fourth ]) asSet atRandom
		equals: 'String'.

	TypeMeTestHelper cleanTestEnvironment: testEnvironment
]

{ #category : 'tests' }
TypeMeTest >> testMethodsWithNoReturnStatement [

	| result |
	
	TypeMeTestHelper
		installTestMethods: (OrderedCollection newFrom:
				 { 'initialize self new'. 'setUp self yourself' })
		onTestClass: (TypeMeTestHelper
				 createTestClass: #TypeMeNoReturnStatement
				 package: 'TypeMe-TestPackage-NoReturnStatement'
				 instVariables: {  }
				 onEnvironment: testEnvironment).

	typer extractTypesForPackage: 'TypeMe-TestPackage-NoReturnStatement'.
	result := typer methodsWithNoReturnStatement.

	self assert: result size equals: 2.
	self assert:
		((result collect: [ :a | a third ]) allSatisfy: [ :methodName |
			 { 'initialize'. 'setUp'. '=' } includes:
				 methodName ]).
	self
		assert: (result collect: [ :a | a fourth ]) first
		equals: 'TypeMeNoReturnStatement'.

	TypeMeTestHelper cleanTestEnvironment: testEnvironment
]
