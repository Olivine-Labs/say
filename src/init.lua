local registry = { }
local current_namespace
local fallback_namespace

local s = {

  set_namespace = function(self, namespace)
    current_namespace = namespace
    if not registry[current_namespace] then
      registry[current_namespace] = {}
    end
  end,

  set_fallback = function(self, namespace)
    fallback_namespace = namespace
    if not registry[fallback_namespace] then
      registry[fallback_namespace] = {}
    end
  end,

  set = function(self, key, value)
    registry[current_namespace][key] = value
  end
}

local __meta = {
  __call = function(self, key, vars)
    vars = vars or {}
    local str = tostring(registry[current_namespace][key] or registry[fallback_namespace][key] or '')
    local strings = {}

    for i,v in ipairs(vars) do
      table.insert(strings, tostring(v))
    end

    return #strings > 0 and str:format(unpack(strings)) or str
  end,

  __index = function(self, key)
    return registry[key]
  end
}

s:set_fallback('en')
s:set_namespace('en')

if _TEST then
  s._registry = registry -- force different name to make sure with _TEST behaves exactly as without _TEST
end

return setmetatable(s, __meta)
