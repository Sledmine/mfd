local inspect = require "inspect"
local htmlparser = require "htmlparser"
local glue = require "glue"

-- https://github.com/lwthiker/curl-impersonate
-- curl_chrome104 is a wrapper around curl that sets the user agent to Chrome 104
-- This is needed because the website checks our request and returns a 403 if not a browser
local curlCmdTemplate = [[curl_chrome104 -s -L %s]]
local curlCmdDownloadFileTemplate = "curl %s -o %s"

local curlCmdStream = assert(io.popen(curlCmdTemplate:format(arg[1]), "r"))
local htmlString = curlCmdStream:read('*all')
curlCmdStream:close()

local root = htmlparser.parse(htmlString)

local elements = root("#downloadButton")

for _, e in pairs(elements) do
    local downloadLink = e.attributes.href
    local splitUrl = glue.string.split(downloadLink, "/")
    local fileName = splitUrl[#splitUrl]
    os.execute(curlCmdDownloadFileTemplate:format(downloadLink, fileName))
    os.exit(0)
end
print("Error, No download link was found.")
os.exit(1)