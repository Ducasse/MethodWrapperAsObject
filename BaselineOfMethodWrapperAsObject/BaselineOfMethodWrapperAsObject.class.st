Class {
	#name : #BaselineOfMethodWrapperAsObject,
	#superclass : #BaselineOf,
	#category : #BaselineOfMethodWrapperAsObject
}

{ #category : #baselines }
BaselineOfMethodWrapperAsObject >> baseline: spec [
	<baseline>
	spec for: #common do: [ 
			spec package: 'MethodWrapperAsObject'.
			spec 
				package: 'MethodWrapperAsObject-Tests' 
				with: [ spec requires: #('MethodWrapperAsObject') ].
				
			spec 
				group: 'default' with: #(core development);
				group: 'core' with: #('MethodWrapperAsObject' );
				group: 'development' with: #('MethodWrapperAsObject')]
]
