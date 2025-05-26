"
This class stores methods to send requests to several LLM models, openAI, Mistral etc
"
Class {
	#name : 'TypeWithAI',
	#superclass : 'Object',
	#classInstVars : [
		'apiOpenAI',
		'apiMistral'
	],
	#category : 'TypeMe',
	#package : 'TypeMe'
}

{ #category : 'as yet unclassified' }
TypeWithAI class >> apiMistral [

	^ apiMistral ifNil: [
		  apiMistral := LLMAPI chat.
		  apiMistral host: 'api.mistral.ai'.
		  apiMistral apiKey: ''.

		  apiMistral payload
			  temperature: 0.5;
			  model: 'mistral-small-latest';
			  top_p: 1;
			  max_tokens: 250 ]
]

{ #category : 'accessing' }
TypeWithAI class >> apiOpenAI [

	^ apiOpenAI ifNil: [
		  apiOpenAI := LLMAPI chat.
		  apiOpenAI host: 'api.openai.com'.
		  apiOpenAI apiKey: ''.

		  apiOpenAI payload
			  temperature: 0.5;
			  model: 'o3-mini';
			  top_p: 1;
			  max_tokens: 250 ]
]

{ #category : 'as yet unclassified' }
TypeWithAI class >> askMistral: prompt [

	apiMistral payload messages: { (LLMAPIChatObjectMessage role: 'user' content: prompt) }.
	^ apiMistral performRequest
]

{ #category : 'as yet unclassified' }
TypeWithAI class >> askOpenAI: prompt [

	self apiOpenAI payload messages:
		{ (LLMAPIChatObjectMessage role: 'user' content: prompt) }.
	^ apiOpenAI performRequest
]
