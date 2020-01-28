"
This class implements methodWrapper like behavior using the trick that the VM allows any object to be put in a method dictionary if it implements the run:with:in: method.

Here is a way to install a methodWrapper.

((RPackageOrganizer default packageNamed: 'BlueInk-Core') classes gather: [ :each | ObjectAsOneTimeMethodWrapper installOnClass: each ]) inspect

((RPackageOrganizer default packageNamed: 'BlueInk-Core') classes 
	do: [:each| ObjectAsMethodWrapper uninstallClass: each ]) 


Possible improvements:
	- it is not clear that specifying pre and post action is better than a simple method as in the original MethodWrapper implementation. 

Questions: 
	- what is reference vs oldMethod (I would prefer to call it original method, spiedMethod)
	- I do not think that we need to have a RGMethodDefinition since we have all the information in the compiled method now. 
"
Class {
	#name : #ObjectAsMethodWrapper,
	#superclass : #Object,
	#instVars : [
		'oldMethod',
		'preblock',
		'postblock',
		'reference'
	],
	#category : #'MethodWrapperAsObject-ObjectAsMethodWrapper'
}

{ #category : #installing }
ObjectAsMethodWrapper class >> installOn: aClass selector: aSel [
	^ (self on: aClass selector: aSel) install; yourself
]

{ #category : #installing }
ObjectAsMethodWrapper class >> installOnClass: aClass [
	|someWrappers|
	someWrappers:=OrderedCollection new.
	aClass selectors do: [:aSymbol | someWrappers add: (self installOn: aClass selector: aSymbol)].
	aClass class selectors do: [:aSymbol | someWrappers add: (self installOn: aClass class selector: aSymbol)].
	^someWrappers
]

{ #category : #installing }
ObjectAsMethodWrapper class >> installOnClassCategory: aString [
	|someWrappers|
	someWrappers:= OrderedCollection new.
	(Smalltalk organization listAtCategoryNamed: aString) do: [:aClassName | 
		someWrappers addAll: (self installOnClass: (Smalltalk globals classNamed: aClassName)).
		].
	^someWrappers
	
]

{ #category : #'instance creation' }
ObjectAsMethodWrapper class >> on: aMethodReference [
	^ self new initializeFor: aMethodReference 
]

{ #category : #'instance creation' }
ObjectAsMethodWrapper class >> on: aClass selector: aSelector [
	^ self on: (RGMethodDefinition class: aClass selector: aSelector)
]

{ #category : #installing }
ObjectAsMethodWrapper class >> uninstallClass: aClass [
	aClass methodDict values do: [:e | (e isKindOf: self) ifTrue: [e uninstall]].
	aClass class methodDict values do: [:e | (e isKindOf: self) ifTrue: [e uninstall]].
]

{ #category : #installing }
ObjectAsMethodWrapper class >> uninstallClassCategory: aString [
	(Smalltalk organization listAtCategoryNamed: aString) do: [:aClassName | 
		self uninstallClass: (Smalltalk classNamed: aClassName)]
]

{ #category : #installing }
ObjectAsMethodWrapper class >> uninstallOnClassCategory: aString [
	(Smalltalk organization listAtCategoryNamed: aString) do: [:aClassName | 
		self uninstallClass: (Smalltalk classNamed: aClassName)]
]

{ #category : #'handling DNU' }
ObjectAsMethodWrapper >> doesNotUnderstand: aMessage [

	^ oldMethod isNil
		ifTrue: [super doesNotUnderstand: aMessage]
		ifFalse: [oldMethod perform: aMessage selector withArguments: aMessage arguments]
]

{ #category : #action }
ObjectAsMethodWrapper >> flushCache [
	self flag: #Question. "what is this"
	self selector flushCache 
]

{ #category : #initialization }
ObjectAsMethodWrapper >> initialize [
	preblock := [:aSel :someArgs :aRec | nil].
	postblock := [:aSel :someArgs :aRec | nil].
]

{ #category : #initialization }
ObjectAsMethodWrapper >> initializeFor: aMethodReference [
 
	reference := aMethodReference
]

{ #category : #action }
ObjectAsMethodWrapper >> install [
	[oldMethod := self wrappedClass lookupSelector: self selector.
	oldMethod isKindOf: self class] whileTrue: [oldMethod uninstall].
	"self wrappedClass addSelector: self selector withMethod: self" 
	self wrappedClass methodDict at: self selector put: self
]

{ #category : #accessing }
ObjectAsMethodWrapper >> oldMethod [

	^ oldMethod
]

{ #category : #accessing }
ObjectAsMethodWrapper >> oldMethod: anObject [

	oldMethod := anObject
]

{ #category : #accessing }
ObjectAsMethodWrapper >> postblock [

	^ postblock
]

{ #category : #accessing }
ObjectAsMethodWrapper >> postblock: anObject [

	postblock := anObject
]

{ #category : #accessing }
ObjectAsMethodWrapper >> preblock [

	^ preblock
]

{ #category : #accessing }
ObjectAsMethodWrapper >> preblock: anObject [

	preblock := anObject
]

{ #category : #accessing }
ObjectAsMethodWrapper >> reference [
	^ reference 
]

{ #category : #action }
ObjectAsMethodWrapper >> run: aSelector with: arguments in: aReceiver [

	| aResult |
	preblock value: aSelector value: arguments value: aReceiver.
	aResult := oldMethod valueWithReceiver: aReceiver arguments: arguments.
	postblock value: aSelector value: arguments value: aReceiver.
	^ aResult
	
]

{ #category : #accessing }
ObjectAsMethodWrapper >> selector [

	^ reference selector
]

{ #category : #action }
ObjectAsMethodWrapper >> uninstall [

	oldMethod isNil ifTrue: [^self].
	"self wrappedClass removeSelectorSilently: self selector.
	self wrappedClass addSelector: self selector withMethod: oldMethod.
	"
	self wrappedClass methodDict at: self selector put: oldMethod  


]

{ #category : #accessing }
ObjectAsMethodWrapper >> wrappedClass [

	^ reference parent
]
