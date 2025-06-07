Class {
	#name : 'TypeMeResults',
	#superclass : 'Object',
	#instVars : [
		'typeResults',
		'conflicts'
	],
	#category : 'TypeMe-Objects',
	#package : 'TypeMe',
	#tag : 'Objects'
}

{ #category : 'instance creation' }
TypeMeResults class >> withResults: typeResultsCollection conflicts: conflictsCollection [

	^ self new
		  results: typeResultsCollection;
		  conflicts: conflictsCollection;
		  yourself
]

{ #category : 'accessing' }
TypeMeResults >> conflicts [

	^ conflicts
]

{ #category : 'accessing' }
TypeMeResults >> conflicts: conflictCollection [

	conflicts := conflictCollection
]

{ #category : 'accessing' }
TypeMeResults >> typeResults [

	^ typeResults
]

{ #category : 'accessing' }
TypeMeResults >> typeResults: typeResultsCollection [

	typeResults := typeResultsCollection
]
