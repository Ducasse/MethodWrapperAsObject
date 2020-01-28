Class {
	#name : #TestCoverageMethodWrapper,
	#superclass : #ObjectAsMethodWrapper,
	#instVars : [
		'hasRun'
	],
	#category : #'MethodWrapperAsObject-ObjectAsMethodWrapper'
}

{ #category : #accessing }
TestCoverageMethodWrapper >> hasRun [
	^ hasRun 
]

{ #category : #initialization }
TestCoverageMethodWrapper >> initialize [
	super initialize.
	hasRun := false.
	postblock := [:aSel :someArgs :aRec |
			hasRun := true. 
			self uninstall.
			].
]
