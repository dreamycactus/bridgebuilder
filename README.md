bridgebuilder
=============

SMALL TODO
- Fix compression beam snapping

BIG TODO
- Prototype non-shearing graphics- hi res texture scaled down	

BBB Project Overview

Mechanics
========
- A bridge is constructed out of beams. The beams that are designated 'road' have collision with the car via InteractionFilters.
- All beams undergo one (or more) of three forces: Compression, tension, shear
-- Compression and tension are forces that are parallel to the x-axis of a beam. Negative direction for compression, positive for tension.
-- Shear is the force that is perpendicular to the x-axis of a beam times half the length of the beam. This value is the shear force at the center of the beam. Technically it may be called moment, but I'm calling it shear.
- Force is calculated through the nape api for joints/constraints.
- A special point is that force is only calculated at the center of each beam, even though it's not necessarily the case that the center is under the greatest stress for all situations
- Each beam can be made from certain materials with different thresholds for these forces and other properties (density, friction)
- When a force exceeds the threshold set for its material, the beam is flagged to snap. Snapping a beam involves deleting the beam and spawning 2 smaller beams joined in the middle with an elastic joint.
- Depending on which force caused the beam to break, the beam may snap in slightly different ways
- Cable is a special case- comprised of multiple connected beams (similar to 'snapped' beams), and can only feel tensile forces
- Cars will spawn when the physics simulation starts, and the win condition for most levels will be the arrival of all cars at an 'end zone'

Classes
=======
BuildHistory - history state machine to allow undos during bridge construction. Contains a lot of logic that should be in copy constructors. Can be rewritten, but seems to work ok
BuildMat - building material- contains properties for a beam material
Camera - drag, zoom for the level
CmpAnchor - physics component- a static body intended for a sturdy base from which the bridge foundation is built on. The 'start' and 'end' ground.
CmpBeam - physics component for beam. Snaps itself when force threshold reached
CmpCable - phy cmp for cable. Shortens and lengthens itself (does not happen in nature) to balance forces
CmpControl- weird cmp base class. Intended for any cmp that provides input to an entity
CmpControlBuild- where all the UI and bridge building logic happens. Biggest class
CmpControlCar- provides AI logic for the cars. Pretty simple currently
CmpEnd- end zone for cars
CmpGrid- grid.
CmpLevel- all data for a level
CmpMover- anything that can drive on a bridge pretty much.
CmpMultiBeam- the snapped state of a CmpBeam. Contains polygon spliiting logic. pretty convoluted code because splitting does not seem to be 100% reliable
CmpObjective- goals and other stats for a level. E.g. CmpObjectiveBudget keeps track of how much money you spent building a bridge, and also displays it to you
CmpRender-
	Bg*- background pieces
	ControlBuild- Currently only draws a line...
	ControlUI- UIButtons
	Grid- draws grid
CmpSharedJoint- phys cmp a circle that allows two beams to join. Each beam joins to the circle, hence does not directly connect to another beam. -----O-----
CmpSpawn- location where cars spawn
EntFactory-entity templates
GameConfig-game constaints, some helper function, AND the logic which sets ancestor relationship for components
LineChecker-class which constrains bridge beams to non-overlapping and non-parallel beams


	

