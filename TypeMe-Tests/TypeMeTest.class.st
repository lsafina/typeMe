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

	super setUp.
	testConfiguration := NeoJSONReader fromString: '
		[
			{ 
				"packageName": "TypeMe-TestPackage-1",
				"classes": [
					{ "className": "TestClassA", "methods": [ {"isTrue": "^ a = b"}, {"initialize": "^ self new"}, {"asString": "^ a toString"} ]},
					{ "className": "TestClassB", "methods": [ {"add:to": "^ a add: b"}, {"size": "^1"}, {"testmeUpdateMethod": "a update: b"}]} 
				] 
			},
			{ 
				"packageName": "TypeMe-TestPackage-2",
				"classes": [
					{ "className": "TestClassC", "methods": [ {"hasName": "a name isNotNil:[^true]. ^false"}, {"testmeUpdateMethod": "a update: b"}, {"testCreation": "self setUp" } ]}
				] 
			}
		]
	'.

	"check if test configuration can be installed in the image"
	(TypeMeTestHelper checkTestConfiguration: testConfiguration)
		ifFalse: [
			self skip:
				'Test packages can not be created. Skipping all tests in this class.' ]
		ifTrue: [
			TypeMeTestHelper installTestObjects: testConfiguration.
			typer := TypeMe new ]
]

{ #category : 'tests' }
TypeMeTest >> tearDown [
	"remove test configuration from the image"

	TypeMeTestHelper removeTestObjects: testConfiguration

	
]

{ #category : 'tests' }
TypeMeTest >> testExtractTypesForClass [

	typer extractTypesForClass: 'TestClassA'.
	self assert: typer inputMethods size equals: 3
]

{ #category : 'tests' }
TypeMeTest >> testExtractTypesForClasses [

	typer extractTypesForClasses: #( TestClassA TestClassB TestClassC ).
	self assert: typer inputMethods size equals: 8
]

{ #category : 'tests' }
TypeMeTest >> testExtractTypesForMethod [

	typer extractTypesForMethod: 'testmeUpdateMethod'.
	self assert: typer inputMethods size equals: 2
]

{ #category : 'tests' }
TypeMeTest >> testExtractTypesForMethods [

	typer extractTypesForMethods: {'testmeUpdateMethod', 'size'}.
	self assert: typer inputMethods size equals: 3
]

{ #category : 'tests' }
TypeMeTest >> testExtractTypesForPackage [

	typer extractTypesForPackage: 'TypeMe-TestPackage-1'.
	self assert: typer inputMethods size equals: 5
]

{ #category : 'tests' }
TypeMeTest >> testExtractTypesForPackages [

	typer extractTypesForPackages:
		{ 'TypeMe-TestPackage-1'. 'TypeMe-TestPackage-2' }.
	self assert: typer inputMethods size equals: 8
]

{ #category : 'tests' }
TypeMeTest >> testMethodsReturnBoolean [

	self flag: #toImplement.
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
