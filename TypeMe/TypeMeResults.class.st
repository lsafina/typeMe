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
		  typeResults: typeResultsCollection;
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

{ #category : 'as yet unclassified' }
TypeMeResults >> resultsWithoutConflicts [

	| prefixesToRemove prefixSize |

	prefixSize := 3.
	prefixesToRemove :=
    (conflicts collect: [:arr | arr copyFrom: 1 to: prefixSize]) asSet.
	^ typeResults reject: [:arr |
    prefixesToRemove includes: (arr copyFrom: 1 to: prefixSize)].
]

{ #category : 'accessing' }
TypeMeResults >> typeResults [

	^ typeResults
]

{ #category : 'accessing' }
TypeMeResults >> typeResults: typeResultsCollection [

	typeResults := typeResultsCollection
]
