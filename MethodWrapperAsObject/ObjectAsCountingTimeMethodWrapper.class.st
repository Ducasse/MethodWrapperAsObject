"
I'm a simple wrapper that counts the number of execution of the wrapped method.
"
Class {
	#name : #ObjectAsCountingTimeMethodWrapper,
	#superclass : #ObjectAsMethodWrapper,
	#instVars : [
		'counter'
	],
	#category : #'MethodWrapperAsObject-ObjectAsMethodWrapper'
}

{ #category : #examples }
ObjectAsCountingTimeMethodWrapper class >> examplePixelValueAt [
	self installOn: Form selector: #pixelValueAt:
]

{ #category : #testing }
ObjectAsCountingTimeMethodWrapper >> counter [

	^ counter
]

{ #category : #testing }
ObjectAsCountingTimeMethodWrapper >> executed [

	^ counter > 0 
]

{ #category : #initialization }
ObjectAsCountingTimeMethodWrapper >> initialize [
	super initialize.
	counter := 0.
	postblock := [:aSel :someArgs :aRec | counter := counter + 1]
]
