-- collector_mini.lua | Roblox game data collector | Nexomia
local L,R,M={},{},{}
local RS=game:GetService("ReplicatedStorage")
local WS=game:GetService("Workspace")
local LP=game:GetService("Players").LocalPlayer

local function hook(root)
    for _,o in ipairs(root:GetDescendants())do
        local cn=o.ClassName
        if cn=="RemoteEvent"or cn=="RemoteFunction"then
            local k=o:GetFullName()
            R[k]=R[k]or{name=o.Name,calls={}}
            local fn=cn=="RemoteEvent"and"FireServer"or"InvokeServer"
            local old=o[fn]
            o[fn]=function(s,...)
                local a={}
                for i,v in ipairs({...})do a[i]=typeof(v)..":"..tostring(v):sub(1,30)end
                table.insert(R[k].calls,{t=math.floor(tick()),a=table.concat(a,"|")})
                return old(s,...)
            end
        end
    end
end

local function mods(root,d)
    d=d or 0
    if d>3
