Class {
	#name : 'ScopeTest',
	#superclass : 'TypeMeTest',
	#category : 'TypeMe-Tests',
	#package : 'TypeMe-Tests'
}

{ #category : 'tests' }
ScopeTest >> setUp [

	super setUp.
	testConfiguration := '
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

	(TypeMeTestHelper installTestConfiguration: testConfiguration)
		ifFalse: [ self skip: 'Skipping all tests in this class.' ]
]

{ #category : 'running' }
ScopeTest >> tearDown [
	"remove test configuration from the image"

	TypeMeTestHelper removeTestConfiguration: testConfiguration
]

{ #category : 'tests' }
ScopeTest >> testExtractTypesForClass [

	typer extractTypesForClass: 'TestClassA'.
	self assert: typer inputMethods size equals: 3
]

{ #category : 'tests' }
ScopeTest >> testExtractTypesForClasses [

	typer extractTypesForClasses: #( TestClassA TestClassB TestClassC ).
	self assert: typer inputMethods size equals: 9
]

{ #category : 'tests' }
ScopeTest >> testExtractTypesForMethod [

	typer extractTypesForMethod: 'testmeUpdateMethod'.
	self assert: typer inputMethods size equals: 2
]

{ #category : 'tests' }
ScopeTest >> testExtractTypesForMethods [

	typer extractTypesForMethods: {'testmeUpdateMethod', 'size'}.
	self assert: typer inputMethods size equals: 3
]

{ #category : 'tests' }
ScopeTest >> testExtractTypesForPackage [

	typer extractTypesForPackage: 'TypeMe-TestPackage-1'.
	self assert: typer inputMethods size equals: 6
]

{ #category : 'tests' }
ScopeTest >> testExtractTypesForPackages [

	typer extractTypesForPackages:
		{ 'TypeMe-TestPackage-1'. 'TypeMe-TestPackage-2' }.
	self assert: typer inputMethods size equals: 9
]
