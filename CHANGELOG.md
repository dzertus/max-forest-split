## VERSIONS

### 0.2.9
- Add : CreateRenderLightLinkFromSelection search for FullBody in addition of Corps

### 0.2.8
- Add : Import exclude list log in warning if file do not exist instead of error

### 0.2.7
- Add : macro CreateRenderLightLink

### 0.2.6
- Fix : Replace Lights now also executes Import Excl/Ind Lists

### 0.2.5
- Fix : Error with sequence/shot in ExportLightsFBX

### 0.2.4
- [POAT/LB] And VolumeLight* to LightsPatterns

### 0.2.3
- Add : only selected option for vraylights include/exclude

### 0.2.2
- Add : import vraylights include/exclude take shot name text if not empty

### 0.2.1
- Fix : export/import vraylights include/exclude lists error when undefined in list

### 0.2.0
- Add : buttons to export/import vraylights include/exclude lists

### 0.1.9
- Change : Local Config

### 0.1.8
- Change :  PopulateFirelights randomize VrayLight 

### 0.1.7
- Change : LightPopulate wont crash anymore after re opening scene

### 0.1.6
- Add : SyncVrayProxyVRVG on populate firelights

### 0.1.5
- Change : Light populate now check by default L01 to L05 even if there is no light

### 0.1.4
- Fix : Refresh Passtech render elements when adding new AOV 
- Add : LightMix added to lightpopulate pass pool

### 0.1.3
- Add : confo for episode name

### 0.1.2
- Add : Replace lighting from shot

### 0.1.1
- Add : publish tool
- Add : PopulateFirelights generic method based on file patterns

### 0.1.0
- Add : Argo Populate Firelight

### 0.0.9:
- Add : ExportFolder config externalisation

### 0.0.8:
- Add : lights for chandelier and chandelierpied

### 0.0.7:
- Update : export one FBX file per light.
- Fix : bake light parent animation before exporting light.

### 0.0.6:
- Update : rename buttons
- Fix : export fbx copy light controller instead of parent in order to add keys

### 0.0.5:
- Add : export fbx scene lights

### 0.0.4
- Update : rename box light into ExportBox.
- Add : button to create export box for all lights in scene.
- Update : export boxes are now created in a layer called "Technique" and configured not to be renderable.
- Add : new button to export all light boxes into alembic.

### 0.0.3
- Add : new button to create VRayLightSelect render elements  for a new light.
- Add : new button to populate VrayLightSelect render elements.

### 0.0.2 
- Add : populate torche instance
- Add : makeUniqueSeed after populate torches

### 0.0.1 
- Init : make unique seed, create box light, populate torches
