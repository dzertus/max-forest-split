global ForestSplit

try (
    destroyDialog ForestSplitRollout
) catch()

rollout ForestSplitRollout ("Forest Split " + FORESTSPLIT_VERSION)
(
    group "Display" (
        editText DisplayPercentage "Enter Value (0-10000)" width:200
        button ApplyDisplayBtn "Apply" width:80
    )

    group "Split" (
        button SplitBtn "Split"
    )

    group "Delete" (
        button DeleteBtn "Delete"
    )

    -- Function to select all the objects of type #Forest ou #Forest_Pro
    fn getForestObjects =
    (
        local forestClasses = #(#Forest, #Forest_Pro)
        local forestObjects = for obj in objects where (findItem forestClasses (classof obj) == 0) collect obj
        select forestObjects
        return forestObjects
    )

    -- Function to apply density to displayViewport
    fn applyDensityToForests densityValue =
    (
        local forests = getForestObjects()
        if forests.count > 0 then
        (
            for f in forests do
            (
                try
                (
                    f.vmaxitems = densityValue
                    print ("Applied " + (densityValue as string) + " to " + f.name)
                )
                catch (format "Error applying density to: %\n" f.name)
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

        if value != undefined and value >= 0 and value <= 10000 then
        (
            applyDensityToForests value
        )
        else
        (
            messageBox "Please enter a valid number between 0 and 10000" title:"Invalid Input"
        )
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

createDialog ForestSplitRollout 450 250
