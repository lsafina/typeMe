Class {
	#name : 'TypeMeNameBased',
	#superclass : 'TypeMe',
	#category : 'TypeMe-Objects',
	#package : 'TypeMe',
	#tag : 'Objects'
}

{ #category : 'instance creation' }
TypeMeNameBased >> initialize [

	super initialize.
	heuristics := Set withAll: #(#methodsReturnBoolean #methodsReturnNumber #methodsReturnSmallInteger #methodsReturnString).
]
