"
This class is a bit strange since it keeps track whether a wrapper has been executed but when runs it is uninstall. So by construction there is no need to track that the method wrapper has been executed or not. When it is installed it is not.
Did I get something wrong?
S. Ducasse
"
Class {
	#name : #ObjectAsOneTimeMethodWrapper,
	#superclass : #ObjectAsMethodWrapper,
	#instVars : [
		'executed'
	],
	#category : #'MethodWrapperAsObject-ObjectAsMethodWrapper'
}

{ #category : #accessing }
ObjectAsOneTimeMethodWrapper >> executed [

	^ executed
]

{ #category : #accessing }
ObjectAsOneTimeMethodWrapper >> executed: anObject [
	"Set the value of executed"

	executed := anObject
]

{ #category : #initialization }
ObjectAsOneTimeMethodWrapper >> initialize [

	super initialize.
	executed := false
]

{ #category : #action }
ObjectAsOneTimeMethodWrapper >> run: aSelector with: arguments in: aReceiver [

	| aRes |
	aRes := super run: aSelector with: arguments in: aReceiver.
	[self executed: true]
		ensure: [self uninstall].
	^aRes
]
