------------------------------------------------------------------------------- 
-- Lua module for making requests to the amazon affiliate program API.         
------------------------------------------------------------------------------- 


-- We're using the luacrypto library for the cryptographic signing
require "crypto"
require "base64"
require "io"

local function timestamp()
    return os.date("!%Y-%m-%dT%H:%M:%SZ")
end

--[[ requester is the main base class for making item searches on amazon. it works as follow:
    r = requester:new() -- gets you a new copy of the class
    -- Now fill in your request terms for the amazon api as you like
    -- The following are required terms
    r.PrivateKey     = [AWSPrivateKey] -- fill in your private key
    r.AWSAccessKeyID = [AWSaccessKey]  -- fill in your public key
    r.KeyWords       = [Search KeyWords] -- fill in the thing you want to search for
    url = r:request() -- right now the request function returns the product search url signed
                      -- with your private key. in the future this will return the resulting xml

]]--
requester = {}

function requester:new(confFileName) 

    newRequester = {
        searchTerms = {
            "AWSAccessKeyId" ,
            "AssociateTag"   ,
            "ItemId"         ,
            "Keywords"       ,  -- A string is required
            "MaximumPrice"   ,  -- A string or int will do.  "3241"/3241 represents $32.41
            "MerchantID"     ,  -- A string -- we probably won't use this for now
            "MinimumPrice"   ,  -- A string or int will do.  "3241"/3241 represents $32.41
            "Operation"      ,
            "ResponseGroup"  ,
            "Sort"           ,
            "SearchIndex"    ,
            "Service"        ,
            "Timestamp"      ,
            "Version"
        }, 
        Operation    = "ItemSearch",
        PrivateKey   = false,
    }
    if confFileName then
        for line in io.lines(confFileName) do
            words = line:gmatch("%S+")
            key = words()
            val = words()
            for i,term in pairs(newRequester['searchTerms']) do
                if key == term then
                    newRequester[key] = val
                end
            end

            if key == "PrivateKey" then -- We're handling this one separately for now
                newRequester["PrivateKey"] = val
            end

        end
    end

    self.__index = self
    return setmetatable(newRequester, self)
end

function requester:request()
    urlBase = 'http://webservices.amazon.com/onca/xml?'
    requestString = ''

    --Get a fresh timestamp before we generate the request
    self["Timestamp"] = timestamp()
    --self["Timestamp"] = "2009-01-01T12:00:00Z" --This is only for debugging

    for i,key in pairs(self.searchTerms) do
        if self[key] then
            requestString = requestString..'&' ..key ..'=' ..self[key]
        end
    end
    requestString = urlencode(requestString)
    stringToSign  = "GET\nwebservices.amazon.com\n/onca/xml\n" ..requestString:sub(2) 
    --stringToSign  = "GET\necs.amazonaws.co.uk\n/onca/xml\n" ..requestString:sub(2) 
    print(stringToSign)
    if self.PrivateKey then
        signature = crypto.hmac.digest("sha256", stringToSign, self.PrivateKey, true)
        signature = enc(signature)
        signature = urlencode(signature, true)
        requestString = requestString ..'&Signature=' ..signature
    end
    requestString = urlBase ..requestString
    return requestString
end

-- This is straight up stolen from here - https://gist.github.com/ignisdesign/4323051
-- TODO space handling is borked. amazon wants  %20 
function urlencode(str, strict)
    if (str) then
        str = string.gsub (str, "\n", "\r\n")
        if strict then
            str = string.gsub (str, "([^%w])",--Added the hyphen, ampersands and equals
                function (c) return string.format ("%%%02X", string.byte(c)) end)
        else
            str = string.gsub (str, "([^%w-&= ])",--Added the hyphen, ampersands and equals
                function (c) return string.format ("%%%02X", string.byte(c)) end)
        end
        str = string.gsub (str, " ", "%%20")
    end
    return str    
end
