unit collide;

interface
uses OpenGL,Math,glTypes;


  function IntersectedPolygon(vPoly : array of TCoord; vLine : array of TCoord; verticeCount : integer):boolean;


implementation

// Description : Collision detection project

{------------------------------------------------------------------}
{  Test for intersection on polygon with line                      }
{------------------------------------------------------------------}
function IntersectedPolygon(vPoly : array of TCoord; vLine : array of TCoord; verticeCount : integer):boolean;
const
  // Used to cover up the error in floating point
  MATCH_FACTOR : Extended = 0.9999999999;
var
  vNormal : TCoord;
  vIntersection : TCoord;
  originDistance : Extended;
  distance1 : Extended;
  distance2 : Extended;
  vVector1 : TCoord;
  vVector2 : TCoord;
  m_magnitude : Double;
  vPoint : TCoord;
  vLineDir : TCoord;
  Numerator : Extended;
  Denominator : Extended;
  dist : Extended;
  Angle,tempangle : Extended;						// Initialize the angle
	vA, vB : TCoord;						// Create temp vectors
  I : integer;
  dotProduct : Extended;
  vectorsMagnitude : Extended;
begin
	vNormal.X := 0;
  vNormal.Y := 0;
  vNormal.Z := 0;

	originDistance := 0;
  distance1 := 0;
  distance2 := 0;	 // The distances from the 2 points of the line from the plane
  vPoint.X := 0;
  vPoint.Y := 0;
  vPoint.Z := 0;

  vLineDir.X := 0;
  vLineDir.Y := 0;
  vLineDir.Z := 0;

	Numerator := 0.0;
  Denominator := 0.0;
  dist := 0.0;
  Angle := 0.0;

  {----------------------------------------------------------------------------}
  { First we check to see if our line intersected the plane.                   }
  { If this isn't true there is no need to go on, so return false immediately. }
	{ We pass in address of vNormal and originDistance                           }
  { so we only calculate it once                                               }
  {                                                                            }
  { In order to get a vector from 2 points (a direction) we need to            }
	{ subtract the second point from the first point.                            }
  {----------------------------------------------------------------------------}

  //vector
  vVector1.x := vPoly[2].x - vPoly[0].x;    // Get the X value of our new vector
	vVector1.y := vPoly[2].y - vPoly[0].y;    // Get the Y value of our new vector
	vVector1.z := vPoly[2].z - vPoly[0].z;    // Get the Z value of our new vector
  //vector
  vVector2.x := vPoly[1].x - vPoly[0].x;    // Get the X value of our new vector
	vVector2.y := vPoly[1].y - vPoly[0].y;		// Get the Y value of our new vector
	vVector2.z := vPoly[1].z - vPoly[0].z;		// Get the Z value of our new vector

  {----------------------------------------------------------------------------}
  { Once again, if we are given 2 vectors (directions of 2 sides of a polygon) }
	{ then we have a plane define.                                               }
  { The cross product finds a vector that is perpendicular to that plane,      }
  { which means it's point straight out of the plane at a 90 degree angle.     }
  {----------------------------------------------------------------------------}

  //cross

  // The X value for the vector is:  (V1.y * V2.z) - (V1.z * V2.y)
	vNormal.x := ((vVector1.y * vVector2.z) - (vVector1.z * vVector2.y));
  // The Y value for the vector is:  (V1.z * V2.x) - (V1.x * V2.z)
	vNormal.y := ((vVector1.z * vVector2.x) - (vVector1.x * vVector2.z));
  // The Z value for the vector is:  (V1.x * V2.y) - (V1.y * V2.x)
	vNormal.z := ((vVector1.x * vVector2.y) - (vVector1.y * vVector2.x));

  //normalize

  {----------------------------------------------------------------------------}
  { This will give us the magnitude or "Norm" as some say, of our normal.      }
  { Here is the equation:  magnitude = sqrt(V.x^2 + V.y^2 + V.z^2)             }
  { Where V is the vector                                                      }
  {----------------------------------------------------------------------------}

  // Get the magnitude of our normal
  m_magnitude := sqrt((vNormal.x * vNormal.x) +
                      (vNormal.y * vNormal.y) +
                      (vNormal.z * vNormal.z) );

  {----------------------------------------------------------------------------}
  { Now that we have the magnitude, we can divide our normal by that magnitude.}
	{ That will make our normal a total length of 1.                             }
  { This makes it easier to work with too.                                     }
  {----------------------------------------------------------------------------}

	vNormal.x := vNormal.x/m_magnitude; // Divide the X value of our normal by it's magnitude
	vNormal.y := vNormal.y/m_magnitude;	// Divide the Y value of our normal by it's magnitude
	vNormal.z := vNormal.z/m_magnitude;	// Divide the Z value of our normal by it's magnitude

  //plane distance

  {----------------------------------------------------------------------------}
  { Let's find the distance our plane is from the origin.                      }
  { We can find this value from the normal to the plane (polygon)              }
	{ and any point that lies on that plane (Any vertex)                         }
  {                                                                            }
  { Use the plane equation to find the distance (Ax + By + Cz + D = 0)         }
  { We want to find D. So, we come up with D = -(Ax + By + Cz)                 }
  {----------------------------------------------------------------------------}

  originDistance := -1 * ((vNormal.x * vPoly[0].x) +
                          (vNormal.y * vPoly[0].y) +
                          (vNormal.z * vPoly[0].z));

  // Get the distance from point1 from the plane using:
  //Ax + By + Cz + D = (The distance from the plane)
	distance1 := ((vNormal.x * vLine[0].x)  +         // Ax +
		         (vNormal.y * vLine[0].y)  +            // Bx +
				 (vNormal.z * vLine[0].z)) + originDistance;// Cz + D

  // Get the distance from point2 from the plane using
  //Ax + By + Cz + D = (The distance from the plane)
	distance2 := ((vNormal.x * vLine[1].x)  +         // Ax +
		         (vNormal.y * vLine[1].y)  +            // Bx +
				 (vNormal.z * vLine[1].z)) + originDistance;// Cz + D


  {----------------------------------------------------------------------------}
  { Now that we have 2 distances from the plane,                               }
  { if we times them together we either get a positive or negative number.     }
	{ If it's a negative number, that means we collided!                         }
	{ This is because the 2 points must be on either side of the plane           }
  { (IE. -1 * 1 = -1).                                                         }
  {----------------------------------------------------------------------------}

  // Check to see if both point's distances are both negative or both positive
	if(distance1 * distance2 >= 0) then
  begin
    // Return false if each point has the same sign.
    //-1 and 1 would mean each point is on either side of the plane.
    //-1 -2 or 3 4 wouldn't...
	  result := false;
    exit;
  end;

  vLineDir.x := vLine[1].x - vLine[0].x;    // Get the X value of our new vector
	vLineDir.y := vLine[1].y - vLine[0].y;    // Get the Y value of our new vector
	vLineDir.z := vLine[1].z - vLine[0].z;    // Get the Z value of our new vector

  //normalize

  // Get the magnitude of our normal
  m_magnitude := sqrt((vLineDir.x * vLineDir.x) +
                      (vLineDir.y * vLineDir.y) +
                      (vLineDir.z * vLineDir.z) );

   

	vLineDir.x := vLineDir.x/m_magnitude;// Divide the X value of our normal by it's magnitude
	vLineDir.y := vLineDir.y/m_magnitude;// Divide the Y value of our normal by it's magnitude
	vLineDir.z := vLineDir.z/m_magnitude;// Divide the Z value of our normal by it's magnitude


  {-------------------------------------------------------------------------- 
  { Use the plane equation (distance = Ax + By + Cz + D)                       }
  { to find the distance from one of our points to the plane.                  }
	{ Here I just chose a arbitrary point as the point to find that distance.    }
  { You notice we negate that distance.                                        }
  { We negate the distance because we want to eventually go BACKWARDS          }
  { from our point to the plane.                                               }
	{ By doing this is will basically bring us back to the plane                 }
  { to find our intersection point.                                            }
  {----------------------------------------------------------------------------}

  // Use the plane equation with the normal and the line
	Numerator := -1 * (vNormal.x * vLine[0].x +
          				   vNormal.y * vLine[0].y +
				             vNormal.z * vLine[0].z + originDistance);

  {----------------------------------------------------------------------------}
	{ (3)                                                                        }
  { We take the dot product between our line vector and normal of the polygon  }
	{ This will give us the cosine of the angle between the 2                    }
  { (since they are both normalized - length 1).                               }
	{ We will then divide our Numerator by this value,                           }
  { to find the offset towards the plane from our arbitrary point.             }
  {----------------------------------------------------------------------------}

  // Get the dot product of the line's vector and the normal of the plane
	Denominator := ( (vNormal.x * vLineDir.x) + (vNormal.y * vLineDir.y) + (vNormal.z * vLineDir.z) );

	if( Denominator = 0.0) then	 // Check so we don't divide by zero
  begin
		vIntersection := vLine[0]; // Return an arbitrary point on the line
  end
  else
  begin

  {----------------------------------------------------------------------------}
	{ We divide the (distance from the point to the plane) by (the dot product)  }
	{ to get the distance (dist) that we need to move from our arbitrary point.  }
  { We need to then times this distance (dist) by our line's vector (direction)}
  { When you times a scalar (single number)                                    }
  { by a vector you move along that vector. That is what we are doing.         }
	{ We are moving from our arbitrary point                                     }
  { we chose from the line BACK to the plane along the lines vector.           }
	{ It seems logical to just get the numerator, which is the distance          }
	{ from the point to the line,                                                }
  { and then just move back that much along the line's vector.                 }
	{ Well, the distance from the plane means the SHORTEST distance.             }
  { What about in the case that the line is almost parallel with the polygon   }
  { but doesn't actually intersect it until half way down the line's length?   }
	{ The distance from the plane is short, but the distance from                }
	{ the actual intersection point is pretty long.                              }
  { If we divide the distance by the dot product of our line vector            }
	{ and the normal of the plane, we get the correct length.  Cool huh?         }
  {----------------------------------------------------------------------------}

    // Divide to get the multiplying (percentage) factor
  	dist := Numerator / Denominator;

  {----------------------------------------------------------------------------}
  { Now, like we said above, we times the dist by the vector,                  }
  { then add our arbitrary point.                                              }
  { This essentially moves the point along the vector to a certain distance.   }
  { This now gives us the intersection point.  Yay!                            }
  {----------------------------------------------------------------------------}

  	vPoint.x := (vLine[0].x + (vLineDir.x * dist));
  	vPoint.y := (vLine[0].y + (vLineDir.y * dist));
  	vPoint.z := (vLine[0].z + (vLineDir.z * dist));

  	vIntersection := vPoint;								// Return the intersection point
  end;

  {----------------------------------------------------------------------------}
	{ Now that we have the intersection point,                                   }
  { we need to test if it's inside the polygon.                                }
	{ To do this, we use :                                                       }
	{   Our intersection point,                                                  }
  {   The polygon,                                                             }
  {   And the number of vertices our polygon has                               }
  {----------------------------------------------------------------------------}

  {----------------------------------------------------------------------------}
  { Just because we intersected the plane,                                     }
  { doesn't mean we were anywhere near the polygon.                            }
	{ We need to check our intersection point                                    }
  { to make sure it is inside of the polygon.                                  }
  { This is another tough function to grasp at first,                          }
  { but let me try and explain.                                                }
	{ It's a brilliant method really,                                            }
  { what it does is create triangles within the polygon                        }
	{ from the intersection point.                                               }
  { It then adds up the inner angle of each of those triangles.                }
	{ If the angles together add up to 360 degrees                               }
  { (or 2 * PI in radians) then we are inside!                                 }
	{ If the angle is under that value, we must be outside of polygon.           }
  { To further understand why this works,                                      }
  { take a pencil and draw a perfect triangle.                                 }
  { Draw a dot in the middle of the triangle.                                  }
	{ Now, from that dot, draw a line to each of the vertices.                   }
	{ Now, we have 3 triangles within that triangle right?                       }
  { We know that if we add up all of the angles in a triangle we get 360 right?}
	{ Well, that is kinda what we are doing, but the inverse of that.            }
	{ Say your triangle is an isosceles triangle, so add up the angles           }
	{ and you will get 360 degree angles.  90 + 90 + 90 is 360.                  }
  {----------------------------------------------------------------------------}

  // Go in a circle to each vertex and get the angle between
  for i := 0 to verticeCount-1 do
  begin

    // Subtract the intersection point from the current vertex
    // Get the X value of our new vector
    vA.x := vPoly[i].x - vIntersection.x;
    // Get the Y value of our new vector
	  vA.y := vPoly[i].y - vIntersection.y;
    // Get the Z value of our new vector
	  vA.z := vPoly[i].z - vIntersection.z;

    // Subtract the point from the next vertex
    // Get the X value of our new vector
    vB.x := vPoly[(i + 1) mod verticeCount].x - vIntersection.x;
    // Get the Y value of our new vector
	  vB.y := vPoly[(i + 1) mod verticeCount].y - vIntersection.y;
    // Get the Z value of our new vector
	  vB.z := vPoly[(i + 1) mod verticeCount].z - vIntersection.z;

  {----------------------------------------------------------------------------}
  { Remember, we said that the Dot Product of returns the cosine of the angle  }
  { between 2 vectors?                                                         }
  { Well, that is assuming they are unit vectors (normalize vectors).          }
	{ So, if we don't have a unit vector,                                        }
  { then instead of just saying  arcCos(DotProduct(A, B))                      }
	{ We need to divide the dot product                                          }
  { by the magnitude of the 2 vectors multiplied by each other.                }
	{ Here is the equation:   arc cosine of (V . W / || V || * || W || )         }
	{ the || V || means the magnitude of V.                                      }
  { This then cancels out the magnitudes dot product magnitudes.               }
  { But basically, if you have normalize vectors already,                      }
  { you can forget about the magnitude part.                                   }
  {----------------------------------------------------------------------------}

  	// Get the dot product of the vectors
    dotProduct := ( (vA.x * vB.x) +
                    (vA.y * vB.y) +
                    (vA.z * vB.z) );

  	// Get the product of both of the vectors magnitudes
	  vectorsMagnitude := sqrt(
                     extended(vA.x * vA.x) +
                     extended(vA.y * vA.y) +
                     extended(vA.z * vA.z)
                          )
                          *
                     sqrt(
                     extended(vB.x * vB.x) +
                     extended(vB.y * vB.y) +
                     extended(vB.z * vB.z)
                          );

  {----------------------------------------------------------------------------}
  { Get the arc cosine of the (dotProduct / vectorsMagnitude)                  }
  { which is the angle in RADIANS.                                             }
  { IE:                                                                        }
  {   PI/2 radians = 90 degrees                                                }
  {   PI radians = 180 degrees                                                 }
  {   2*PI radians = 360 degrees                                               }
  {                                                                            }
  { To convert radians to degress use this equation:   radians * (PI / 180)    }
  { To convert degrees to radians use this equation:   degrees * (180 / PI)    }
  {----------------------------------------------------------------------------}


	 tempangle := arccos( dotProduct / vectorsMagnitude );

  {----------------------------------------------------------------------------}
	{ Here we make sure that the angle is not a -1.#IND0000000 number,           }
  { which means indefinate.                                                    }
  { acos() thinks it's funny when it returns -1.#IND0000000.                   }
  { If we don't do this check,                                                 }
  { our collision results will sometimes say we are colliding when we aren't.  }
  { I found this out the hard way after MANY hours                             }
  { and already wrong written tutorials :)                                     }
  { Usually this value is found when the dot product and the maginitude        }
  { are the same value.                                                        }
	{ We want to set tempangle = 0 when this happens.                            }
  {----------------------------------------------------------------------------}

	  if(isnan(tempangle)) then
    begin
  		tempangle := 0;
    end;

  	// add the current tempangle to Angle in radians
	  Angle := Angle + tempangle;
  end;

  {----------------------------------------------------------------------------}
	{ Now that we have the total angles added up,                                }
  { we need to check if they add up to 360 degrees.                            }
	{ Since we are using the dot product, we are working in radians,             }
  { so we check if the angles equals 2*PI.                                     }
  { You will notice that we use MATCH_FACTOR in conjunction with our 2*PI.     }
  { This is because of the inaccuracy when working with floating point numbers.}
  { It usually won't always be perfectly 2 * PI, so we need                    }
  { to use a little twiddling.                                                 }
  { I(Digiben) use .9999,                                                      }
  { but you can change this to fit your own desired accuracy.                  }
  { For the Delphi version I am using 0.9999999999 because im using extended   }
  { and not double (float in c++)                                              }
  {----------------------------------------------------------------------------}

  // If the angle is greater than 2 PI, (360 degrees)
	if(Angle >= (MATCH_FACTOR * (2.0 * PI)) ) then
  begin
		result := TRUE;							// The point is inside of the polygon
    exit;                       // We collided!	  Return success
  end;


	// If we get here, we must have NOT collided

	result := false; // There was no collision, so return false
end;

end.
