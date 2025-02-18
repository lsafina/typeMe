Class {
	#name : 'TypeMeTest',
	#superclass : 'TestCase',
	#instVars : [
		'testConfiguration',
		'typer',
		'testConfigurationCollection'
	],
	#category : 'TypeMe-Tests',
	#package : 'TypeMe-Tests'
}

{ #category : 'tests' }
TypeMeTest >> setUp [

	super setUp.
	typer := TypeMe new
]

{ #category : 'tests' }
TypeMeTest >> tearDown [ 

	TypeMeTestHelper cleanTestConfigurations
]

{ #category : 'tests' }
TypeMeTest >> testMethodsReturnBoolean [

	| result |
	
	testConfiguration := '
		[
			{ 
				"packageName": "TypeMe-TestPackage-ReturnBoolean",
				"classes": [
					{ "className": "TypeMeReturnBoolean", "methods": [ {"hasName": "^nil"}, {"isUsed": "^nil"}, {"includes": "^nil" }, { "=": "other ^nil" }]}
				]
			}
		]
	'.
	
	TypeMeTestHelper installTestConfiguration: testConfiguration.
	
	typer extractTypesForPackage: 'TypeMe-TestPackage-ReturnBoolean'.
	result := typer methodsReturnBoolean.
	
	self assert: result size equals: 4.
	self assert: ((result collect: [ :a | a third ]) allSatisfy: [:methodName |  { 'hasName' . 'isUsed' . 'includes' . '='} includes: methodName ]).
	self assert: (result collect: [ :a | a fourth ]) asSet size equals: 1. 
	self assert: (result collect: [ :a | a fourth ]) asSet atRandom equals: 'Boolean'.
	
	TypeMeTestHelper removeTestConfiguration: testConfiguration.
	
]

{ #category : 'tests' }
TypeMeTest >> testMethodsReturnClass [

	| result |
	
	testConfiguration := '
		[
			{ 
				"packageName": "TypeMe-TestPackage-ReturnClass",
				"classes": [
					{ "className": "TypeMeReturnClass", "methods": [ {"returnClass": "^ TypeMeReturnClass"}, {"returnNil": "^nil"}]}
				]
			}
		]
	'.
	
	TypeMeTestHelper installTestConfiguration: testConfiguration.
	
	typer extractTypesForPackage: 'TypeMe-TestPackage-ReturnClass'.
	result := typer methodsReturnClass.
	
	self assert: result size equals: 1.
	self assert: (result collect: [ :a | a third ]) first equals: 'returnClass'.
	self assert: (result collect: [ :a | a fourth ]) first equals: 'TypeMeReturnClass class'.
	
	TypeMeTestHelper removeTestConfiguration: testConfiguration.
]

{ #category : 'tests' }
TypeMeTest >> testMethodsReturnClassNew [

	| result |
	
	testConfiguration := '
		[
			{ 
				"packageName": "TypeMe-TestPackage-ReturnClassNew",
				"classes": [
					{ "className": "TypeMeReturnClassNew", "methods": [ {"returnClassNew": "^ TypeMeReturnClass new"}, {"returnClass": "^ TypeMeReturnClass"}, {"returnNil": "^nil"}]}
				]
			}
		]
	'.
	
	TypeMeTestHelper installTestConfiguration: testConfiguration.
	
	typer extractTypesForPackage: 'TypeMe-TestPackage-ReturnClassNew'.
	result := typer methodsReturnClassNew.
	
	self assert: result size equals: 1.
	self assert: (result collect: [ :a | a third ]) first equals: 'returnClassNew'.
	self assert: (result collect: [ :a | a fourth ]) first equals: 'TypeMeReturnClass'.
	
	TypeMeTestHelper removeTestConfiguration: testConfiguration.
]

{ #category : 'tests' }
TypeMeTest >> testMethodsReturnLiteralNode [

	| result |
	testConfiguration := '
		[
			{ 
				"packageName": "TypeMe-TestPackage-ReturnLiteral",
				"classes": [
					{ "className": "TypeMeReturnLiteral", "methods": [ {"returnNumber": "^5"}, {"returnString": "^ ''BFS''"}, {"returnBoolean": "^ true" }, {"returnNotLiteral": "^ nil" }]}
				]
			}
		]
	'.

	TypeMeTestHelper installTestConfiguration: testConfiguration.

	typer extractTypesForPackage: 'TypeMe-TestPackage-ReturnLiteral'.
	result := typer methodsReturnLiteralNode.

	self assert: result size equals: 3.
	self
		assert: ((result collect: [ :a | a third ]) allSatisfy: [:methodName |  { 'returnNumber'. 'returnString'. 'returnBoolean' } includes: methodName ]).
		
	self assert: (result collect: [ :a | a fourth ]) asSet size equals: 1.
	self
		assert: (result collect: [ :a | a fourth ]) asSet atRandom
		equals: 'Literal'.

	TypeMeTestHelper removeTestConfiguration: testConfiguration
]

{ #category : 'tests' }
TypeMeTest >> testMethodsReturnNil [

	| result |
	
	testConfiguration := '
		[
			{ 
				"packageName": "TypeMe-TestPackage-ReturnOneNil",
				"classes": [
					{ "className": "TypeMeReturnOneNil", "methods": [ {"returnOneNil": " self yourself. ^ nil"}, {"returnTwothings": "self ifNil: [^ nil] ifNotNil: [^nil]"}, {"noExplicitReturn": "self yourself"}]}
				]
			}
		]
	'.
	
	TypeMeTestHelper installTestConfiguration: testConfiguration.
	
	typer extractTypesForPackage: 'TypeMe-TestPackage-ReturnOneNil'.
	result := typer methodsReturnNil.
	
	self assert: result size equals: 1.
	self assert: (result collect: [ :a | a third ]) first equals: 'returnOneNil'.
	self assert: (result collect: [ :a | a fourth ]) first equals: 'nil'.
	
	TypeMeTestHelper removeTestConfiguration: testConfiguration.
]

{ #category : 'tests' }
TypeMeTest >> testMethodsReturnNumber [

	| result |
	testConfiguration := '
		[
			{ 
				"packageName": "TypeMe-TestPackage-ReturnNumber",
				"classes": [
					{ "className": "TypeMeReturnNumber", "methods": [ {"size": "^5"}, {"priority": "^100"}, {"returnNotNumber": "^nil" }]}
				]
			}
		]
	'.

	TypeMeTestHelper installTestConfiguration: testConfiguration.

	typer extractTypesForPackage: 'TypeMe-TestPackage-ReturnNumber'.
	result := typer methodsReturnNumber.

	self assert: result size equals: 2.
	self
		assert: ((result collect: [ :a | a third ]) allSatisfy: [:methodName |  { 'size'. 'priority' } includes: methodName ]).
		
	self assert: (result collect: [ :a | a fourth ]) asSet size equals: 1.
	self
		assert: (result collect: [ :a | a fourth ]) asSet atRandom
		equals: 'Number'.

	TypeMeTestHelper removeTestConfiguration: testConfiguration
]

{ #category : 'tests' }
TypeMeTest >> testMethodsReturnSelf [

	| result |
	
	testConfiguration := '
		[
			{ 
				"packageName": "TypeMe-TestPackage-ReturnSelf",
				"classes": [
					{ "className": "TypeMeReturnSelf", "methods": [ {"returnOneSelf": "self yourself. ^ self"}, {"returnTwoSelf": "true ifTrue: [^ self] ifFalse: [^self]"}, {"returnNotSelf": "self yourself. ^ nil"}]}
				]
			}
		]
	'.
	
	TypeMeTestHelper installTestConfiguration: testConfiguration.
	
	typer extractTypesForPackage: 'TypeMe-TestPackage-ReturnSelf'.
	result := typer methodsReturnSelf.
	
	self assert: result size equals: 1.
	self assert: (result collect: [ :a | a third ]) first equals: 'returnOneSelf'.
	self assert: (result collect: [ :a | a fourth ]) first equals: 'TypeMeReturnSelf'.
	
	TypeMeTestHelper removeTestConfiguration: testConfiguration.
]

{ #category : 'tests' }
TypeMeTest >> testMethodsReturnSelfNew [

	| result |
	
	testConfiguration := '
		[
			{ 
				"packageName": "TypeMe-TestPackage-ReturnSelf",
				"classes": [
					{ "className": "TypeMeReturnSelf", "methods": [ {"returnOneSelf": "self yourself. ^ self new"}, {"returnTwoSelf": "true ifTrue: [^ self] ifFalse: [^self]"}, {"returnNotSelf": "self yourself. ^ nil"}]}
				]
			}
		]
	'.
	
	TypeMeTestHelper installTestConfiguration: testConfiguration.
	
	typer extractTypesForPackage: 'TypeMe-TestPackage-ReturnSelf'.
	result := typer methodsReturnSelf.
	
	self assert: result size equals: 1.
	self assert: (result collect: [ :a | a third ]) first equals: 'returnOneSelf'.
	self assert: (result collect: [ :a | a fourth ]) first equals: 'TypeMeReturnSelf'.
	
	TypeMeTestHelper removeTestConfiguration: testConfiguration.
]

{ #category : 'tests' }
TypeMeTest >> testMethodsReturnSmallInteger [

	| result |
	testConfiguration := '
		[
			{ 
				"packageName": "TypeMe-TestPackage-ReturnSmallInteger",
				"classes": [
					{ "className": "TypeMeReturnSmallInteger", "methods": [ {"hash": "^nil"}]}
				]
			}
		]
	'.

	TypeMeTestHelper installTestConfiguration: testConfiguration.

	typer extractTypesForPackage: 'TypeMe-TestPackage-ReturnSmallInteger'.
	result := typer methodsReturnSmallInteger.

	self assert: result size equals: 1.
	self assert: (result collect: [ :a | a third ]) first equals: 'hash'.
	self assert: (result collect: [ :a | a fourth ]) equals: 'SmallInteger'.

	TypeMeTestHelper removeTestConfiguration: testConfiguration
]

{ #category : 'tests' }
TypeMeTest >> testMethodsReturnString [

	| result |
	testConfiguration := '
		[
			{ 
				"packageName": "TypeMe-TestPackage-ReturnString",
				"classes": [
					{ "className": "TypeMeReturnString", "methods": [ {"asString": "^nil"}, {"withString": "^nil"}, {"includeString": "^nil" }]}
				]
			}
		]
	'.

	TypeMeTestHelper installTestConfiguration: testConfiguration.

	typer extractTypesForPackage: 'TypeMe-TestPackage-ReturnString'.
	result := typer methodsReturnString.

	self assert: result size equals: 3.
	self
		assert: ((result collect: [ :a | a third ]) allSatisfy: [:methodName |  { 'asString'. 'withString'. 'includeString'. '=' } includes: methodName ]).
		
	self assert: (result collect: [ :a | a fourth ]) asSet size equals: 1.
	self
		assert: (result collect: [ :a | a fourth ]) asSet atRandom
		equals: 'String'.

	TypeMeTestHelper removeTestConfiguration: testConfiguration
]

{ #category : 'tests' }
TypeMeTest >> testMethodsWithNoReturnStatement [

	| result |
	
	testConfiguration := '
		[
			{ 
				"packageName": "TypeMe-TestPackage-NoReturnStatement",
				"classes": [
					{ "className": "TestClassNoReturnStatementA", "methods": [ {"initialize": "self new"}]},
					{ "className": "TestClassNoReturnStatementB", "methods": [ {"initialize": "self yourself"}]} 
				] 
			}
		]
	'.
	
	TypeMeTestHelper installTestConfiguration: testConfiguration.
	
	typer extractTypesForPackage: 'TypeMe-TestPackage-NoReturnStatement'.
	result := typer methodsWithNoReturnStatement.
	
	self assert: result size equals: 2.
	self assert: ((result collect: [ :a | a third ]) allSatisfy: [:methodName | methodName = 'initialize']).
	self assert: (result collect: [ :a | a fourth ]) first equals: 'TestClassNoReturnStatementA'.
	self assert: (result collect: [ :a | a fourth ]) second equals: 'TestClassNoReturnStatementB'.
	
	TypeMeTestHelper removeTestConfiguration: testConfiguration.
]
