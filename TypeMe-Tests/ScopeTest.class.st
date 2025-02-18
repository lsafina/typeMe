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
					{ "className": "TestClassA", "methods": [ 
									{"isTrue" : ""}, 
									{"initialize" : "^ self new"}, 
									{"asString" : ""} ]},
					{ "className": "TestClassB", "methods": [ 
									{"add:to" : ""}, 
									{"mySize" : "^1"}, 
									{"testmeUpdateMethod" : ""}]} 
				] 
			},
			{ 
				"packageName": "TypeMe-TestPackage-2",
				"classes": [
					{ "className": "TestClassC", "methods": [ 
							{"hasName" : ""}, 
							{"testmeUpdateMethod": ""}, 
							{"testCreation": "self setUp" } ]}
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

	typer extractTypesForMethod: 'testmeUpdateMethod' fromClasses: { 'TestClassB' . 'TestClassC' }.
	
	self assert: typer inputMethods size equals: 2
]

{ #category : 'tests' }
ScopeTest >> testExtractTypesForMethods [

	typer extractTypesForMethods: {#testmeUpdateMethod . #mySize}.
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
