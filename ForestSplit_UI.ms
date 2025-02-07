global ForestSplit

try(
	destroyDialog OpenForestSplitRollout
)catch()

rollout ForestSplitRollout ("Forest Split " + FORESTSPLIT_VERSION)
(
	group "Imports" (
		button SplitBtn "Split"
	)
	on SplitBtn pressed do (
		print "Processing forest split"
		)
		else (
			messageBox "Can't find this shot render folder !"
		)
	)
)
