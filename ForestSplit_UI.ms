global ForestSplit

try(
	destroyDialog ForestSplitRollout
)catch()

rollout ForestSplitRollout ("Forest Split " + FORESTSPLIT_VERSION)
(
    group "Display" (
        button DisplayNoneBtn "None"
        button DisplayHalfBtn "Half"
        button DisplayFullBtn "Full"
    )
	group "Split" (
		button SplitBtn "Split"
	)
	group "Delete" (
		button DeleteBtn "Delete"
	)
	
	on SplitBtn pressed do (
		print "Processing forest split"
		ForestSplit.createSplit()
	)
    on DeleteBtn pressed do (
		print "Deleting Forest Split Setup"
		ForestSplit.deleteSplit layerName:"Split"
	)
)
