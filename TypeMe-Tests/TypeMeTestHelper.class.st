Class {
	#name : 'TypeMeTestHelper',
	#superclass : 'Object',
	#category : 'TypeMe-Tests',
	#package : 'TypeMe-Tests'
}

{ #category : 'as yet unclassified' }
TypeMeTestHelper class >> checkTestConfiguration: testConfiguration [
	"check if packages with the same name already exist in the image"

	^ testConfiguration noneSatisfy: [ :package |
		  self packageOrganizer hasPackage: (package at: 'packageName') ]
]

{ #category : 'as yet unclassified' }
TypeMeTestHelper class >> cleanTestConfigurations [

	"TODO: update for use with environment"
	
	(PackageOrganizer default packages select: [ :p |
		 p name beginsWith: 'TypeMe-TestPackage' ]) do: [ :p |
		p removeFromSystem ]
]

{ #category : 'as yet unclassified' }
TypeMeTestHelper class >> cleanTestEnvironment: testEnvironment [

	testEnvironment organization packages do: [:package | package removeFromSystem ]
]

{ #category : 'as yet unclassified' }
TypeMeTestHelper class >> createTestClass: className package: packageName instVariables: instVarCol onEnvironment: anEnvironment [
	
	^ ShiftClassInstaller new make: [ :builder |
	             builder
		             name: className ;
		             slots: instVarCol;
		             package: packageName ;
		             installingEnvironment: anEnvironment ].
	

]

{ #category : 'as yet unclassified' }
TypeMeTestHelper class >> installTestConfiguration: testConfiguration [

	| ts |
	
	ts := (STONReader on:  testConfiguration readStream) next.

	"check if test configuration can be installed in the image"
	(self checkTestConfiguration: ts)
		ifFalse: [
			(self removeTestConfiguration: testConfiguration) ifFalse: [
				Error signal:'Test package(s) can not be created.' 
			]
		]. 
	 
	self installTestObjects: ts. 
	^ true
]

{ #category : 'as yet unclassified' }
TypeMeTestHelper class >> installTestMethods: methodsCol onTestClass: testClass [
	
	methodsCol do: [ :method | testClass compile: method ]
]

{ #category : 'as yet unclassified' }
TypeMeTestHelper class >> installTestObjects: testConfiguration [

	testConfiguration do: [ :confPackage |
		| sysPackage |
		sysPackage := Package named: (confPackage at: 'packageName').
		self packageOrganizer addPackage: sysPackage.

		(confPackage at: 'classes') do: [ :confClass |
			| sysClass |
			sysClass := Object classInstaller make: [ :builder |
				            builder
					            superclass: Object;
					            name: (confClass at: 'className');
					            slotsFromString: '';
					            sharedVariablesFromString: '';
					            package: sysPackage;
					            environment: Object environment ].
			(confClass at: 'methods') do: [ :confMethod | 
				sysClass compile: (self prepareMethodName: confMethod) ] ] ]
]

{ #category : 'accessing' }
TypeMeTestHelper class >> prepareMethodName: methodPair [
	"checks if a method is a keyword method and ads to it fake arguments to facilitate installing it to the system (e.g a:b -> a:arg1 b:arg2) otherwise return method name"

	|methodName newMethodName|
	
	methodName := methodPair keys first.
	
	newMethodName := (methodName includesSubstring: ':') ifTrue: [
		 ' ' join:
			  ((methodName splitOn: ':') withIndexCollect: [ :selector :index |
				   selector , ':arg' , index asString ]) ]
		ifFalse: [methodName].

	^ newMethodName , ' ' , methodPair values first
]

{ #category : 'as yet unclassified' }
TypeMeTestHelper class >> removeTestConfiguration: testConfiguration [

	|result|
	
	result := true.	
	(STONReader on: testConfiguration readStream ) next do: [ :packageRecord |
		| package packageName |
		packageName := packageRecord values first.
		package := self packageOrganizer packageNamed: packageName ifAbsent: nil.
		package ifNotNil: [ package removeFromSystem ] ifNil: [ result := false]].
	
	^ result 
]
