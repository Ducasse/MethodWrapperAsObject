Extension { #name : #Class }

{ #category : #'*MethodWrapperAsObject' }
Class >> unwrapAllMethods [
	^ObjectAsMethodWrapper uninstallClass: self
]

{ #category : #'*MethodWrapperAsObject' }
Class >> wrapAllMethods [
	^ObjectAsOneTimeMethodWrapper installOnClass: self
]

{ #category : #'*MethodWrapperAsObject' }
Class >> wrappedMethods [
	|someMethods|
	someMethods:= Set new.
	someMethods addAll: (self methodDictionary values select: [:e | e isKindOf: ObjectAsMethodWrapper ]).
	someMethods addAll: (self class  methodDictionary values select: [:e | e isKindOf: ObjectAsMethodWrapper ]).
	^someMethods
]
