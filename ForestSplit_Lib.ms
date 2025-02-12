global ForestSplitRollout

struct ST_ForestSplit
(
	TOOLCODE = "Split",
	ForestClasses = #(#Forest, #Forest_Pro),

    /*
        Function: duplicateObject
        Duplicate a 3ds max object based on its name with an option to add a suffix, copy by default

        Parameters:
            objName (string) - The name of the object to duplicate.
            suffix (string) - The suffix.

        Example:
            duplicateObject "MyObject" "Suffix"
    */
    fn duplicateObject objName:undefined suffix:"copy" =
    (
        originalObj = getNodeByName objName

        if originalObj != undefined then (
            -- Construct the final name WITHOUT automatic increment
            newName = objName + "_" + suffix

            -- Check if an object with this name already exists
            existingObj = getNodeByName newName
            if existingObj != undefined then (
                print ("Error: An object named '" + newName + "' already exists.")
                return undefined
            )

            -- Duplicate the object and directly assign the new name
            newObj = copy originalObj
            newObj.name = newName

            -- print ("Duplicated object: " + newObj.name)
            return newObj
        ) else (
            print "Error: The specified object does not exist."
            return undefined
        )
    ),


    /*
        Function: getGlobalBoundingBoxWorld
        Calculates the global bounding box of a selection of objects.

        Parameters:
            objects (list) - List of the objects to calculate the bounding box.

        Example:
            getGlobalBoundingBoxWorld
    */
    fn getGlobalBoundingBoxWorld =
    (
        if selection.count > 0 then (
            local minPt = [1e9, 1e9, 1e9] -- Very large initial values
            local maxPt = [-1e9, -1e9, -1e9] -- Very small initial values

            for obj in selection do (
                local bb = nodeGetBoundingBox obj obj.transform -- Returns an array with min and max

                local bbMin = bb[1]
                local bbMax = bb[2]

                -- Convert the 8 corners of the bounding box to World Space
                local corners = #(
                    bbMin * obj.transform,
                    [bbMax.x, bbMin.y, bbMin.z] * obj.transform,
                    [bbMin.x, bbMax.y, bbMin.z] * obj.transform,
                    [bbMax.x, bbMax.y, bbMin.z] * obj.transform,
                    [bbMin.x, bbMin.y, bbMax.z] * obj.transform,
                    [bbMax.x, bbMin.y, bbMax.z] * obj.transform,
                    [bbMin.x, bbMax.y, bbMax.z] * obj.transform,
                    bbMax * obj.transform
                )

                -- Update the global bounding box
                for corner in corners do (
                    minPt.x = amin minPt.x corner.x
                    minPt.y = amin minPt.y corner.y
                    minPt.z = amin minPt.z corner.z

                    maxPt.x = amax maxPt.x corner.x
                    maxPt.y = amax maxPt.y corner.y
                    maxPt.z = amax maxPt.z corner.z
                )
            )

            return #(minPt, maxPt) -- Return the global bounding box in World Space
        ) else (
            print "No selection!"
            return undefined
        )
    ),


    /*
        Function: createBoundingCircle
        Create a circle that will be sized using a bouding box data. The circle will have a margin of the size (Percent).
        You also have to give it a name

        Parameters:
            marginPercent (integer) - The margin value in percent.
            name (string) - The name of the new created circle.

        Example:
            createBoundingCircle 20 "MyCircle"
    */
    fn createBoundingCircle marginPercent:0 name:undefined =
    (
        if selection.count > 0 then (
            -- Calculate the global bounding box
            local bbox = getGlobalBoundingBoxWorld()

            if bbox != undefined then (
                local minPt = bbox[1]
                local maxPt = bbox[2]

                -- Calculate the center of the bounding box
                local center = (minPt + maxPt) / 2.0

                -- Calculate the radius of the circle (half of the largest dimension)
                local size = amax #(maxPt.x - minPt.x, maxPt.y - minPt.y, maxPt.z - minPt.z)
                local radius = size / 2.0

                -- Apply margin (percentage)
                radius = radius * (1.0 + (marginPercent / 100.0))

                -- Create the sphere
                local circleObj = Circle radius:radius pos:center
                circleObj.name = name
                -- Return the sphere object
                return circleObj
            )
        ) else (
            print "No selection!"
            return undefined
        )
    ),

    /*
        Function: createSplitAreaCircle
		Creates the entry point needed circle 

        Parameters:
            radius (integer) - The radius of the circle
            name (string) - The name of the new created circle.
			pos (vec3) - The initial position of the circle
        Example:
            createSplitAreaCircle radius:1000 name:"SplitArea" pos:[0,0,0] 
    */
	fn createSplitAreaCircle radius:undefined name:undefined pos:undefined =
	(
		if (radius != undefined) and (name != undefined) and (pos != undefined) then
		(
			circleObject = Circle radius:radius pos:pos isSelected:on
			circleObject.name = name
		)
		
	),

	
    /*
        Function: addEditSplineModifier
        Adds a edit spline modifier to an object

        Parameters:
            objName (string) - The name of the object on which it will add the edit spline modifier.


        Example:
            addEditSplineModifier "MyObject"
    */
    fn addEditSplineModifier objName:undefined =
    (
        local obj = getNodeByName objName -- Find the object by name

        if obj != undefined then ( -- Check if the object exists
            local mod = Edit_Spline() -- Create the modifier
            addModifier obj mod -- Add it to the object
            print ("Edit_Spline modifier added to " + objName)
            return mod -- Return the added modifier
        ) else (
            print ("Error: Object '" + objName + "' does not exist in the scene!")
            return undefined
        )
    ),


    /*
        Function: attachSplines
        Gets two splines and attaches them.
        The splines need to be SplineShape type object.
        Parameters:
            baseSpline (node) - 3ds max object node as first spline
            targetSpline (node) - 3ds max object node as second spline

        Example:
            attachSplines "FirstSpline" "SecondSpline"
    */
    fn attachSplines baseSpline:undefined targetSpline:undefined =
    (
        if (isValidNode baseSpline and isValidNode targetSpline) then
        (
            if (classof baseSpline == SplineShape and classof targetSpline == SplineShape) then
            (
                addAndWeld baseSpline targetSpline 0.01 -- Attach with weld threshold
                print "Splines attached successfully."
            )
            else
            (
                print "Both objects must be Editable Splines."
            )
        )
        else
        (
            print "Invalid objects selected."
        )
    ),


    /*
        Function: layerExist
        Checks if a layer with the given name exists

        Parameters:
            layerName (string) - The layer name to check if it exists


        Example:
            layerExist "layerName"
    */
    fn layerExist layerName:undefined =
    (
        local layer = LayerManager.getLayerFromName layerName
        return (layer != undefined) -- Returns true if the layer exists, false otherwise
    ),


    /*
        Function: getLayerName
        Gets the layer name of an object.

        Parameters:
            objName (string) - The name of the object to get the layer info from.

        Example:
            getLayerName "MyObject"
    */
    fn getLayerName objName:undefined =
    (
        local obj = getNodeByName objName
        if obj != undefined then (
            return obj.layer.name
        ) else (
            print "Error: The specified object does not exist."
            return undefined
        )
    ),


    /*
        Function: getAllForestObjects
        Gets all the forest/ forest pro objects that exist in the current scene

        getAllForestObjects:
            getLayerName
    */
    fn getAllForestObjects =
    (
        local forestObjects = for obj in objects where (classof obj == Forest_Pro or classof obj == Forest) collect obj

        if forestObjects.count > 0 then
        (
            return forestObjects
            format "Selected % forest objects.\n" forestObjects.count
        )
        else
        (
            print "No Forest objects found in the scene."
        )
    ),


    /*
        Function: addSplineAreaToForest
        This will add a spline area to a forest / forest pro object.
        It will assign default settings based on split forest tool.

        Parameters:
            forestObj (forest_node) - The forest that will have a new created area.
            splineObj (spline_node) - The spline associated to the area.

        Example:
            addSplineAreaToForest forestObj splineObj
    */
    fn addSplineAreaToForest forestObj:undefined splineObj:undefined =
    (
        if (classof forestObj == Forest_Pro or classof forestObj == Forest) and classof splineObj SplineShape then
		(
            local index = forestObj.arnamelist.count + 1  -- Get next available index

            -- Expand area lists to accommodate new area
            forestObj.arnamelist.count = index
            forestObj.arnodelist.count = index
            forestObj.artypelist.count = index
            forestObj.arincexclist.count = index
            forestObj.arwidthlist.count = index
            forestObj.arflafdenslist.count = index
            forestObj.arflafscalist.count = index

            -- Refresh the values to display correctly
            refreshForestObject forestObj:forestObj index:index

            -- Assign values
            forestObj.arnamelist[index] = splineObj.name
            forestObj.arnodelist[index] = splineObj
            forestObj.artypelist[index] = 0  -- 0 = Spline Area
            forestObj.arincexclist[index] = 1  -- 1 = Exclude by default

            -- Default settings
            forestObj.arwidthlist[index] = 0  -- Thickness: 0
            forestObj.arflafdenslist[index] = 0  -- Falloff Density: Off
            forestObj.arflafscalist[index] = 0  -- Falloff Scale: Off

            -- Activate the area by default
            forestObj.pf_aractivelist[index] = 1

            forestObj.enabled = false
            forestObj.enabled = true

            format "Spline Area added: %\n" splineObj.name
        ) 
		else
		(
            print "Error: Invalid ForestPack object or Spline!"
        )
    ),


    /*
        Function: refreshForestObject
        This is needed to display correctly the new split forests

        Parameters:
            forestObj (string) - The forest object to update.
            index (integer) - The index of the area of the object to refresh

        Example:
            refreshForestObject forestObj index
    */
    fn refreshForestObject forestObj:undefined index:undefined =
    (
            forestObj.aridlist.count = index
            forestObj.arnodenamelist.count = index
            forestObj.arnodenamelist[index] = ""
            forestObj.arresollist.count = index
            forestObj.arslicelist.count = index
            forestObj.arslicetoplist.count = index
            forestObj.arforceopenlist.count = index
            forestObj.armaplist.count = index
            forestObj.arscalelist.count = index
            forestObj.arthresholdlist.count = index
            forestObj.arselspeclist.count = index
            forestObj.arspeclist.count = index
            forestObj.arspeclist[index] = ""
            forestObj.arpaintlist.count = index
            forestObj.arflinvlist.count = index
            forestObj.arboundchecklist.count = index
            forestObj.arshapelist.count = index
            forestObj.arobscalelist.count = index
            forestObj.arsurfidlist.count = index
            forestObj.arsurfidlist[index] = ""
            forestObj.arzoffset.count = index


        print "Forest object is now refreshed"
    ),


    /*
        Function: removeForestSplines
        This will remove areas based on key words passed from a list of keywords.

        Parameters:
            forestObj (string) - The forest object from which it will remove an area.
            areaNamesToRemove (string) - The name of the target layer.

        Example:
            removeForestSplines forestObj #('keyword1', 'keyword2')
    */
    fn removeForestSplines forestObj:undefined areaNamesToRemove:undefined =
    (

        for i = forestObj.arnamelist.count to 1 by -1 do
        (
            if (findString areaNamesToRemove forestObj.arnamelist[i]) != undefined do
            (
                forestObj.arnamelist.count -= 1
                forestObj.arnodelist.count -= 1
                forestObj.artypelist.count -= 1
                forestObj.arincexclist.count -= 1
            )
        )

        print "Specified Forest spline areas removed."
    ),


    /*
        Function: moveObjectToLayer
        Moves an object to a specific scene layer. If the layer does not exist, it creates one.

        Parameters:
            objName (string) - The name of the object to move.
            layerName (string) - The name of the target layer.

        Example:
            moveObjectToLayer "MyObject" "MyLayer"
    */
    fn moveObjectToLayer objName:undefined layerName:undefined =
    (
        local obj = getNodeByName objName
        if obj != undefined then
		(
            local targetLayer = LayerManager.getLayerFromName layerName

            -- If the layer does not exist, create it
            if targetLayer == undefined then
			(
                targetLayer = LayerManager.newLayerFromName layerName
            )

            -- Add the object to the new layer
            targetLayer.addNode obj

            format "Object '%' has been moved to layer '%'.\n" obj.name layerName
        ) else
		(
            print "Error: The specified object does not exist."
        )
    ),


    /*
        Function: linkObjectToParent
        Make a simple parent/child link 3ds max native.

        Parameters:
            objName (string) - The name of the object to move.
            layerName (string) - The name of the target layer.

        Example:
            linkObjectToParent "MyObject" "MyLayer"
    */
    fn linkObjectToParent childName:undefined parentName:undefined =
    (
        local child = getNodeByName childName
        local parent = getNodeByName parentName

        if child != undefined and parent != undefined then
		(
            child.parent = parent
            format "Object '%' is now a child of '%'.\n" child.name parent.name
        ) else (
            print "Error: One of the objects does not exist."
        )
    ),


    /*
        Function: getNodesFromLayerName
        Get a list of the nodes that are under a specified layer.

        Parameters:
            layerName (string) - The layer from which we are going to look for object.

        Example:
            getNodesFromLayerName "MyObject" "MyLayer"
    */
    fn getNodesFromLayerName layer_name:undefined =
    (
        local nodes
        (LayerManager.getLayerFromName layer_name).nodes &nodes
        return nodes
    ),


    /*
        Function: deleteSplit
        Deletes the split setup based on a layer name. because split setup creates all the nodes inside a specified layer.

        Parameters:
            layerName (string) - The name of the split tool layer.

        Example:
            deleteSplit "SplitSetupLayer"
    */
    fn deleteSplit layerName:undefined =
    (
        local layer = LayerManager.getLayerFromName layerName
        local nodes

		if layer == undefined do
		(
			print "No Forest Split setup to delete"
			return undefined
		)
		layer.nodes &nodes

		for obj in objects do
		(
			if (classof obj == Forest_Pro or classof obj == Forest) do
			(
				removeForestSplines forestObj:obj areaNamesToRemove:(TOOLCODE + "Area")
			)
		)
			
        delete nodes
        LayerManager.deleteLayerByName layerName
    ),


    /*
        Function: createSplit
        The script to create the whole setup.
        1 - Needs a closed spline called 'SplitArea', in the scene (Concatenation TOOLCODE + "Area")
        2 - Needs a selection of forest objects, in the scene

        Example:
            createSplit
    */

    fn createSplit =
    (
        -- Check of a split setup already exists
        splitSetupExists = layerExist layerName:TOOLCODE
        if splitSetupExists == true then
		(
            print "A split Setup already exists , you have to delete it first , only one setup is allowed for the moment."
            return undefined
        )


        forestObjects = selection -- Original forest that will be split
        -- Remove all the elements that are not a forest objet then check if the list is not empty

        forestObjects = for obj in forestObjects where (classof obj == Forest_Pro or classof obj == Forest) collect obj
        if forestObjects.count == 0 then 
		(
            print "There is no valid selection, Forests, Process Stopped"
            return undefined
        )

        -- Manually created spline
        splitAreaObj = getNodeByName (TOOLCODE + "Area") -- The spline shape that will be used as area for splitting
		
        if splitAreaObj == undefined then 
		(
            print ("You need to create a closed spline named : " + (TOOLCODE + "Area"))
            return undefined
        )
		-- initialize splitArea Object (circle)
        addEditSplineModifier objName:splitAreaObj.name
        maxOps.CollapseNode splitAreaObj off
        moveObjectToLayer objName:splitAreaObj.name layerName:TOOLCODE

        -- Spline Duplicate and default params
        splitAreaObjToMerge = duplicateObject objName:splitAreaObj.name suffix:TOOLCODE -- Duplicate of the area because it is needed in the split process
        addEditSplineModifier objName:splitAreaObjToMerge.name
        maxOps.CollapseNode splitAreaObjToMerge off
        moveObjectToLayer objName:splitAreaObjToMerge.name layerName:TOOLCODE

        -- Surround Spline Bbox size and default params
        surroundAreaObj = createBoundingCircle marginPercent:10 name:(TOOLCODE + "Area" + "Surround") -- Create a circle around the bounding box of the selection with a margin
        surroundAreaObj.isHidden = true -- Hiding the surrounding area spline because not needed by the artist
        addEditSplineModifier objName:surroundAreaObj.name
        maxOps.CollapseNode surroundAreaObj off
        moveObjectToLayer objName:surroundAreaObj.name layerName:TOOLCODE

        -- Attach splitAreaObjToMerge to surroundAreaObj (First duplicate of split area to the surround bbox spline)
        attachSplines baseSpline:surroundAreaObj targetSpline:splitAreaObjToMerge

        splitForestObj = #() -- Forest selection duplicate that will be used for the inside
        for forestObj in forestObjects do 
		(
            local newForestObj = duplicateObject objName:forestObj.name suffix:"AVP"
            moveObjectToLayer objName:newForestObj.name layerName:TOOLCODE
            append splitForestObj newForestObj

            addSplineAreaToForest forestObj:forestObj splineObj:splitAreaObj
            addSplineAreaToForest forestObj:newForestObj splineObj:surroundAreaObj
        )

        linkObjectToParent childName:surroundAreaObj.name parentName:splitAreaObj.name
        select splitAreaObj -- force update by selecting the spline that drives the whole setup

        print "Split process finished successfully"
    ),

	fn OpenForestSplitRollout =
	(
	    try (
	        destroyDialog ForestSplitRollout
	    ) catch()
		createdialog ForestSplitRollout
	)


)

ForestSplit = ST_ForestSplit()
