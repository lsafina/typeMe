"
This class stores a list of methods required to extract return types of Pharo Image methods based on various heuristics e.g method's name, method's structure etc.

To run the extraction do TypeMe extractTypes, that we create a csv file in the root folder of TypeMe repository. The whole process takes around 5 min on M2 24GB 
 
"
Class {
	#name : 'TypeMe',
	#superclass : 'Object',
	#instVars : [
		'inputMethods',
		'methodsWithSingleReturn',
		'exploredTypes',
		'exploredMethods'
	],
	#category : 'TypeMe-Objects',
	#package : 'TypeMe',
	#tag : 'Objects'
}

{ #category : 'extracting' }
TypeMe class >> extractTypesForClass: className [

	| typerInstance classObj collectedMethods |
	collectedMethods := OrderedCollection new.

	classObj := Smalltalk globals classNamed: className.
	classObj ifNil: [
		self error:
			'Class ' , className , ' is not found in the image. Aborting.' ].

	collectedMethods addAll: classObj methods.
	collectedMethods addAll: classObj class methods.

	typerInstance := self new initialize: collectedMethods.
	^ typerInstance runHeuristics
]

{ #category : 'extracting' }
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

	typerInstance := self new initialize: collectedMethods.
	^ typerInstance runHeuristics
]

{ #category : 'extracting' }
TypeMe class >> extractTypesForImage [

	| typerInstance collectedMethods |
	collectedMethods := Smalltalk globals methods.


	typerInstance := self new initialize: collectedMethods.
	^ typerInstance runHeuristics
]

{ #category : 'extracting' }
TypeMe class >> extractTypesForMethod: methodName [

	| typerInstance collectedMethods |
	collectedMethods := Smalltalk globals methods select: [ :m |
		                    m selector = methodName ].

	typerInstance := self new initialize: collectedMethods.
	^ typerInstance runHeuristics
]

{ #category : 'extracting' }
TypeMe class >> extractTypesForMethods: methodNameCollection [

	| typerInstance collectedMethods |
	collectedMethods := Smalltalk globals methods select: [ :m |
		                    methodNameCollection contains: m selector ].

	typerInstance := self new initialize: collectedMethods.
	^ typerInstance runHeuristics
]

{ #category : 'extracting' }
TypeMe class >> extractTypesForPackage: packageName [

	| typerInstance collectedMethods |
	collectedMethods := (Package organizer packageNamed: packageName)
		                    methods.

	typerInstance := self new initialize: collectedMethods.
	^ typerInstance runHeuristics
]

{ #category : 'extracting' }
TypeMe class >> extractTypesForPackages: packageNameCollection [

	| typerInstance collectedMethods |
	collectedMethods := packageNameCollection flatCollect: [ :packageName |
		                    (Package organizer packageNamed: packageName)
			                    methods ].

	typerInstance := self new initialize: collectedMethods.
	^ typerInstance runHeuristics
]

{ #category : 'printing' }
TypeMe class >> print: typeCollection to: aFormat [

	aFormat = 'csv' ifTrue: [ self printToCSV: typeCollection ]
	
	
]

{ #category : 'printing' }
TypeMe class >> printToCSV: typeCollection [

	| typesFile |
	typesFile := FileLocator
		             fromPath:
		             'pharo-local/iceberg/typeMe/types.csv' asPath
		             ifNone: [].

	typesFile asFileReference writeStreamDo: [ :file |
		ZnBufferedWriteStream
			on: file
			do: [ :out |
				| writer |
				writer := NeoCSVWriter on: out.
				writer writeHeader: { #Package. #Class. #Selector. #Types }.
				typeCollection do: [ :each | writer nextPut: each ] ] ]
]

{ #category : 'analyzing' }
TypeMe >> checkForAnomaly: typeCollection [

	| intersection typeCollectionMethods|
	
	typeCollectionMethods := typeCollection collect: [:typeRecord | {typeRecord first . typeRecord second . typeRecord third } ].
	intersection := exploredMethods intersection: typeCollection.
	intersection ifNotEmpty: [ 1 halt ].
	exploredTypes addAll: typeCollection.
	exploredMethods addAll: typeCollectionMethods. 
]

{ #category : 'aggregating' }
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

{ #category : 'aggregating' }
TypeMe >> format: aCollection withType: aType [

	^ aCollection collect: [ :method |
		  {
			  method package name.
			  self getClassName: method.
			  method selector.
			  aType } ]
]

{ #category : 'aggregating' }
TypeMe >> formatWithSelf: aMethodCollection [

	^ aMethodCollection collect: [ :method |
		  | classBinding |
		  classBinding := self getClassName: method.
		  {
			  method package name.
			  classBinding.
			  method selector.
			  classBinding } ]
]

{ #category : 'aggregating' }
TypeMe >> getClassName: method [

^ method isClassSide
			                  ifTrue: [ method classBinding value name ]
			                  ifFalse: [ method classBinding name ]
]

{ #category : 'instance creation' }
TypeMe >> initialize: methodsCollection [

	inputMethods := methodsCollection.
	methodsWithSingleReturn := inputMethods select: [ :method |
		                           ASTHelper ifMethodHasOneReturnStatement:
			                           method ast ].
	exploredTypes := OrderedCollection new.
	exploredMethods := OrderedCollection new.
]

{ #category : 'accessing' }
TypeMe >> inputMethods: methodsCollection [

	inputMethods := methodsCollection 
]

{ #category : 'aggregating' }
TypeMe >> methods: methodsSet selectorEqualsString: aString [

	^ methodsSet select: [ :method | method selector = aString ]
]

{ #category : 'aggregating' }
TypeMe >> methods: methodsSet selectorMatchesRegex: aRegex [

	^ methodsSet select: [ :method |
		  aRegex asRegex matches: method selector ]
]

{ #category : 'heuristics' }
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

{ #category : 'heuristics' }
TypeMe >> methodsReturnClass [
	"collects method that have only one return statement which returns a class (^ %ClassName%)"
| result |

	result := OrderedCollection new.
	methodsWithSingleReturn do: [ :method |
		| aReturn |
		aReturn := ASTHelper getSingleReturn: method.
		(ASTHelper ifReturnReturnsClass: aReturn) ifTrue: [
			result add: ((ASTHelper getClassFromReturnNew: aReturn) , ' class') -> method ] ].

	^ self format: result
]

{ #category : 'heuristics' }
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

{ #category : 'heuristics' }
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

{ #category : 'heuristics' }
TypeMe >> methodsReturnNil [
	"collects method that have only one return statement which returns nil (^ nil)"

	^ self
		  format: (methodsWithSingleReturn select: [ :method |
				   ASTHelper ifMethodReturnOnlyNil: method ast ])
		  withType: nil
]

{ #category : 'heuristics' }
TypeMe >> methodsReturnNumber [
	"collect methods that we expect to return Number type subcalsses"

	^ self
		  format: ({ 'size'. 'priority' } flatCollect: [ :aString |
				   self
					   methods: methodsWithSingleReturn
					   selectorEqualsString: aString ])
		  withType: #Number
]

{ #category : 'heuristics' }
TypeMe >> methodsReturnSelf [
	"collects methods that have only one return statement which returns a self (^ self)"

	"TODO: refactor"

	^ self formatWithSelf: ((((methodsWithSingleReturn collect: [ :m |
			      (ASTHelper getSingleReturn: m) -> m ]) select: [ :pair |
			     pair key value class = RBVariableNode ]) select: [ :pair |
			    pair key value name = 'self' ]) collect: [ :pair | pair value ])
]

{ #category : 'heuristics' }
TypeMe >> methodsReturnSelfNew [
	"collects methods that have only one return statement which returns a self new (^ self new)"

	^ self formatWithSelf: (methodsWithSingleReturn select: [ :method |
			   ASTHelper ifReturnReturnsSelfNew:
				   (ASTHelper getSingleReturn: method) ])
]

{ #category : 'heuristics' }
TypeMe >> methodsReturnSmallInteger [
	"collect methods that we expect to return SmallInteger"

	^ self
		  format: ({ 'hash' } flatCollect: [ :aString |
				   self
					   methods: methodsWithSingleReturn
					   selectorEqualsString: aString ])
		  withType: #Number
]

{ #category : 'heuristics' }
TypeMe >> methodsReturnString [
	"collect methods that we expect to return String"

	^ self
		  format: (methodsWithSingleReturn select: [ :method |
				   method selector endsWith: 'String' ])
		  withType: #String
]

{ #category : 'heuristics' }
TypeMe >> methodsWithNoReturnStatement [
	"their type correspond to the class of receiver"

	^ self formatWithSelf: (inputMethods reject: [ :method |
			   ASTHelper ifMethodHasReturnStatements: method ast ])
]

{ #category : 'run' }
TypeMe >> runHeuristics [

	| typeResult |
	typeResult := OrderedCollection new.
	(self class selectorsInProtocol: 'heuristics') do: [ :method |
		| methodResult |
		methodResult := self perform: method.
		typeResult addAll: methodResult.
		self checkForAnomaly: methodResult ].

	Transcript
		show: 'Total methods: ' , inputMethods size asString
			, ', type discoverd for: ' , typeResult size asString , ' ('
			, ((typeResult size / inputMethods size asFloat * 100) printShowingDecimalPlaces: 2)
		 , '%).'.

	^ typeResult
]
