"
Baseline for Beacon - a slim logging engine based entirely on Announcements
"
Class {
	#name : 'BaselineOfTypeMe',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfTypeMe',
	#package : 'BaselineOfTypeMe'
}

{ #category : 'baselines' }
BaselineOfTypeMe >> baseline: spec [
	<baseline>

	spec for: #'common' do: [
		
		spec
			baseline: 'TypeInfoTools' 
			with: [ spec repository: 'github://JanBliznicenko/TypeInfoTools:main/src' ].
		
		
		spec 
			package: #'TypeMe'  with: [
				spec requires: #('TypeInfoTools')] ;
			package: #'TypeMe-Tests' with: [
				spec requires: #('TypeMe'). ].
		spec 
			group: 'Core' with: #('TypeMe' 'TypeMe-Tests');
			group: 'default' with: #('TypeMe' 'TypeMe-Tests'). ].
]
