AegisLib.Classes = { }

-- Define a class.
function AegisLib.Class( name, definition, super )
    local class = definition
    class.CLASS_NAME = name
    class.SUPER_NAME = super
    class.SUPER = nil

    AegisLib.Classes[ name ] = class
end


-- Instantiate a class.
function AegisLib.New( name, ... )
    local class = AegisLib.Classes[ name ]

    if ( !class ) then
        error("undefined class '" .. name .. "'")
    end

    -- Resolve and cache super class if needed.
    if ( !class.SUPER ) then
        class.SUPER = AegisLib.Classes[ class.SUPER_NAME ]
        rawset( class, '__index', class.SUPER )
    end

    -- Copy class fields and methods into instance.
    -- Avoids __index lookups for normal method accesses.
    -- Only super accesses cause a lookup.
    local instance = setmetatable( table.Copy( class ), class )

    -- Call constructor if one is defined.
    if ( instance.New ) then
        instance:New( ... )
    end

    return instance
end
