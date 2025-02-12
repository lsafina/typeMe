Class {
	#name : 'TypeMeTestHelper',
	#superclass : 'Object',
	#category : 'TypeMe-Tests',
	#package : 'TypeMe-Tests'
}

{ #category : 'as yet unclassified' }
TypeMeTestHelper class >> checkTestConfiguration: testConfiguration [
"check if packages with the same name already exist in the image"
	
	^ testConfiguration noneSatisfy: [:package | Package organizer includesPackageNamed: (package at: 'packageName') isTrue] .
]

{ #category : 'as yet unclassified' }
TypeMeTestHelper class >> installTestObjects: testConfiguration [

	testConfiguration do: [ :confPackage |
		| sysPackage |
		sysPackage := Package named: (confPackage at: 'packageName').
		Package organizer addPackage: sysPackage.

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
				sysClass compile: ( self prepareMethodName: confMethod) ] ] ]
]

{ #category : 'accessing' }
TypeMeTestHelper class >> prepareMethodName: methodName [
	"checks if a method is a keyword method and ads to it fake arguments to facilitate installing it to the system (e.g a:b -> a:arg1 b:arg2) otherwise return method name"

	(methodName includesSubstring: ':') ifTrue: [
		^ ' ' join:
			  ((methodName splitOn: ':') withIndexCollect: [ :selector :index |
				   selector , ':arg' , index asString ]) ].

	^ methodName
]

{ #category : 'as yet unclassified' }
TypeMeTestHelper class >> removeTestObjects: testConfiguration [

	testConfiguration do: [ :confPackage | confPackage removeFromSystem ].
]
