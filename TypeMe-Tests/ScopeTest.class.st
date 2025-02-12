Class {
	#name : 'ScopeTest',
	#superclass : 'TestCase',
	#instVars : [
		'testConfiguration'
	],
	#category : 'TypeMe-Tests',
	#package : 'TypeMe-Tests'
}

{ #category : 'tests' }
ScopeTest >> setUp [

	super setUp.
	testConfiguration := NeoJSONReader fromString: '''
		[
			{ 
				"packageName": "TypeMe-TestPackage-1",
				"classes": [
					{ "className": "TestClassA", "methods": [ "isTrue", "initialize", "asString" ]},
					{ "className": "TestClassB", "methods": [ "add:to", "size" ]} 
				] 
			},
			{ 
				"packageName": "TypeMe-TestPackage-2",
				"classes": [
					{ "className": "TestClassC", "methods": [ "hasName", "new", "testCreation" ]}
				] 
			}
		]
	'''.

	"check if test configuration can be installed in the image"
	(TypeMeTestHelper checkTestConfiguration: testConfiguration)
		ifFalse: [
			self skip:
				'Test packages can not be created. Skipping all tests in this class.' ].

	"install test configuration in the image"
	TypeMeTestHelper installTestObjects: testConfiguration
]

{ #category : 'tests' }
ScopeTest >> tearDown [

	"remove test configuration from the image"
	TypeMeTestHelper removeTestObjects: testConfiguration
]
