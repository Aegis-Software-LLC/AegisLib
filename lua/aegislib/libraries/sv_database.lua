--
require("mysqloo");

AegisLib.Database = {};
AegisLib.Database.__index = AegisLib.Database;

AegisLib.Database.DB = nil;

function AegisLib.Database:new(host, user, password, database, port)
    if(!port) then port = 3306 end;

    local tbl = {
        connected = false,
        err = false
    }

    local DBObject = mysqloo.connect(host, user, password, database, port);
    print(DBObject);

    function DBObject:onConnected()
        AegisLib.Log(1, "Database Initialization Finished.");
        tbl.connected = true;
    end

    function DBObject:onConnectionFailed(err)
        AegisLib.Log(3, "Database connection failed! Error: %s", err);

        tbl.err = err;

        return err;
    end

    DBObject:connect();

    setmetatable(tbl, AegisLib.Database);
    //setmetatable(DBObject, AegisLib.Database.DB);

    AegisLib.Database.DB = DBObject;

    return AegisLib.Database;
end

function AegisLib.Database:Close()

end

function AegisLib.Database:Query(q, params, callback)
    q = self.DB:prepare(q);

    for k, v in pairs(params) do
        if(type(v)== "string") then
            q:setString(k, v);
        elseif(type(v)== "number") then
            q:setNumber(k, v);
        elseif(type(v)== "bool") then
            q:setBoolean(k, v);
        elseif(v == nil) then
            q:setNull(k, v);
        end
    end

    function q:onSuccess(data)
        AegisLib.Log(1, "MySQL prepared query executed with no errors.");
        if(type(data)== "table") then
            PrintTable(data);
        else
            print(data);
        end
        -- Query was successful. Now let's run the callback to use the data from the query, if there is a callback available.
        -- Callback will still execute if no data is returned, however the data argument will be 0
        if(callback) then
            if(table.IsEmpty(data) || !data[1] || !data) then callback(0) return end;
            callback(data);
        end
    end

    function q:onError(err, sql)
        AegisLib.Log(3, "Uh oh! An SQL query failed.\n----------\nError: %s\n----------\nQuery: %s\n----------", err, queryStr);

        if(callback) then callback(err); end
    end

    q:start();
end

setmetatable(AegisLib.Database, {__call = AegisLib.Database.new});

AegisLib.Log(1, "Database module loaded!");