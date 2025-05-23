Class {
	#name : 'ScopeTest',
	#superclass : 'TypeMeTest',
	#category : 'TypeMe-Tests',
	#package : 'TypeMe-Tests'
}

{ #category : 'tests' }
ScopeTest >> setUp [

	super setUp.

	TypeMeTestHelper
		installTestMethods: (OrderedCollection newFrom:
				 { 'isTrue ^ true'. 'initialize ^ self new'.
				 'asString ^ a asString' })
		onTestClass: (TypeMeTestHelper
				 createTestClass: #TypeMeTestClassA
				 package: 'TypeMe-TestPackage-1'
				 instVariables: { 'a' }
				 onEnvironment: testEnvironment).

	TypeMeTestHelper
		installTestMethods: (OrderedCollection newFrom:
				 { 'add: a to: b ^ true'. 'mySize ^ 1'. 'testmeUpdateMethod ^ nil' })
		onTestClass: (TypeMeTestHelper
				 createTestClass: #TypeMeTestClassB
				 package: 'TypeMe-TestPackage-1'
				 instVariables: { 'a'. 'b' }
				 onEnvironment: testEnvironment).

	TypeMeTestHelper
		installTestMethods: (OrderedCollection newFrom:
				 { 'hasName ^ true'. 'testCreation self setUp'.
				 'testmeUpdateMethod ^ nil' })
		onTestClass: (TypeMeTestHelper
				 createTestClass: #TypeMeTestClassC
				 package: 'TypeMe-TestPackage-2'
				 instVariables: { 'a'. 'b' }
				 onEnvironment: testEnvironment)
]

{ #category : 'running' }
ScopeTest >> tearDown [

	TypeMeTestHelper cleanTestEnvironment: testEnvironment
]

{ #category : 'tests' }
ScopeTest >> testExtractTypesForClass [

	typer extractTypesForClass: 'TypeMeTestClassA'.
	self assert: typer inputMethods size equals: 3
]

{ #category : 'tests' }
ScopeTest >> testExtractTypesForClasses [

	typer extractTypesForClasses: #( TypeMeTestClassA TypeMeTestClassB TypeMeTestClassC ).
	self assert: typer inputMethods size equals: 9
]

{ #category : 'tests' }
ScopeTest >> testExtractTypesForMethod [

	typer extractTypesForMethod: 'testmeUpdateMethod'.
	
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
