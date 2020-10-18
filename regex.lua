
-- Parser Combinators --

local function char(c)
    return function(s)
        if c == string.sub(s, 1, 1) then
            return string.sub(s, 2)
        else
            return nil
        end
    end
end

local function many(p)
    return function(s)
        while true do
            local r = p(s)
            if r == nil then
                return s
            end
            s = r
        end
    end
end

local function alt(lp, rp)
    return function(s)
        local r1 = lp(s)
        local r2 = rp(s)
        if r1 == nil then
            return r2
        elseif r2 == nil then
            return r1
        elseif string.len(r1) <= string.len(r2) then
            return r1
        else
            return r2
        end
    end
end

local function seq(lp, rp)
    return function(s)
        local r = lp(s)
        if r == nil then
            return nil
        end
        return rp(r)
    end
end

------------------------

print('Do these strings match this regex? a*bb* | aa*bc* | ef')

local a, b, c, e, f = char 'a', char 'b', char 'c', char 'e', char 'f'
local parser = alt(
    seq(many(a), seq(b, many(b))),             -- a*bb*
    alt(
        seq(a, seq(many(a), seq(b, many(c)))), -- aa*bc*
        seq(e, f)                              -- ef
    )
)

for _, s in ipairs {'aaaab', 'b', 'bbbbbbbcccc', 'abc', 'bca', 'ef', 'ac', 'ab', ''} do
    print(string.format('"%s": %s', s, parser(s) == ''))
end

