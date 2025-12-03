"
Strict verstion of TypeMe that runs only confident ast-based heuristics that yelds correct by construction results
"
Class {
	#name : 'TypeMeConfident',
	#superclass : 'TypeMe',
	#category : 'TypeMe-Objects',
	#package : 'TypeMe',
	#tag : 'Objects'
}

{ #category : 'initialization' }
TypeMeConfident >> initialize [

	super initialize.
	heuristics := Set withAll: #(#methodsReturnClass #methodsReturnClassNew #methodsReturnLiteralNode #methodsReturnNil #methodsReturnSelf #methodsReturnSelfNew).
]
