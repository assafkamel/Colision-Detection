unit math3d;

interface
uses OpenGL,Math,glTypes;



  function Normalize(vNormal: TCoord): TCoord;
  function Magnitude(vNormal : TCoord) : GLfloat;
  function Cross(vVector1,  vVector2 : TCoord) : TCoord;
  function Vector( vPoint1, vPoint2 : TCoord) : TCoord;
  function PlaneDistance(Normal, Point :TCoord) : GLfloat;
  function Normal(vTriangle : array of TCoord) : TCoord;
  function IntersectedPlane(vPoly, vLine : array of TCoord; vNormal : TCoord; var originDistance : GLfloat) : Boolean;
  function Dot(vVector1, vVector2 : TCoord) : glFloat;
  function AngleBetweenVectors(Vector1, Vector2 :TCoord) : real;
  function InsidePolygon(vIntersection : TCoord; Poly :array of TCoord; verticeCount : integer) : boolean;
  function IntersectionPoint(vNormal : TCoord; vLine : array of TCoord; distance : glFloat) : TCoord;
  function IntersectedPolygon(vPoly : array of TCoord; vLine : array of TCoord; verticeCount : integer):boolean;


implementation



/////////////////////////////////////// NORMALIZE \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\*
/////
/////	This returns a normalized vector (A vector exactly of length 1)
/////
/////////////////////////////////////// NORMALIZE \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\*

//CVector3 Normalize(CVector3 vNormal)
//{
//	float magnitude = Magnitude(vNormal);				// Get the magnitude of our normal


//	vNormal.x /= magnitude;								// Divide the X value of our normal by it's magnitude
//	vNormal.y /= magnitude;								// Divide the Y value of our normal by it's magnitude
//	vNormal.z /= magnitude;								// Divide the Z value of our normal by it's magnitude

//	return vNormal;										// Return the new normal of length 1.
//}

function Normalize(vNormal: TCoord): TCoord;
var m_magnitude : GLfloat;
begin
	m_magnitude := Magnitude(vNormal);				// Get the magnitude of our normal

	// Now that we have the magnitude, we can divide our normal by that magnitude.
	// That will make our normal a total length of 1.  This makes it easier to work with too.

	vNormal.x := vNormal.x/m_magnitude;								// Divide the X value of our normal by it's magnitude
	vNormal.y := vNormal.y/m_magnitude;								// Divide the Y value of our normal by it's magnitude
	vNormal.z := vNormal.z/m_magnitude;								// Divide the Z value of our normal by it's magnitude

	// Finally, return our normalized normal.

	result := vNormal;										// Return the new normal of length 1.
end;

/////////////////////////////////////// CROSS \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\*
/////
/////	This returns a perpendicular vector from 2 given vectors by taking the cross product.
/////
/////////////////////////////////////// CROSS \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\*

//CVector3 Cross(CVector3 vVector1, CVector3 vVector2)
//{
//	CVector3 vNormal;

//	vNormal.x = ((vVector1.y * vVector2.z) - (vVector1.z * vVector2.y));

//	vNormal.y = ((vVector1.z * vVector2.x) - (vVector1.x * vVector2.z));

//	vNormal.z = ((vVector1.x * vVector2.y) - (vVector1.y * vVector2.x));

//	return vNormal;										// Return the cross product ,Direction the polygon is facing - Normal
//}


function Cross(vVector1,  vVector2 : TCoord) : TCoord;
var
  vNormal : TCoord;// The vector to hold the cross product
begin

	// Once again, if we are given 2 vectors (directions of 2 sides of a polygon)
	// then we have a plane define.  The cross product finds a vector that is perpendicular
	// to that plane, which means it's point straight out of the plane at a 90 degree angle.

	// The X value for the vector is:  (V1.y * V2.z) - (V1.z * V2.y)													// Get the X value
	vNormal.x := ((vVector1.y * vVector2.z) - (vVector1.z * vVector2.y));

	// The Y value for the vector is:  (V1.z * V2.x) - (V1.x * V2.z)
	vNormal.y := ((vVector1.z * vVector2.x) - (vVector1.x * vVector2.z));

	// The Z value for the vector is:  (V1.x * V2.y) - (V1.y * V2.x)
	vNormal.z := ((vVector1.x * vVector2.y) - (vVector1.y * vVector2.x));

	result := vNormal;										// Return the cross product (Direction the polygon is facing - Normal)
end;

/////////////////////////////////////// VECTOR \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\*
/////
/////	This returns a vector between 2 points
/////
/////////////////////////////////////// VECTOR \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\*

//CVector3 Vector(CVector3 vPoint1, CVector3 vPoint2)
//{
//	CVector3 vVector = {0};

//	vVector.x = vPoint1.x - vPoint2.x;
//	vVector.y = vPoint1.y - vPoint2.y;
//	vVector.z = vPoint1.z - vPoint2.z;

//	return vVector;
//}

function Vector( vPoint1, vPoint2 : TCoord) : TCoord;
var
  vVector : TCoord;
begin
	vVector.X := 0.0; vVector.Y := 0.0;  vVector.Z := 0.0; // Initialize our variable to zero
  // In order to get a vector from 2 points (a direction) we need to
	// subtract the second point from the first point.

	vVector.x := vPoint1.x - vPoint2.x;					// Get the X value of our new vector
	vVector.y := vPoint1.y - vPoint2.y;					// Get the Y value of our new vector
	vVector.z := vPoint1.z - vPoint2.z;					// Get the Z value of our new vector

	result := vVector;										// Return our new vector
end;


/////////////////////////////////// PLANE DISTANCE \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\*
/////
/////	This returns the distance between a plane and the origin
/////
/////////////////////////////////// PLANE DISTANCE \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\*

//float PlaneDistance(CVector3 Normal, CVector3 Point)
//{
//	float distance = 0;

//	distance = - ((Normal.x * Point.x) + (Normal.y * Point.y) + (Normal.z * Point.z));

//	return distance;									// Return the distance
//}

function PlaneDistance(Normal, Point :TCoord) : GLfloat;
var
  distance : GLfloat;
begin
	distance := 0;									// This variable holds the distance from the plane to the origin

	// Use the plane equation to find the distance (Ax + By + Cz + D = 0)  We want to find D.
	// For more information about the plane equation, read about it in the function below (IntersectedPlane())
	// Basically, A B C is the X Y Z value of our normal and the x y z is our x y z of our point.
	// D is the distance from the origin.  So, we need to move this equation around to find D.
	// We come up with D = -(Ax + By + Cz)
														// Basically, the negated dot product of the normal of the plane and the point. (More about the dot product in another tutorial)
	distance := -1 * ((Normal.x * Point.x) + (Normal.y * Point.y) + (Normal.z * Point.z));
  //distance =  -    ((Normal.x * Point.x) + (Normal.y * Point.y) + (Normal.z * Point.z));//cpp code

	result := distance;									// Return the distance
end;

/////////////////////////////////////// NORMAL \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\*
/////
/////	This returns the normal of a polygon (The direction the polygon is facing)
/////
/////////////////////////////////////// NORMAL \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\*

//CVector3 Normal(CVector3 vTriangle[])
//{
//	CVector3 vVector1 = Vector(vTriangle[2], vTriangle[0]);
//	CVector3 vVector2 = Vector(vTriangle[1], vTriangle[0]);

//	CVector3 vNormal = Cross(vVector1, vVector2);

//	vNormal = Normalize(vNormal);

//	return vNormal;
//}


function Normal(vTriangle : array of TCoord) : TCoord;
var
  vVector1 : TCoord;
  vVector2 : TCoord;
  vNormal : TCoord;
begin														// Get 2 vectors from the polygon (2 sides), Remember the order!
  vVector1 := Vector(vTriangle[2], vTriangle[0]);
	vVector2 := Vector(vTriangle[1], vTriangle[0]);

	vNormal := Cross(vVector1, vVector2);		// Take the cross product of our 2 vectors to get a perpendicular vector

	// Now we have a normal, but it's at a strange length, so let's make it length 1.

	vNormal := Normalize(vNormal);						// Use our function we created to normalize the normal (Makes it a length of one)

	result := vNormal;										// Return our normal at our desired length
end;


/////////////////////////////////// INTERSECTED PLANE \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\*
/////
/////	This checks to see if a line intersects a plane
/////
/////////////////////////////////// INTERSECTED PLANE \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\*

//bool IntersectedPlane(CVector3 vPoly[], CVector3 vLine[], CVector3 &vNormal, float &originDistance)
//{
//	float distance1=0, distance2=0;						// The distances from the 2 points of the line from the plane

//	vNormal = Normal(vPoly);							// We need to get the normal of our plane to go any further

	// Let's find the distance our plane is from the origin.  We can find this value
	// from the normal to the plane (polygon) and any point that lies on that plane (Any vertice)
//	originDistance = PlaneDistance(vNormal, vPoly[0]);

	// Get the distance from point1 from the plane using: Ax + By + Cz + D = (The distance from the plane)

//	distance1 = ((vNormal.x * vLine[0].x)  +					// Ax +
//		         (vNormal.y * vLine[0].y)  +					// Bx +
//				 (vNormal.z * vLine[0].z)) + originDistance;	// Cz + D

	// Get the distance from point2 from the plane using Ax + By + Cz + D = (The distance from the plane)

//	distance2 = ((vNormal.x * vLine[1].x)  +					// Ax +
//		         (vNormal.y * vLine[1].y)  +					// Bx +
//				 (vNormal.z * vLine[1].z)) + originDistance;	// Cz + D

	// Now that we have 2 distances from the plane, if we times them together we either
	// get a positive or negative number.  If it's a negative number, that means we collided!
	// This is because the 2 points must be on either side of the plane (IE. -1 * 1 = -1).

//	if(distance1 * distance2 >= 0)			// Check to see if both point's distances are both negative or both positive
//	   return false;						// Return false if each point has the same sign.  -1 and 1 would mean each point is on either side of the plane.  -1 -2 or 3 4 wouldn't...

//	return true;							// The line intersected the plane, Return TRUE
//}

function IntersectedPlane(vPoly, vLine : array of TCoord; vNormal : TCoord; var originDistance : GLfloat) : Boolean;
var
  distance1 : GLfloat;
  distance2 : GLfloat;
begin
	distance1 := 0;
  distance2 := 0;						// The distances from the 2 points of the line from the plane


	vNormal := Normal(vPoly);							// We need to get the normal of our plane to go any further

  // Now that we have the normal, we need to calculate the distance our triangle is from the origin.
	// Since we would have the same triangle, but -10 down the z axis, we need to know
	// how far our plane is to the origin.  The origin is (0, 0, 0), so we need to find
	// the shortest distance our plane is from (0, 0, 0).  This way we can test the collision.
	// The direction the plane is facing is important (We know this by the normal), but it's
	// also important WHERE that plane is in our 3D space.  I hope this makes sense.

	// We created a function to calculate the distance for us.  All we need is the normal
	// of the plane, and then ANY point located on that plane.  Well, we have 3 points.  Each
	// point of the triangle is on the plane, so we just pass in one of our points.  It doesn't
	// matter which one, so we will just pass in the first one.  We get a single value back.
	// That is the distance.  Just like our normalized normal is of length 1, our distance
	// is a single value too.  It's like if you were to measure something with a ruler,
	// you don't measure it according to the X Y and Z of our world, you just want ONE number.


	// Let's find the distance our plane is from the origin.  We can find this value
	// from the normal to the plane (polygon) and any point that lies on that plane (Any vertice)
	originDistance := PlaneDistance(vNormal, vPoly[0]);

  // Now the next step is simple, but hard to understand at first.  What we need to
	// do is get the distance of EACH point from our plane.  Above we got the distance of the
	// plane to the point (0, 0, 0) which happens to be the origin, now we need to get a distance
	// for each point.  If the distance is a negative number, then the point is BEHIND the plane.
	// If the distance is positive, then the point is in front of the plane.  Basically, if the
	// line collides with the plane, there should be a negative and positive distance.  make sense?
	// If the line pierces the plane, it will have a negative distance and a positive distance,
	// meaning that a point will be on one side of the plane, and one point on the other.  But we
	// will do the check after this, first we need to get the distance of each point to the plane.

	// Now, we need to use something called the plane equation to get the distance from each point.
	// Here is the plane Equation:  (Ax + By + Cz + D = The distance from the plane)
	// If "The distance from the plane" is 0, that means that the point is ON the plane, which all the polygon points should be.
	// A, B and C is the Normal's X Y and Z values.  x y and z is the Point's x y and z values.
	// "the Point" meaning one of the points of our line.  D is the distance that the plane
	// is from the origin.  We just calculated that and stored it in "originDistance".
	// Let's fill in the equation with our data:

	// Get the distance from point1 from the plane using: Ax + By + Cz + D = (The distance from the plane)

	distance1 := ((vNormal.x * vLine[0].x)  +					// Ax +
		         (vNormal.y * vLine[0].y)  +					// Bx +
				 (vNormal.z * vLine[0].z)) + originDistance;	// Cz + D

	// Get the distance from point2 from the plane using Ax + By + Cz + D = (The distance from the plane)

	distance2 := ((vNormal.x * vLine[1].x)  +					// Ax +
		         (vNormal.y * vLine[1].y)  +					// Bx +
				 (vNormal.z * vLine[1].z)) + originDistance;	// Cz + D


  // Ok, we should have 2 distances from the plane, from each point of our line.
	// Remember what I said about an intersection?  If one is negative and one is positive,
	// that means that they are both on either side of the plane.  So, all we need to do
	// is multiply the 2 distances together, and if the result is less than 0, we intersect.
	// This works because, any number times a negative number is always negative, IE (-1 * 1 = -1)
	// If they are both positive or negative values then it will be above zero.
	
	if(distance1 * distance2 >= 0) then			// Check to see if both point's distances are both negative or both positive
  begin
	  result := false;						// Return false if each point has the same sign.  -1 and 1 would mean each point is on either side of the plane.  -1 -2 or 3 4 wouldn't...
    exit;
  end;

	result := true;							// The line intersected the plane, Return TRUE
end;



/////////////////////////////////// DOT \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\*
/////
/////	This computers the dot product of 2 vectors
/////
/////////////////////////////////// DOT \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\*


//float Dot(CVector3 vVector1, CVector3 vVector2)
//{
//	return ( (vVector1.x * vVector2.x) + (vVector1.y * vVector2.y) + (vVector1.z * vVector2.z) );
//}

function Dot(vVector1, vVector2 : TCoord) : glFloat;
begin
	// The dot product is this equation: V1.V2 = (V1.x * V2.x  +  V1.y * V2.y  +  V1.z * V2.z)
	// In math terms, it looks like this:  V1.V2 = ||V1|| ||V2|| cos(theta)
	// The '.' means DOT.   The || || is magnitude.  So the magnitude of V1 times the magnitude
	// of V2 times the cosine of the angle.  It seems confusing now, but it will become more clear.
	// This function is used for a ton of things, which we will cover in other tutorials.
	// For this tutorial, we use it to compute the angle between 2 vectors.  If the vectors
	// are normalize, the dot product returns the cosine of the angle between the 2 vectors.
	// What does that mean? Well, it doesn't return the actual angle, it returns the value of:
	// cos(angle).	Well, what if we want to get the actual angle?  Then we use the arc cosine.
	// There is more on this in the below function AngleBetweenVectors().  Let's give some
	// applications of using the dot product.  How would you tell if the angle between the
	// 2 vectors is perpendicular (90 degrees)?  Well, if we normalize the vectors we can
	// get rid of the ||V1|| * ||V2|| in front, which just leaves us with:  cos(theta).
	// If a vector is normalize, it's magnitude is 1, so it would be: 1 * 1 * cos(theta) ,
	// which is pointless, so we discard that part of the equation.  So, What is the cosine of 90?
	// If you punch it in your calculator you will find that it's 0.  So that means
	// if the dot product of 2 angles is 0, then they are perpendicular.  What we did in
	// our mind is take the arc cosine of 0, which is 90 (or PI/2 in radians).  More on this below.

			 //    (V1.x * V2.x        +        V1.y * V2.y        +        V1.z * V2.z)
	result := ( (vVector1.x * vVector2.x) + (vVector1.y * vVector2.y) + (vVector1.z * vVector2.z) );
end;



/////////////////////////////////////// MAGNITUDE \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\*
/////
/////	This returns the magnitude of a normal (or any other vector)
/////
/////////////////////////////////////// MAGNITUDE \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\*

//float Magnitude(CVector3 vNormal)
//{

//	return (float)sqrt( (vNormal.x * vNormal.x) +
//						(vNormal.y * vNormal.y) +
//						(vNormal.z * vNormal.z) );
//}

function Magnitude(vNormal : TCoord) : GLfloat;
begin
	// This will give us the magnitude or "Norm" as some say, of our normal.
	// Here is the equation:  magnitude = sqrt(V.x^2 + V.y^2 + V.z^2)  Where V is the vector

	result := sqrt( (vNormal.x * vNormal.x) + (vNormal.y * vNormal.y) + (vNormal.z * vNormal.z) );
end;


/////////////////////////////////// ANGLE BETWEEN VECTORS \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\*
/////
/////	This checks to see if a point is inside the ranges of a polygon
/////
/////////////////////////////////// ANGLE BETWEEN VECTORS \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\*

//double AngleBetweenVectors(CVector3 Vector1, CVector3 Vector2)
//{
//	float dotProduct = Dot(Vector1, Vector2);

//	float vectorsMagnitude = Magnitude(Vector1) * Magnitude(Vector2) ;

//	double angle = acos( dotProduct / vectorsMagnitude );

//	if(_isnan(angle))
//		return 0;

//	return( angle );
//}

function AngleBetweenVectors(Vector1, Vector2 :TCoord) : real;
var
  dotProduct : GLfloat;
  vectorsMagnitude : GLfloat;
  angle : real;
begin
	// Remember, above we said that the Dot Product of returns the cosine of the angle
	// between 2 vectors?  Well, that is assuming they are unit vectors (normalize vectors).
	// So, if we don't have a unit vector, then instead of just saying  arcCos(DotProduct(A, B))
	// We need to divide the dot product by the magnitude of the 2 vectors multiplied by each other.
	// Here is the equation:   arc cosine of (V . W / || V || * || W || )
	// the || V || means the magnitude of V.  This then cancels out the magnitudes dot product magnitudes.
	// But basically, if you have normalize vectors already, you can forget about the magnitude part.

	// Get the dot product of the vectors
	dotProduct := Dot(Vector1, Vector2);

	// Get the product of both of the vectors magnitudes
	vectorsMagnitude := Magnitude(Vector1) * Magnitude(Vector2) ;

	// Get the arc cosine of the (dotProduct / vectorsMagnitude) which is the angle in RADIANS.
	// (IE.   PI/2 radians = 90 degrees      PI radians = 180 degrees    2*PI radians = 360 degrees)
	// To convert radians to degress use this equation:   radians * (PI / 180)
	// TO convert degrees to radians use this equation:   degrees * (180 / PI)
	angle := arccos( dotProduct / vectorsMagnitude );

	// Here we make sure that the angle is not a -1.#IND0000000 number, which means indefinate.
	// acos() thinks it's funny when it returns -1.#IND0000000.  If we don't do this check,
	// our collision results will sometimes say we are colliding when we aren't.  I found this
	// out the hard way after MANY hours and already wrong written tutorials :)  Usually
	// this value is found when the dot product and the maginitude are the same value.
	// We want to return 0 when this happens.
	if(isnan(angle)) then
  begin
		result := 0;
    exit;
  end;

	// Return the angle in radians
	result :=  angle;
end;

/////////////////////////////////// INSIDE POLYGON \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\*
/////
/////	This checks to see if a point is inside the ranges of a polygon
/////
/////////////////////////////////// INSIDE POLYGON \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\*

//bool InsidePolygon(CVector3 vIntersection, CVector3 Poly[], long verticeCount)
//{
//	const double MATCH_FACTOR = 0.9999;
//	double Angle = 0.0;
//	CVector3 vA, vB;


//	for (int i = 0; i < verticeCount; i++)
//	{
//		vA = Vector(Poly[i], vIntersection);

//		vB = Vector(Poly[(i + 1) % verticeCount], vIntersection);

//		Angle += AngleBetweenVectors(vA, vB);
//	}



//	if(Angle >= (MATCH_FACTOR * (2.0 * PI)) )
//		return TRUE;

//	return FALSE;
//}


function InsidePolygon(vIntersection : TCoord; Poly :array of TCoord; verticeCount : integer) : boolean;
const
  MATCH_FACTOR : real = 0.9999;		// Used to cover up the error in floating point
var
	Angle : real;						// Initialize the angle
	vA, vB : TCoord;						// Create temp vectors
  I : integer;
begin
  Angle := 0.0;
	// Just because we intersected the plane, doesn't mean we were anywhere near the polygon.
	// This functions checks our intersection point to make sure it is inside of the polygon.
	// This is another tough function to grasp at first, but let me try and explain.
	// It's a brilliant method really, what it does is create triangles within the polygon
	// from the intersection point.  It then adds up the inner angle of each of those triangles.
	// If the angles together add up to 360 degrees (or 2 * PI in radians) then we are inside!
	// If the angle is under that value, we must be outside of polygon.  To further
	// understand why this works, take a pencil and draw a perfect triangle.  Draw a dot in
	// the middle of the triangle.  Now, from that dot, draw a line to each of the vertices.
	// Now, we have 3 triangles within that triangle right?  Now, we know that if we add up
	// all of the angles in a triangle we get 360 right?  Well, that is kinda what we are doing,
	// but the inverse of that.  Say your triangle is an isosceles triangle, so add up the angles
	// and you will get 360 degree angles.  90 + 90 + 90 is 360.

	for i := 0 to verticeCount-1 do		// Go in a circle to each vertex and get the angle between
  begin
		vA := Vector(Poly[i], vIntersection);	// Subtract the intersection point from the current vertex
												// Subtract the point from the next vertex
		vB := Vector(Poly[(i + 1) mod verticeCount], vIntersection);
												
		Angle := Angle + AngleBetweenVectors(vA, vB);	// Find the angle between the 2 vectors and add them all up as we go along
	end;

	// Now that we have the total angles added up, we need to check if they add up to 360 degrees.
	// Since we are using the dot product, we are working in radians, so we check if the angles
	// equals 2*PI.  We defined PI in 3DMath.h.  You will notice that we use a MATCH_FACTOR
	// in conjunction with our desired degree.  This is because of the inaccuracy when working
	// with floating point numbers.  It usually won't always be perfectly 2 * PI, so we need
	// to use a little twiddling.  I use .9999, but you can change this to fit your own desired accuracy.
												
	if(Angle >= (MATCH_FACTOR * (2.0 * PI)) ) then	// If the angle is greater than 2 PI, (360 degrees)
  begin
		result := TRUE;							// The point is inside of the polygon
    exit;
  end;
		
	result := FALSE;								// If you get here, it obviously wasn't inside the polygon, so Return FALSE
end;


/////////////////////////////////// INTERSECTION POINT \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\*
/////
/////	This returns the intersection point of the line that intersects the plane
/////
/////////////////////////////////// INTERSECTION POINT \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\*

//CVector3 IntersectionPoint(CVector3 vNormal, CVector3 vLine[], double distance)
//{
//	CVector3 vPoint = {0}, vLineDir = {0};
//	double Numerator = 0.0, Denominator = 0.0, dist = 0.0;


//	vLineDir = Vector(vLine[1], vLine[0]);		// Get the Vector of the line
//	vLineDir = Normalize(vLineDir);				// Normalize the lines vector

//	Numerator = - (vNormal.x * vLine[0].x +		// Use the plane equation with the normal and the line
//				   vNormal.y * vLine[0].y +
//				   vNormal.z * vLine[0].z + distance);


//	Denominator = Dot(vNormal, vLineDir);		// Get the dot product of the line's vector and the normal of the plane


//	if( Denominator == 0.0)						// Check so we don't divide by zero
//		return vLine[0];						// Return an arbitrary point on the line


//	dist = Numerator / Denominator;				// Divide to get the multiplying (percentage) factor


//	vPoint.x = (float)(vLine[0].x + (vLineDir.x * dist));
//	vPoint.y = (float)(vLine[0].y + (vLineDir.y * dist));
//	vPoint.z = (float)(vLine[0].z + (vLineDir.z * dist));

//	return vPoint;								// Return the intersection point
//}


function IntersectionPoint(vNormal : TCoord; vLine : array of TCoord; distance : glFloat) : TCoord;
var
  vPoint : TCoord;
  vLineDir : TCoord;
  Numerator : real;
  Denominator : real;
  dist : real;
begin

  // Variables to hold the point and the line's direction
  vPoint.X := 0;
  vPoint.Y := 0;
  vPoint.Z := 0;

  vLineDir.X := 0;
  vLineDir.Y := 0;
  vLineDir.Z := 0;

	Numerator := 0.0;
  Denominator := 0.0;
  dist := 0.0;

	// Here comes the confusing part.  We need to find the 3D point that is actually
	// on the plane.  Here are some steps to do that:

	// 1)  First we need to get the vector of our line, Then normalize it so it's a length of 1
	vLineDir := Vector(vLine[1], vLine[0]);		// Get the Vector of the line
	vLineDir := Normalize(vLineDir);				// Normalize the lines vector


	// 2) Use the plane equation (distance = Ax + By + Cz + D) to find the distance from one of our points to the plane.
	//    Here I just chose a arbitrary point as the point to find that distance.  You notice we negate that
	//    distance.  We negate the distance because we want to eventually go BACKWARDS from our point to the plane.
	//    By doing this is will basically bring us back to the plane to find our intersection point.
	Numerator := - (vNormal.x * vLine[1].x +		// Use the plane equation with the normal and the line
				   vNormal.y * vLine[1].y +
				   vNormal.z * vLine[1].z + distance);

	// 3) If we take the dot product between our line vector and the normal of the polygon,
	//    this will give us the cosine of the angle between the 2 (since they are both normalized - length 1).
	//    We will then divide our Numerator by this value to find the offset towards the plane from our arbitrary point.
	Denominator := Dot(vNormal, vLineDir);		// Get the dot product of the line's vector and the normal of the plane

	// We divide the (distance from the point to the plane) by (the dot product)
	// to get the distance (dist) that we need to move from our arbitrary point.  We need
	// to then times this distance (dist) by our line's vector (direction).  When you times
	// a scalar (single number) by a vector you move along that vector.  That is what we are
	// doing.  We are moving from our arbitrary point we chose from the line BACK to the plane
	// along the lines vector.  It seems logical to just get the numerator, which is the distance
	// from the point to the line, and then just move back that much along the line's vector.
	// Well, the distance from the plane means the SHORTEST distance.  What about in the case that
	// the line is almost parallel with the polygon, but doesn't actually intersect it until half
	// way down the line's length.  The distance from the plane is short, but the distance from
	// the actual intersection point is pretty long.  If we divide the distance by the dot product
	// of our line vector and the normal of the plane, we get the correct length.  Cool huh?

	if( Denominator = 0.0) then						// Check so we don't divide by zero
  begin
		result := vLine[0];						// Return an arbitrary point on the line
    exit;
  end;

	// We divide the (distance from the point to the plane) by (the dot product)
	// to get the distance (dist) that we need to move from our arbitrary point.  We need
	// to then times this distance (dist) by our line's vector (direction).  When you times
	// a scalar (single number) by a vector you move along that vector.  That is what we are
	// doing.  We are moving from our arbitrary point we chose from the line BACK to the plane
	// along the lines vector.  It seems logical to just get the numerator, which is the distance
	// from the point to the line, and then just move back that much along the line's vector.
	// Well, the distance from the plane means the SHORTEST distance.  What about in the case that
	// the line is almost parallel with the polygon, but doesn't actually intersect it until half
	// way down the line's length.  The distance from the plane is short, but the distance from
	// the actual intersection point is pretty long.  If we divide the distance by the dot product
	// of our line vector and the normal of the plane, we get the correct length.  Cool huh?

	dist := Numerator / Denominator;				// Divide to get the multiplying (percentage) factor

	// Now, like we said above, we times the dist by the vector, then add our arbitrary point.
	// This essentially moves the point along the vector to a certain distance.  This now gives
	// us the intersection point.  Yay!

	vPoint.x := (vLine[0].x + (vLineDir.x * dist));
	vPoint.y := (vLine[0].y + (vLineDir.y * dist));
	vPoint.z := (vLine[0].z + (vLineDir.z * dist));

	result := vPoint;								// Return the intersection point
end;

/////////////////////////////////// INTERSECTED POLYGON \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\*
/////
/////	This checks if a line is intersecting a polygon
/////
/////////////////////////////////// INTERSECTED POLYGON \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\*

//bool IntersectedPolygon(CVector3 vPoly[], CVector3 vLine[], int verticeCount)
//{
//	CVector3 vNormal = {0};
//	float originDistance = 0;


//	if(!IntersectedPlane(vPoly, vLine,   vNormal,   originDistance))
//		return false;


//	CVector3 vIntersection = IntersectionPoint(vNormal, vLine, originDistance);


//	if(InsidePolygon(vIntersection, vPoly, verticeCount))
//		return true;							// We collided!	  Return success


//	return false;								// There was no collision, so return false
//}

function IntersectedPolygon(vPoly : array of TCoord; vLine : array of TCoord; verticeCount : integer):boolean;
var
  vNormal : TCoord;
  vIntersection : TCoord;
  originDistance : glFloat;
begin
	vNormal.X := 0;
  vNormal.Y := 0;
  vNormal.Z := 0;

	originDistance := 0;

	// First we check to see if our line intersected the plane.  If this isn't true
	// there is no need to go on, so return false immediately.
	// We pass in address of vNormal and originDistance so we only calculate it once

									                        // Reference   // Reference
	if(not IntersectedPlane(vPoly, vLine,   vNormal,   originDistance)) then
  begin
		result := false;
    exit;
  end;

	// Now that we have our normal and distance passed back from IntersectedPlane(),
	// we can use it to calculate the intersection point.  The intersection point
	// is the point that actually is ON the plane.  It is between the line.  We need
	// this point test next, if we are inside the polygon.  To get the I-Point, we
	// give our function the normal of the plan, the points of the line, and the originDistance.

	vIntersection := IntersectionPoint(vNormal, vLine, originDistance);

	// Now that we have the intersection point, we need to test if it's inside the polygon.
	// To do this, we pass in :
	// (our intersection point, the polygon, and the number of vertices our polygon has)

	if(InsidePolygon(vIntersection, vPoly, verticeCount)) then
  begin
		result := true;							// We collided!	  Return success
    exit;
  end;


	// If we get here, we must have NOT collided

	result := false;								// There was no collision, so return false
end;
 

end.
