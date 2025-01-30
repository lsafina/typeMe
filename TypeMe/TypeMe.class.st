Class {
	#name : 'TypeMe',
	#superclass : 'Object',
	#classInstVars : [
		'types',
		'methods',
		'methodsWithSingleReturn'
	],
	#category : 'TypeMe-Objects',
	#package : 'TypeMe',
	#tag : 'Objects'
}

{ #category : 'formatting' }
TypeMe class >> format: aCollection [ 

	^ aCollection collect: [ :pair |
		| method|
			method := pair value.
		 {
			  method package name.
			  method classBinding name.
			  method selector.
			  pair key } ]
]

{ #category : 'formatting' }
TypeMe class >> format: aCollection withType: aType [

	^ aCollection collect: [ :method |
		{
			method package name.
			method classBinding name.
			method selector.
			aType } ]
]

{ #category : 'formatting' }
TypeMe class >> formatWithSelf: aCollection [

	^ aCollection collect: [ :method |
			|classBinding|
			classBinding := method classBinding name.  
		{
			  method package name.
			  classBinding.
			  method selector.
			classBinding
			   } ]
]

{ #category : 'as yet unclassified' }
TypeMe class >> initialize [

	| typesFile result |
	"methods := SystemNavigation default allMethods.
	methodsWithSingleReturn := methods select: [ :method |
		                           | methodAST |
		                           methodAST := method ast.
		                           (ASTHelper
			                            ifMethodHasOneReturnStatement:
			                            methodAST) and: methodAST lastIsReturn ]."
	
	result := OrderedCollection new addAll: self methodsWithReturn; addAll: self methodsWithoutReturn; yourself.

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
				result do: [ :each | writer nextPut: each ]
				 ] ] 
]

{ #category : 'private - utility' }
TypeMe class >> methods: methodsSet selectorEqualsString: aString [

	^ methodsSet select: [ :method | method selector = aString ]
]

{ #category : 'private - utility' }
TypeMe class >> methods: methodsSet selectorMatchesRegex: aRegex [

	^ methodsSet select: [ :method |
		  aRegex asRegex matches: method selector ]
]

{ #category : 'type of methods' }
TypeMe class >> methodsReturnBoolean [
	"collect methods that we expect to return boolean based on their name"

	^ self
		  format:
			  (OrderedCollection new addAll: ({ '^has[A-Z].*'. '^is[A-Z].*' } flatCollect: [ :aRegex |
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

{ #category : 'type of methods' }
TypeMe class >> methodsReturnClass [
	"collects method that have only one return statement which returns a class (^ %ClassName%)"

	| result |
	
	result := OrderedCollection new.
	methodsWithSingleReturn do: [ :method |
		  | aReturn |
		  aReturn := ASTHelper getSingleReturn: method.
		  (ASTHelper ifReturnReturnsClass: aReturn) ifTrue: [
			  result add: ((ASTHelper getClassFromReturnNew: aReturn) -> method) ]].
	
	^ self format: result 
	
]

{ #category : 'type of methods' }
TypeMe class >> methodsReturnClassNew [
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

{ #category : 'type of methods' }
TypeMe class >> methodsReturnLiteralNode [
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

{ #category : 'type of methods' }
TypeMe class >> methodsReturnNil [

"collects method that have only one return statement which returns nil (^ nil)"

	^ self format: (methodsWithSingleReturn select: [ :method |
		   ASTHelper ifMethodReturnOnlyNil: method ast ]) withType: nil.
]

{ #category : 'type of methods' }
TypeMe class >> methodsReturnNumber [
	"collect methods that we expect to return Number type subcalsses"

	^ self
		  format: ({ 'size'. 'priority' } flatCollect: [ :aString |
				   self
					   methods: methodsWithSingleReturn
					   selectorEqualsString: aString ])
		  withType: #Number
]

{ #category : 'type of methods' }
TypeMe class >> methodsReturnSelf [
	"collects methods that have only one return statement which returns a self (^ self)"
	"TODO: refactor"

	^ self formatWithSelf: ((((methodsWithSingleReturn collect: [ :m |
			      (ASTHelper getSingleReturn: m) -> m ]) select: [ :pair |
			     pair key value class = RBVariableNode ]) select: [ :pair |
			    pair key value name = 'self' ]) collect: [ :pair | pair value ])
]

{ #category : 'type of methods' }
TypeMe class >> methodsReturnSelfNew [
	"collects methods that have only one return statement which returns a self new (^ self new)"

	^ self formatWithSelf: (methodsWithSingleReturn select: [ :method |
			   ASTHelper ifReturnReturnsSelfNew:
				   (ASTHelper getSingleReturn: method) ])
]

{ #category : 'type of methods' }
TypeMe class >> methodsReturnSmallInteger [
	"collect methods that we expect to return SmallInteger"

	^ self
		  format: ({ 'hash' } flatCollect: [ :aString |
				   self
					   methods: methodsWithSingleReturn
					   selectorEqualsString: aString ])
		  withType: #Number
]

{ #category : 'type of methods' }
TypeMe class >> methodsReturnString [
	"collect methods that we expect to return String"

	^ self
		  format: (methodsWithSingleReturn select: [ :method |
				   method selector endsWith: 'String' ])
		  withType: #String
]

{ #category : 'type of methods' }
TypeMe class >> methodsTypeExtractedFromName [
	"here we make some guesses on which type might a method return based on its selector name, 
if we can, we check that this information is correct"

	^ OrderedCollection new
		  addAll: (self methodsReturnBoolean);
		  addAll: (self methodsReturnString);
		  addAll: (self methodsReturnNumber);
		  addAll: (self methodsReturnSmallInteger);
		  yourself
]

{ #category : 'type of methods' }
TypeMe class >> methodsWithReturn [

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

{ #category : 'type of methods' }
TypeMe class >> methodsWithoutReturn [
	"their type correspond to the class of receiver"

	^ self formatWithSelf: (methods reject: [ :method |
			   ASTHelper ifMethodHasReturnStatements: method ast ])
]

{ #category : 'as yet unclassified' }
TypeMe class >> types [

	^ types
]
