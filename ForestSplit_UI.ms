global ForestSplit
global ForestSplit_Lib

try (
    destroyDialog ForestSplitRollout
) catch()

global maxDenityValue = 100000

rollout ForestSplitRollout ("Forest Split " + FORESTSPLIT_VERSION)
(
    group "Display" (
        editText DisplayPercentage "Viewport max Items (0-1000000) " width:400 tooltip:"0 --> Infinite"

        radiobuttons Mode labels:#("Mesh", "Proxy")

        button ApplyDisplayBtn "Apply" width:80
    )

    group "Split" (
        button SplitBtn "Split"
    )
	
    group "Create" (
        button CreateBtn "Create Split Area"
    )
	
    group "Delete" (
        button DeleteBtn "Delete"
    )

    -- Function to apply density to displayViewport
    fn applyDensityToForests densityValue =
    (
        local forests = ForestSplit.getAllForestObjects()
        if forests.count > 0 then
        (
            for f in forests do
            (
                -- Set mode
                if (Mode.state == 1) then
                (
                    f.vmesh = 0
                    if densityValue == 0 do
                    (
                        densityValue = maxDenityValue
                    )

                )
                else if (Mode.state == 2) then
                (
                    f.vmesh = 1
                )
                -- Set max items value
                f.vmaxitems = densityValue
                print ("Applied " + (densityValue as string) + " to " + f.name)
            )
        )
        else
        (
            messageBox "No Forest objects found in the scene!" title:"No Forests Found"
        )
    )
    -- Checks if the entered value is correct and applies it to vmaxitems attribute
    on ApplyDisplayBtn pressed do
    (
        local value = try (DisplayPercentage.text as float) catch (undefined)

        if value != undefined and value >= 0 and value <= maxDenityValue then
        (
            applyDensityToForests value
        )
        else
        (
            messageBox "Please enter a valid number between 0 and 100000" title:"Invalid Input"
        )
    )

    on CreateBtn pressed do
    (
		print "Creating Split Area"
		ForestSplit.createSplitAreaCircle radius:1000 name:(ForestSplit.TOOLCODE + "Area") pos:[0,0,0]
	)
	
    on SplitBtn pressed do 
	(
        print "Processing forest split"
        ForestSplit.createSplit()
    )

    on DeleteBtn pressed do 
	(
        print "Deleting Forest Split Setup"
        ForestSplit.deleteSplit layerName:ForestSplit.TOOLCODE
    )
)

createDialog ForestSplitRollout 450 250
