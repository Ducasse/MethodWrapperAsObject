Class {
	#name : #ObjectAsOneTimeMethodWrapperTest,
	#superclass : #TestCase,
	#instVars : [
		'preExecuted',
		'postExecuted'
	],
	#category : #'MethodWrapperAsObject-Tests'
}

{ #category : #accessing }
ObjectAsOneTimeMethodWrapperTest >> postExecuted [
	"Answer the value of postExecuted"

	^ postExecuted
]

{ #category : #accessing }
ObjectAsOneTimeMethodWrapperTest >> postExecuted: anObject [
	"Set the value of postExecuted"

	postExecuted := anObject
]

{ #category : #accessing }
ObjectAsOneTimeMethodWrapperTest >> preExecuted [
	"Answer the value of preExecuted"

	^ preExecuted
]

{ #category : #accessing }
ObjectAsOneTimeMethodWrapperTest >> preExecuted: anObject [
	"Set the value of preExecuted"

	preExecuted := anObject
]

{ #category : #running }
ObjectAsOneTimeMethodWrapperTest >> testInstallOn [
	"self run: #testInstallOn"
	|aWrapper|
	aWrapper := ObjectAsOneTimeMethodWrapper installOn: ObjectAsMethodWrapperDummy selector: #foo.
	aWrapper preblock: [:aSel :someArgs :aRec | self preExecuted:true].
	aWrapper postblock: [:aSel :someArgs :aRec | self postExecuted:true].
	[self assert: (ObjectAsMethodWrapperDummy new foo = 1).
	self assert: aWrapper executed.
	self assert: preExecuted.
	self assert: postExecuted] ensure: [aWrapper uninstall].
	^aWrapper
]

{ #category : #running }
ObjectAsOneTimeMethodWrapperTest >> testInstallOnClassCategory [
	"self run: #testInstallOnClassCategory"
	| someWrappers |
	someWrappers := ObjectAsOneTimeMethodWrapper installOnClassCategory: 'MethodWrappers-Dummies'.
	[self assert: (ObjectAsMethodWrapperDummy new foo = 1).
	self assert: (someWrappers anySatisfy: [:e | e executed not]).
	self assert: (ObjectAsMethodWrapperDummy new bar = 2).
	self assert: (someWrappers allSatisfy: [:e | e executed])] ensure: [someWrappers do: [:e | e uninstall]].
	^someWrappers
]
