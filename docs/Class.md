# Classes

## Defining Classes

```lua
-- Define a class called MyClass.
AegisLib.Class( 'MyClass', {
    New = function( self, x )
        self.x = x
    end,

    Add = function( self, a, b )
        return (a + b) * x
    end
})
```

## Deriving Classes

```lua
-- Define a class derived from MyClass.
AegisLib.Class( 'MyDerivedClass', {
    Add = function( self, a, b )
        -- Call the inherited Add method through self.SUPER.
        return self.SUPER.Add( self, a, b ) * 10
    end
}, 'MyClass' )
```

## Instantiating Classes

```lua
local myClass = AegisLib.New( 'MyClass', 10 )
local myDerivedClass = AegisLib.New( 'MyDerivedClass', 10 )

print( myClass:Add( 5, 5 ) ) -- Outputs 100
print( myDerivedClass:Add( 5, 5 ) ) -- Outputs 1000
```
