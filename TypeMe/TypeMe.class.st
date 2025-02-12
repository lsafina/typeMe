"
This class stores a list of methods required to extract return types of Pharo Image methods based on various heuristics e.g method's name, method's structure etc.

To run the extraction do TypeMe extractTypes, that we create a csv file in the root folder of TypeMe repository. The whole process takes around 5 min on M2 24GB 
 
"
Class {
	#name : 'TypeMe',
	#superclass : 'Object',
	#instVars : [
		'inputMethods',
		'types',
		'methods',
		'methodsWithSingleReturn'
	],
	#category : 'TypeMe-Objects',
	#package : 'TypeMe',
	#tag : 'Objects'
}

{ #category : 'as yet unclassified' }
TypeMe class >> extractTypesForClass: className [

	| typerInstance classObj collectedMethods |
	
	collectedMethods := OrderedCollection new.
	
	classObj := Smalltalk globals classNamed: className.
	classObj ifNil: [
		self error:
			'Class ' , className , ' is not found in the image. Aborting.' ].
		
	collectedMethods addAll: classObj methods.
	collectedMethods addAll: classObj class methods.	

	typerInstance := self new.
	typerInstance inputMethods: collectedMethods .
	^ typerInstance runHeuristics
]

{ #category : 'as yet unclassified' }
TypeMe class >> extractTypesForClasses: classNameCollection [

	| typerInstance collectedMethods |
	collectedMethods := OrderedCollection new.

	classNameCollection do: [ :className |
		| classObj |
		classObj := Smalltalk globals classNamed: className.
		classObj ifNil: [
			self error:
				'Class ' , className , ' is not found in the image. Aborting.' ].

		collectedMethods addAll: classObj methods.
		collectedMethods addAll: classObj class methods ].

	typerInstance := self new.
	typerInstance inputMethods: collectedMethods.
	^ typerInstance runHeuristics
]

{ #category : 'as yet unclassified' }
TypeMe class >> extractTypesForImage [

	| typerInstance collectedMethods |
	collectedMethods := Smalltalk globals methods.
	

	typerInstance := self new.
	typerInstance inputMethods: collectedMethods.
	^ typerInstance runHeuristics
]

{ #category : 'as yet unclassified' }
TypeMe class >> extractTypesForMethod: methodName [

	| typerInstance collectedMethods |
	
	collectedMethods := (Smalltalk globals methods) select: [ :m | m selector = methodName ].
	
	typerInstance := self new.
	typerInstance inputMethods: collectedMethods.
	^ typerInstance runHeuristics
]

{ #category : 'as yet unclassified' }
TypeMe class >> extractTypesForMethods: methodNameCollection [

	| typerInstance collectedMethods |
	
	collectedMethods := (Smalltalk globals methods) select: [ :m | methodNameCollection contains: (m selector) ].
	
	typerInstance := self new.
	typerInstance inputMethods: collectedMethods.
	^ typerInstance runHeuristics
]

{ #category : 'as yet unclassified' }
TypeMe class >> extractTypesForPackage: packageName [

	| typerInstance collectedMethods |
	collectedMethods := (Package organizer packageNamed: packageName ) methods.

	typerInstance := self new.
	typerInstance inputMethods: collectedMethods.
	^ typerInstance runHeuristics
]

{ #category : 'as yet unclassified' }
TypeMe class >> extractTypesForPackages: packageNameCollection [

	| typerInstance collectedMethods |
	collectedMethods := packageNameCollection flatCollect: [:packageName | (Package organizer packageNamed: packageName ) methods].

	typerInstance := self new.
	typerInstance inputMethods: collectedMethods.
	^ typerInstance runHeuristics
]

{ #category : 'data aggregation' }
TypeMe >> format: aCollection [

	^ aCollection collect: [ :pair |
		  | method |
		  method := pair value.
		  {
			  method package name.
			  method classBinding name.
			  method selector.
			  pair key } ]
]

{ #category : 'data aggregation' }
TypeMe >> format: aCollection withType: aType [

	^ aCollection collect: [ :method |
		  {
			  method package name.
			  method classBinding name.
			  method selector.
			  aType } ]
]

{ #category : 'data aggregation' }
TypeMe >> formatWithSelf: aMethodCollection [

	^ aMethodCollection collect: [ :method |
		  | classBinding |
		  
		classBinding := method classBinding name.
		  {
			  method package name.
			  classBinding.
			  method selector.
			  classBinding } ]
]

{ #category : 'accessing' }
TypeMe >> inputMethods: methodsCollection [

	inputMethods := methodsCollection 
]

{ #category : 'method heuristics' }
TypeMe >> methods: methodsSet selectorEqualsString: aString [

	^ methodsSet select: [ :method | method selector = aString ]
]

{ #category : 'method heuristics' }
TypeMe >> methods: methodsSet selectorMatchesRegex: aRegex [

	^ methodsSet select: [ :method |
		  aRegex asRegex matches: method selector ]
]

{ #category : 'method heuristics' }
TypeMe >> methodsReturnBoolean [
	"collect methods that we expect to return boolean based on their name"

	^ self
		  format: (OrderedCollection new
				   addAll:
					   ({ '^has[A-Z].*'. '^is[A-Z].*' } flatCollect: [ :aRegex |
							    self
								    methods: methodsWithSingleReturn
								    selectorMatchesRegex: aRegex ]);
				   addAll: ({ 'includes'. '=' } flatCollect: [ :aString |
							    self
								    methods: methodsWithSingleReturn
								    selectorEqualsString: aString ]);
				   yourself)
		  withType: #Boolean
]

{ #category : 'method heuristics' }
TypeMe >> methodsReturnClass [
	"collects method that have only one return statement which returns a class (^ %ClassName%)"

	| result |
	result := OrderedCollection new.
	methodsWithSingleReturn do: [ :method |
		| aReturn |
		aReturn := ASTHelper getSingleReturn: method.
		(ASTHelper ifReturnReturnsClass: aReturn) ifTrue: [
			result add: (ASTHelper getClassFromReturnNew: aReturn) -> method ] ].

	^ self format: result
]

{ #category : 'method heuristics' }
TypeMe >> methodsReturnClassNew [
	"collects method that have only one return statement which returns a class new (^ %ClassName% new)"

	| result |
	result := OrderedCollection new.
	methodsWithSingleReturn do: [ :method |
		| aReturn |
		aReturn := ASTHelper getSingleReturn: method.
		(ASTHelper ifReturnReturnsClassNew: aReturn) ifTrue: [
			result add:
				(ASTHelper getClassNameFromReturnNew: aReturn) -> method ] ].

	^ self format: result
]

{ #category : 'method heuristics' }
TypeMe >> methodsReturnLiteralNode [
	"collects method that have only one return statement which returns a literal value (^ 5, ^ true, ^ 'BFS' etc)"

	| literalToMethod |
	literalToMethod := OrderedCollection new.

	methodsWithSingleReturn do: [ :method |
		| returnSt |
		returnSt := ASTHelper getSingleReturn: method.
		(ASTHelper ifReturnReturnsLiteralNode: returnSt) ifTrue: [
			literalToMethod add:
				(ASTHelper getReturnLiteralNode: returnSt) className -> method ] ].

	^ self format: literalToMethod
]

{ #category : 'method heuristics' }
TypeMe >> methodsReturnNil [
	"collects method that have only one return statement which returns nil (^ nil)"

	^ self
		  format: (methodsWithSingleReturn select: [ :method |
				   ASTHelper ifMethodReturnOnlyNil: method ast ])
		  withType: nil
]

{ #category : 'method heuristics' }
TypeMe >> methodsReturnNumber [
	"collect methods that we expect to return Number type subcalsses"

	^ self
		  format: ({ 'size'. 'priority' } flatCollect: [ :aString |
				   self
					   methods: methodsWithSingleReturn
					   selectorEqualsString: aString ])
		  withType: #Number
]

{ #category : 'method heuristics' }
TypeMe >> methodsReturnSelf [
	"collects methods that have only one return statement which returns a self (^ self)"

	"TODO: refactor"

	^ self formatWithSelf: ((((methodsWithSingleReturn collect: [ :m |
			      (ASTHelper getSingleReturn: m) -> m ]) select: [ :pair |
			     pair key value class = RBVariableNode ]) select: [ :pair |
			    pair key value name = 'self' ]) collect: [ :pair | pair value ])
]

{ #category : 'method heuristics' }
TypeMe >> methodsReturnSelfNew [
	"collects methods that have only one return statement which returns a self new (^ self new)"

	^ self formatWithSelf: (methodsWithSingleReturn select: [ :method |
			   ASTHelper ifReturnReturnsSelfNew:
				   (ASTHelper getSingleReturn: method) ])
]

{ #category : 'method heuristics' }
TypeMe >> methodsReturnSmallInteger [
	"collect methods that we expect to return SmallInteger"

	^ self
		  format: ({ 'hash' } flatCollect: [ :aString |
				   self
					   methods: methodsWithSingleReturn
					   selectorEqualsString: aString ])
		  withType: #Number
]

{ #category : 'method heuristics' }
TypeMe >> methodsReturnString [
	"collect methods that we expect to return String"

	^ self
		  format: (methodsWithSingleReturn select: [ :method |
				   method selector endsWith: 'String' ])
		  withType: #String
]

{ #category : 'method heuristics' }
TypeMe >> methodsTypeExtractedFromName [
	"here we make some guesses on which type might a method return based on its selector name, 
if we can, we check that this information is correct"

	^ OrderedCollection new
		  addAll: self methodsReturnBoolean;
		  addAll: self methodsReturnString;
		  addAll: self methodsReturnNumber;
		  addAll: self methodsReturnSmallInteger;
		  yourself
]

{ #category : 'method heuristics' }
TypeMe >> methodsWithReturn [

	^ OrderedCollection new
		  addAll: self methodsTypeExtractedFromName;
		  addAll: self methodsReturnNil;
		  addAll: self methodsReturnClass;
		  addAll: self methodsReturnClassNew;
		  addAll: self methodsReturnSelf;
		  addAll: self methodsReturnSelfNew;
		  addAll: self methodsReturnLiteralNode;
		  yourself
]

{ #category : 'method heuristics' }
TypeMe >> methodsWithoutReturn [
	"their type correspond to the class of receiver"

	^ self formatWithSelf: (methods reject: [ :method |
			   ASTHelper ifMethodHasReturnStatements: method ast ])
]

{ #category : 'method heuristics' }
TypeMe >> runHeuristics [

	| typesFile result |
	result := OrderedCollection new
		          addAll: self methodsWithReturn;
		          addAll: self methodsWithoutReturn;
		          yourself.

	typesFile := FileLocator
		             fromPath:
		             'pharo-local/iceberg/type-me/types.csv' asPath
		             ifNone: [  ].

	types := NeoCSVReader on: typesFile readStream upToEnd.

	typesFile asFileReference writeStreamDo: [ :file |
		ZnBufferedWriteStream
			on: file
			do: [ :out |
				| writer |
				writer := NeoCSVWriter on: out.
				writer writeHeader: { #Package. #Class. #Selector. #Types }.
				result do: [ :each | writer nextPut: each ] ] ]
]

{ #category : 'accessing' }
TypeMe >> types [

	^ types
]
