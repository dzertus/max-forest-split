global ForestSplit

try(
    destroyDialog ForestSplitRollout
)catch()

rollout ForestSplitRollout ("Forest Split " + FORESTSPLIT_VERSION)
(
    group "Display" (
        editText DisplayPercentage "Enter Value (0-100)" width:100
        button ApplyDisplayBtn "Apply" width:60
    )

    group "Split" (
        button SplitBtn "Split"
    )

    group "Delete" (
        button DeleteBtn "Delete"
    )

    -- Vérifie si la valeur entrée est correcte et l'applique
    on ApplyDisplayBtn pressed do
    (
        local value = DisplayPercentage.text as float
        if (value >= 0 and value <= 100) then
        (
            print ("Display Percentage Set to: " + value as string)
            -- Ici tu peux appeler une fonction pour appliquer ce pourcentage
        )
        else
        (
            messageBox "Please enter a value between 0 and 100" title:"Invalid Input"
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

createDialog ForestSplitRollout 400 200
