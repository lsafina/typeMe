Class {
	#name : 'TypeMeTest',
	#superclass : 'TestCase',
	#instVars : [
		'testConfiguration',
		'typer'
	],
	#category : 'TypeMe-Tests',
	#package : 'TypeMe-Tests'
}

{ #category : 'tests' }
TypeMeTest >> setUp [

	typer := TypeMe new
]

{ #category : 'tests' }
TypeMeTest >> testMethodsReturnBoolean [

	testConfiguration := NeoJSONReader fromString: '
		[
			{ 
				"packageName": "TypeMe-TestPackage-ReturnBoolean",
				"classes": [
					{ "className": "TypeMeReturnBoolean", "methods": [ {"hasName": "^nil"}, {"isUsed": "^nil"}, {"includes": "^nil" }, { "=": "other ^nil" }]}
				]
			}
		]
	'.

	"check if test configuration can be installed in the image"
	(TypeMeTestHelper checkTestConfiguration: testConfiguration)
		ifFalse: [
			Error signal:
				'Test packages can not be created. Skipping all tests in this class.' ]
		ifTrue: [ TypeMeTestHelper installTestObjects: testConfiguration ].
	
	typer extractTypesForPackage: 'TypeMe-TestPackage-ReturnBoolean'.
	typer methodsReturnBoolean.
	self assert: false
]

{ #category : 'tests' }
TypeMeTest >> testMethodsReturnClass [

	self flag: #toImplement.
	self assert: false
]

{ #category : 'tests' }
TypeMeTest >> testMethodsReturnClassNew [

	self flag: #toImplement.
	self assert: false
]

{ #category : 'tests' }
TypeMeTest >> testMethodsReturnLiteralNode [

	self flag: #toImplement.
	self assert: false
]

{ #category : 'tests' }
TypeMeTest >> testMethodsReturnNil [

	self flag: #toImplement.
	self assert: false
]

{ #category : 'tests' }
TypeMeTest >> testMethodsReturnNumber [

	self flag: #toImplement.
	self assert: false
]

{ #category : 'tests' }
TypeMeTest >> testMethodsReturnSelf [

	self flag: #toImplement.
	self assert: false
]

{ #category : 'tests' }
TypeMeTest >> testMethodsReturnSelfNew [

	self flag: #toImplement.
	self assert: false
]

{ #category : 'tests' }
TypeMeTest >> testMethodsReturnSmallInteger [

	self flag: #toImplement.
	self assert: false
]

{ #category : 'tests' }
TypeMeTest >> testMethodsReturnString [

	self flag: #toImplement.
	self assert: false
]

{ #category : 'tests' }
TypeMeTest >> testMethodsWithNoReturnStatement [

	self flag: #toImplement.
	self assert: false
]
