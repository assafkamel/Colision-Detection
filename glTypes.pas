unit glTypes;

interface
uses OpenGL;
type
  TCoord = Record
    X, Y, Z : glFLoat;
  end;
  TFace = Record
    Vectors : array[1..4] of TCoord;
  end;
  TLine = Record
    StartPoint : TCoord;
    EndPoint : TCoord;
  end;

implementation

end.
